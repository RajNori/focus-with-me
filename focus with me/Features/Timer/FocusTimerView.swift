import SwiftUI

struct FocusTimerView: View {
    @StateObject private var viewModel = FocusTimerViewModel()
    @State private var showEndSessionConfirmation = false
    private let accentColor = Color(red: 0.0, green: 200.0 / 255.0, blue: 150.0 / 255.0)

    private var formattedTime: String {
        TimeFormatter.format(seconds: viewModel.timeRemaining)
    }

    private var primaryButtonTitle: String {
        if viewModel.sessionCompleted {
            return "Start Again"
        }
        return viewModel.isRunning ? "Pause" : (viewModel.timeRemaining < viewModel.selectedDuration ? "Resume" : "Start Session")
    }

    var body: some View {
        ZStack {
            AmbientView()

            VStack(spacing: 32) {
                PresenceView(presenceCount: viewModel.presenceCount)

                AmbientSoundOptionsRow(selectedSound: $viewModel.selectedSound) { sound in
                    viewModel.selectAmbientSound(sound)
                }

                Spacer(minLength: 0)

                Text(formattedTime)
                    .font(.system(size: 72, weight: .medium, design: .monospaced))
                    .tracking(1.2)
                    .foregroundStyle(viewModel.isRunning ? accentColor : .white)
                    .id(formattedTime)
                    .transition(.opacity)

                Spacer(minLength: 0)

                if !viewModel.isRunning {
                    DurationPicker(
                        selectedDuration: Binding(
                            get: { viewModel.selectedDuration },
                            set: { viewModel.updateSelectedDuration($0) }
                        )
                    )
                }

                PrimaryButton(title: primaryButtonTitle) {
                    if viewModel.sessionCompleted {
                        viewModel.reset()
                        viewModel.start()
                        return
                    }

                    if viewModel.isRunning {
                        viewModel.pause()
                    } else {
                        viewModel.start()
                    }
                }

                if viewModel.isRunning {
                    Button("End") {
                        showEndSessionConfirmation = true
                    }
                    .buttonStyle(.plain)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.top, 2)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .overlay(alignment: .top) {
            if let toast = viewModel.ambientToast {
                Text(toast)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial, in: Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
                    .padding(.top, 96)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .animation(.easeInOut(duration: 0.2), value: toast)
            }
        }
        .safeAreaInset(edge: .top) {
            HStack {
                Spacer()
                SoundToggleButton(selectedSound: $viewModel.selectedSound) {
                    viewModel.cycleAmbientSound()
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 8)
        }
        .overlay {
            if viewModel.sessionCompleted {
                CompletionOverlay {
                    viewModel.reset()
                    viewModel.start()
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .overlay {
            if showEndSessionConfirmation {
                ZStack {
                    Color.black.opacity(0.45)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showEndSessionConfirmation = false
                        }

                    VStack(spacing: 14) {
                        Text("End session?")
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)

                        Text("This will stop your current session and return to idle.")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(.white.opacity(0.72))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)

                        HStack(spacing: 10) {
                            Button("Continue") {
                                showEndSessionConfirmation = false
                            }
                            .buttonStyle(.plain)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.9))
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                            Button("End Session") {
                                showEndSessionConfirmation = false
                                viewModel.endSession()
                            }
                            .buttonStyle(.plain)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.red.opacity(0.9))
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                        .padding(.top, 4)
                    }
                    .padding(22)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color.white.opacity(0.14), lineWidth: 1)
                    )
                    .padding(.horizontal, 28)
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: viewModel.isRunning)
        .animation(.easeInOut(duration: 0.3), value: viewModel.sessionCompleted)
        .animation(.easeInOut(duration: 0.2), value: showEndSessionConfirmation)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    FocusTimerView()
        .preferredColorScheme(.dark)
}
