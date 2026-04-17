import SwiftUI

struct AmbientView: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            Color(red: 10.0 / 255.0, green: 10.0 / 255.0, blue: 15.0 / 255.0)
                .ignoresSafeArea()

            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.0, green: 200.0 / 255.0, blue: 150.0 / 255.0).opacity(0.25),
                            .clear
                        ],
                        center: .center,
                        startRadius: 10,
                        endRadius: 260
                    )
                )
                .frame(width: 420, height: 420)
                .offset(x: animate ? -90 : 70, y: animate ? -240 : -170)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 90.0 / 255.0, green: 200.0 / 255.0, blue: 250.0 / 255.0).opacity(0.20),
                            .clear
                        ],
                        center: .center,
                        startRadius: 10,
                        endRadius: 300
                    )
                )
                .frame(width: 500, height: 500)
                .offset(x: animate ? 120 : -80, y: animate ? 210 : 120)

            LinearGradient(
                colors: [
                    Color(red: 12.0 / 255.0, green: 18.0 / 255.0, blue: 30.0 / 255.0).opacity(0.35),
                    Color(red: 8.0 / 255.0, green: 12.0 / 255.0, blue: 18.0 / 255.0).opacity(0.2)
                ],
                startPoint: animate ? .topLeading : .bottomTrailing,
                endPoint: animate ? .bottomTrailing : .topLeading
            )
        }
        .blur(radius: 36)
        .opacity(0.9)
        .onAppear {
            withAnimation(.easeInOut(duration: 15).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

#Preview {
    AmbientView()
}
