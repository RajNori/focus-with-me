import SwiftUI

struct AmbientSoundOptionsRow: View {
    @Binding var selectedSound: AmbientSound
    let onSelect: (AmbientSound) -> Void

    var body: some View {
        HStack(spacing: 10) {
            optionButton(title: "Rain", sound: .rain)
            optionButton(title: "Café", sound: .cafe)
            optionButton(title: "Chatter", sound: .whiteNoise)
        }
        .frame(maxWidth: .infinity)
    }

    private func optionButton(title: String, sound: AmbientSound) -> some View {
        let isSelected = selectedSound == sound

        return Button {
            onSelect(sound)
        } label: {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(isSelected ? Color.black : Color.white.opacity(0.85))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(isSelected ? Color(red: 0.0, green: 200.0 / 255.0, blue: 150.0 / 255.0) : Color.white.opacity(0.06))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.10), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AmbientSoundOptionsRow(selectedSound: .constant(.rain), onSelect: { _ in })
        .padding()
        .background(Color.black)
}
