import SwiftUI

struct OnboardingPageView: View {
    let page: OnboardingPageModel

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text(page.title)
                .font(.system(size: 32, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)

            Text(page.subtitle)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()
        }
    }
}

#Preview {
    OnboardingPageView(page: OnboardingPageModel.pages[0])
        .background(Color.black)
}
