import SwiftUI
import SwiftData
import ManagedSettings

@Observable
final class DhikrCounterViewModel {
    var currentSession: DhikrSession?
    var showCelebration = false

    private var modelContext: ModelContext?

    func setup(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadOrCreateSession()
    }

    var entries: [DhikrEntry] {
        currentSession?.entries.sorted(by: {
            DhikrType.allCases.firstIndex(of: $0.dhikrType ?? .subhanAllah) ?? 0 <
            DhikrType.allCases.firstIndex(of: $1.dhikrType ?? .subhanAllah) ?? 0
        }) ?? []
    }

    var sessionProgress: Double {
        currentSession?.progress ?? 0
    }

    var isSessionCompleted: Bool {
        currentSession?.isCompleted ?? false
    }

    func increment(_ entry: DhikrEntry) {
        guard entry.count < entry.targetCount else { return }
        entry.count += 1

        if entry.count == entry.targetCount {
            HapticManager.milestone()
        } else {
            HapticManager.tap()
        }

        checkCompletion()
        try? modelContext?.save()
    }

    func resetEntry(_ entry: DhikrEntry) {
        entry.count = 0
        if let session = currentSession {
            session.isCompleted = false
            session.completionDate = nil
        }
        try? modelContext?.save()
    }

    func startNewSession() {
        showCelebration = false
        createNewSession()
    }

    private func loadOrCreateSession() {
        guard let modelContext else { return }

        var descriptor = FetchDescriptor<DhikrSession>(
            predicate: #Predicate { !$0.isCompleted },
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )
        descriptor.fetchLimit = 1

        if let existing = try? modelContext.fetch(descriptor).first {
            currentSession = existing
            return
        }

        // Check if already completed today
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: .now)
        var completedDescriptor = FetchDescriptor<DhikrSession>(
            predicate: #Predicate { session in
                session.isCompleted && session.completionDate != nil && session.completionDate! >= startOfDay
            },
            sortBy: [SortDescriptor(\.completionDate, order: .reverse)]
        )
        completedDescriptor.fetchLimit = 1

        if let todayCompleted = try? modelContext.fetch(completedDescriptor).first {
            currentSession = todayCompleted
            return
        }

        createNewSession()
    }

    private func createNewSession() {
        guard let modelContext else { return }

        let goals = (try? modelContext.fetch(FetchDescriptor<DhikrGoal>())) ?? []
        let session = DhikrSession()
        modelContext.insert(session)

        for dhikrType in DhikrType.allCases {
            let target = goals.first(where: { $0.dhikrTypeRaw == dhikrType.rawValue })?.targetCount
                ?? dhikrType.defaultTarget
            let entry = DhikrEntry(dhikrType: dhikrType, targetCount: target, session: session)
            modelContext.insert(entry)
            session.entries.append(entry)
        }

        currentSession = session
        try? modelContext.save()
    }

    private func checkCompletion() {
        guard let session = currentSession else { return }
        let allCompleted = session.entries.allSatisfy { $0.isCompleted }

        if allCompleted && !session.isCompleted {
            session.isCompleted = true
            session.completionDate = .now
            showCelebration = true
            HapticManager.completion()

            SharedDataStore.shared.dhikrCompletedToday = true

            // Remove shields when dhikr is completed
            if SharedDataStore.shared.blockingEnabled {
                ManagedSettingsStore().clearAllSettings()
            }
        }
    }
}
