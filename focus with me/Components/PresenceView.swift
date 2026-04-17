import SwiftUI

struct PresenceView: View {
    let presenceCount: Int

    @State private var pulse = false

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color(red: 0.0, green: 200.0 / 255.0, blue: 150.0 / 255.0))
                .frame(width: 8, height: 8)
                .scaleEffect(pulse ? 1.2 : 0.9)
                .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: pulse)

            Text("\(presenceCount.formatted(.number.grouping(.automatic))) people focusing right now")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .contentTransition(.opacity)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .onAppear {
            pulse = true
        }
        .animation(.easeInOut(duration: 0.25), value: presenceCount)
    }
}

#Preview {
    PresenceView(presenceCount: 2431)
        .padding()
        .background(Color.black)
}
