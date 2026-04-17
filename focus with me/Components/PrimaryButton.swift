import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color(red: 0.0, green: 200.0 / 255.0, blue: 150.0 / 255.0))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .scaleEffect(isPressed ? 0.97 : 1.0)
                .animation(.easeInOut(duration: 0.12), value: isPressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

#Preview {
    PrimaryButton(title: "Start Session", action: {})
        .padding()
        .background(Color.black)
}
