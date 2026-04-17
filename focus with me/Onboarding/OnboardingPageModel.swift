import Foundation

struct OnboardingPageModel: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
}

extension OnboardingPageModel {
    static let pages: [OnboardingPageModel] = [
        .init(
            title: "You're not working alone",
            subtitle: "Join thousands of others focusing right now."
        ),
        .init(
            title: "Just start",
            subtitle: "Pick a time. Press start. Stay in flow."
        ),
        .init(
            title: "No noise. No distractions.",
            subtitle: "Just you, your work, and quiet presence."
        )
    ]
}
