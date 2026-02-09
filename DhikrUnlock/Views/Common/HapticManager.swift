import UIKit

enum HapticManager {
    static func tap() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    static func milestone() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    static func completion() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}
