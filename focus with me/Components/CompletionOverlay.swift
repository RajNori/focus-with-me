import SwiftUI

struct CompletionOverlay: View {
    let onStartAnother: () -> Void

    @State private var showContent = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .background(.ultraThinMaterial)

            VStack(spacing: 16) {
                Text("Session complete")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.white)

                Text("Nice work. Take a breath.")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.white.opacity(0.7))

                Button(action: onStartAnother) {
                    Text("Start another")
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                }
                .buttonStyle(.plain)
                .background(Color(red: 0.0, green: 200.0 / 255.0, blue: 150.0 / 255.0))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .scaleEffect(showContent ? 1.0 : 0.97)
            }
            .padding(24)
            .background(Color.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
            .padding(.horizontal, 24)
            .opacity(showContent ? 1.0 : 0.0)
            .scaleEffect(showContent ? 1.0 : 0.95)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.3)) {
                showContent = true
            }
        }
    }
}

#Preview {
    CompletionOverlay(onStartAnother: {})
}
