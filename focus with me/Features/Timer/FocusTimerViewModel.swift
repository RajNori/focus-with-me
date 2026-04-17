import Foundation
import Combine
import AVFoundation
import UIKit

enum AmbientSound: CaseIterable, Equatable {
    case off
    case rain
    case cafe
    case whiteNoise
}

final class FocusTimerViewModel: ObservableObject {

    // MARK: - Published State

    @Published var timeRemaining: Int = 1500
    @Published var isRunning: Bool = false
    @Published var selectedDuration: Int = 1500
    @Published var sessionCompleted: Bool = false
    @Published var presenceCount: Int = 2431
    @Published var selectedSound: AmbientSound = .off
    @Published var ambientToast: String?

    // MARK: - Private

    private var timerCancellable: AnyCancellable?
    private var presenceCancellable: AnyCancellable?
    private var ambientPlayers: [AmbientSound: AVAudioPlayer] = [:]
    private var activeAmbientPlayer: AVAudioPlayer?
    private var ambientToastWorkItem: DispatchWorkItem?

    // MARK: - Init

    init() {
        configureAudioSessionIfNeeded()
        preloadAmbientPlayersIfNeeded()
        startPresenceSimulation()
    }

    deinit {
        stopAmbientPlayback()
    }

    // MARK: - Timer Controls

    func start() {
        if isRunning { return }

        if sessionCompleted {
            reset()
        }

        if timeRemaining == 0 {
            timeRemaining = selectedDuration
        }

        isRunning = true

        timerCancellable = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    func pause() {
        timerCancellable?.cancel()
        isRunning = false
    }

    func reset() {
        timerCancellable?.cancel()
        isRunning = false
        sessionCompleted = false
        timeRemaining = selectedDuration
    }

    func updateSelectedDuration(_ duration: Int) {
        selectedDuration = duration

        guard !isRunning else { return }
        sessionCompleted = false
        timeRemaining = duration
    }

    // MARK: - Ambient Audio

    func cycleAmbientSound() {
        let all = AmbientSound.allCases
        guard let index = all.firstIndex(of: selectedSound) else { return }
        let next = all[(index + 1) % all.count]
        updateSelectedSound(next, emitUserFeedback: true)
    }

    func selectAmbientSound(_ sound: AmbientSound) {
        updateSelectedSound(sound, emitUserFeedback: true)
    }

    private func configureAudioSessionIfNeeded() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
        } catch {
            // If session configuration fails, audio may not play; keep UI functional.
        }
    }

    private func preloadAmbientPlayersIfNeeded() {
        guard ambientPlayers.isEmpty else { return }

        for sound in AmbientSound.allCases where sound != .off {
            guard let url = bundleURL(for: sound) else {
                continue
            }

            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.numberOfLoops = -1
                player.volume = sound.defaultVolume
                player.prepareToPlay()
                ambientPlayers[sound] = player
            } catch {
                continue
            }
        }
    }

    private func updateSelectedSound(_ newValue: AmbientSound, emitUserFeedback: Bool) {
        let oldValue = selectedSound
        guard oldValue != newValue else { return }

        selectedSound = newValue
        applyAmbientAudio(for: newValue)

        guard emitUserFeedback else { return }

        if newValue == .off {
            HapticsManager.success()
        } else {
            HapticsManager.impactLight()
        }

        presentAmbientToast(for: newValue)
    }

    private func applyAmbientAudio(for newValue: AmbientSound) {
        activeAmbientPlayer?.stop()
        activeAmbientPlayer = nil

        guard newValue != .off else {
            deactivateAudioSessionIfPossible()
            return
        }

        activateAudioSessionIfNeeded()

        guard let player = ambientPlayers[newValue] else {
            setSelectedSoundProgrammatically(.off, reason: "Missing audio file")
            return
        }

        player.currentTime = 0
        player.volume = newValue.defaultVolume

        if player.play() {
            activeAmbientPlayer = player
        } else {
            setSelectedSoundProgrammatically(.off, reason: "Couldn’t start audio")
        }
    }

    private func stopAmbientPlayback() {
        activeAmbientPlayer?.stop()
        activeAmbientPlayer = nil

        for player in ambientPlayers.values {
            player.stop()
            player.currentTime = 0
        }

        deactivateAudioSessionIfPossible()
    }

    private func setSelectedSoundProgrammatically(_ sound: AmbientSound, reason: String? = nil) {
        guard selectedSound != sound else { return }
        selectedSound = sound
        applyAmbientAudio(for: sound)

        if let reason {
            ambientToast = reason
            ambientToastWorkItem?.cancel()
            let workItem = DispatchWorkItem { [weak self] in
                self?.ambientToast = nil
            }
            ambientToastWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.85, execute: workItem)
        }
    }

    private func bundleURL(for sound: AmbientSound) -> URL? {
        let subdirectory = "Resources/Ambient"

        for ext in sound.preferredBundleExtensions {
            if let url = Bundle.main.url(forResource: sound.resourceName, withExtension: ext, subdirectory: subdirectory) {
                return url
            }
        }

        return nil
    }

    private func presentAmbientToast(for sound: AmbientSound) {
        ambientToastWorkItem?.cancel()

        let message: String?
        switch sound {
        case .off:
            message = "Sound off"
        case .rain:
            message = "Rain"
        case .cafe:
            message = "Café"
        case .whiteNoise:
            message = "Chatter"
        }

        ambientToast = message

        let workItem = DispatchWorkItem { [weak self] in
            self?.ambientToast = nil
        }

        ambientToastWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.85, execute: workItem)
    }

    private func activateAudioSessionIfNeeded() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(true, options: [])
        } catch {
            // Best-effort activation.
        }
    }

    private func deactivateAudioSessionIfPossible() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false, options: [.notifyOthersOnDeactivation])
        } catch {
            // Best-effort deactivation.
        }
    }

    private func tick() {
        guard timeRemaining > 0 else {
            completeSession()
            return
        }

        timeRemaining -= 1
    }

    private func completeSession() {
        timerCancellable?.cancel()
        isRunning = false
        sessionCompleted = true
    }

    // MARK: - Presence Simulation

    private func startPresenceSimulation() {
        scheduleNextPresenceUpdate()
    }

    private func scheduleNextPresenceUpdate() {
        presenceCancellable?.cancel()

        presenceCancellable = Timer
            .publish(every: Double.random(in: 8...12), on: .main, in: .common)
            .autoconnect()
            .prefix(1)
            .sink { [weak self] _ in
                guard let self else { return }
                self.updatePresence()
                self.scheduleNextPresenceUpdate()
            }
    }

    private func updatePresence() {
        let change = Int.random(in: -25...25)
        let newValue = presenceCount + change
        presenceCount = min(max(newValue, 1200), 5000)
    }
}

private extension AmbientSound {
    var preferredBundleExtensions: [String] {
        // Prefer MP3 placeholders if you drop them in, but keep dev-friendly fallbacks.
        ["mp3", "m4a", "caf"]
    }

    var resourceName: String {
        switch self {
        case .off:
            return ""
        case .rain:
            return "rain"
        case .cafe:
            return "cafe"
        case .whiteNoise:
            return "softchatter"
        }
    }

    var defaultVolume: Float {
        switch self {
        case .off:
            return 0
        case .rain:
            return 0.35
        case .cafe:
            return 0.30
        case .whiteNoise:
            return 0.28
        }
    }
}
