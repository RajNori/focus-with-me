import SwiftUI

struct SoundToggleButton: View {
    @Binding var selectedSound: AmbientSound
    let onCycle: () -> Void

    var body: some View {
        Button {
            onCycle()
        } label: {
            Image(systemName: iconName(for: selectedSound))
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(Color.white.opacity(0.08))
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    private func iconName(for sound: AmbientSound) -> String {
        switch sound {
        case .off:
            return "speaker.slash.fill"
        case .rain:
            return "cloud.rain.fill"
        case .cafe:
            return "cup.and.saucer.fill"
        case .whiteNoise:
            return "waveform"
        }
    }
}

#Preview {
    SoundToggleButton(selectedSound: .constant(.off), onCycle: {})
        .padding()
        .background(Color.black)
}
