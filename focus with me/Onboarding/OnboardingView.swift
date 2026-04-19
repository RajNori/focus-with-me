import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var isButtonPressed = false

    var body: some View {
        ZStack {
            AmbientView()

            VStack {
                TabView(selection: $currentPage) {
                    ForEach(Array(OnboardingPageModel.pages.enumerated()), id: \.offset) { index, page in
                        OnboardingPageView(page: page)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: currentPage)

                HStack(spacing: 8) {
                    ForEach(0..<OnboardingPageModel.pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.accentColor : Color.white.opacity(0.2))
                            .frame(width: 6, height: 6)
                            .scaleEffect(index == currentPage ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: currentPage)
                    }
                }
                .padding(.bottom, 16)

                Button(action: handleContinue) {
                    Text(currentPage == OnboardingPageModel.pages.count - 1 ? "Start focusing" : "Continue")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .scaleEffect(isButtonPressed ? 0.97 : 1.0)
                        .animation(.easeInOut(duration: 0.12), value: isButtonPressed)
                }
                .buttonStyle(.plain)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in isButtonPressed = true }
                        .onEnded { _ in isButtonPressed = false }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .safeAreaInset(edge: .top) {
            HStack {
                Spacer()
                Button("Skip") {
                    hasCompletedOnboarding = true
                }
                .buttonStyle(.plain)
                .foregroundStyle(.white.opacity(0.7))
                .fixedSize(horizontal: true, vertical: true)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 8)
        }
    }

    private func handleContinue() {
        if currentPage < OnboardingPageModel.pages.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPage += 1
            }
        } else {
            hasCompletedOnboarding = true
        }
    }
}

#Preview {
    OnboardingView()
        .preferredColorScheme(.dark)
}
