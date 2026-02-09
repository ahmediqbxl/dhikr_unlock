import Foundation
import SwiftData

@Model
final class DhikrSession {
    var startDate: Date
    var completionDate: Date?
    var isCompleted: Bool

    @Relationship(deleteRule: .cascade, inverse: \DhikrEntry.session)
    var entries: [DhikrEntry]

    init(startDate: Date = .now) {
        self.startDate = startDate
        self.completionDate = nil
        self.isCompleted = false
        self.entries = []
    }

    var totalCount: Int {
        entries.reduce(0) { $0 + $1.count }
    }

    var totalTarget: Int {
        entries.reduce(0) { $0 + $1.targetCount }
    }

    var progress: Double {
        guard totalTarget > 0 else { return 0 }
        return Double(totalCount) / Double(totalTarget)
    }
}
