import Foundation

enum TimeFormatter {
    static func format(seconds: Int) -> String {
        let clampedSeconds = max(0, seconds)
        let minutes = clampedSeconds / 60
        let remainingSeconds = clampedSeconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
