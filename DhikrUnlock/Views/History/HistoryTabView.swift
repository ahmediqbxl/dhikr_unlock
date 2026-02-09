import SwiftUI
import SwiftData

struct HistoryTabView: View {
    @Query(
        filter: #Predicate<DhikrSession> { $0.isCompleted },
        sort: \DhikrSession.completionDate,
        order: .reverse
    )
    private var sessions: [DhikrSession]

    var body: some View {
        NavigationStack {
            Group {
                if sessions.isEmpty {
                    ContentUnavailableView(
                        "No Sessions Yet",
                        systemImage: "clock.badge.questionmark",
                        description: Text("Complete your first dhikr session to see it here.")
                    )
                } else {
                    List(sessions, id: \.startDate) { session in
                        NavigationLink {
                            SessionDetailView(session: session)
                        } label: {
                            SessionRowView(session: session)
                        }
                    }
                }
            }
            .navigationTitle("History")
        }
    }
}
