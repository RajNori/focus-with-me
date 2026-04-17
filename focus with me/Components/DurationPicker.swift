import SwiftUI

struct DurationPicker: View {
    @Binding var selectedDuration: Int

    private let options: [Int] = [1500, 2700, 3600]

    var body: some View {
        HStack(spacing: 12) {
            ForEach(options, id: \.self) { duration in
                Button {
                    selectedDuration = duration
                } label: {
                    Text(label(for: duration))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(selectedDuration == duration ? .black : .white.opacity(0.85))
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(
                            selectedDuration == duration
                                ? Color(red: 0.0, green: 200.0 / 255.0, blue: 150.0 / 255.0)
                                : Color.white.opacity(0.06)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func label(for duration: Int) -> String {
        "\(duration / 60) min"
    }
}

#Preview {
    DurationPicker(selectedDuration: .constant(1500))
        .padding()
        .background(Color.black)
}
