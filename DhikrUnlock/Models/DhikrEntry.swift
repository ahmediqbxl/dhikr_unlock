import Foundation
import SwiftData

@Model
final class DhikrEntry {
    var dhikrTypeRaw: String
    var count: Int
    var targetCount: Int
    var session: DhikrSession?

    var dhikrType: DhikrType? {
        DhikrType(rawValue: dhikrTypeRaw)
    }

    var isCompleted: Bool {
        count >= targetCount
    }

    var progress: Double {
        guard targetCount > 0 else { return 0 }
        return min(Double(count) / Double(targetCount), 1.0)
    }

    init(dhikrType: DhikrType, targetCount: Int, session: DhikrSession? = nil) {
        self.dhikrTypeRaw = dhikrType.rawValue
        self.count = 0
        self.targetCount = targetCount
        self.session = session
    }
}
