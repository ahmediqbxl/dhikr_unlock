import Foundation
import SwiftData

@Model
final class DhikrGoal {
    @Attribute(.unique) var dhikrTypeRaw: String
    var targetCount: Int

    var dhikrType: DhikrType? {
        DhikrType(rawValue: dhikrTypeRaw)
    }

    init(dhikrType: DhikrType, targetCount: Int? = nil) {
        self.dhikrTypeRaw = dhikrType.rawValue
        self.targetCount = targetCount ?? dhikrType.defaultTarget
    }
}
