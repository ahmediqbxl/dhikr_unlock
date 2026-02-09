import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            }
        }
        .task {
            ensureDefaultGoals()
        }
    }

    private func ensureDefaultGoals() {
        let descriptor = FetchDescriptor<DhikrGoal>()
        let existingCount = (try? modelContext.fetchCount(descriptor)) ?? 0

        guard existingCount == 0 else { return }

        for dhikrType in DhikrType.allCases {
            let goal = DhikrGoal(dhikrType: dhikrType)
            modelContext.insert(goal)
        }
        try? modelContext.save()
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            CounterTabView()
                .tabItem {
                    Label("Dhikr", systemImage: "hand.tap.fill")
                }

            HistoryTabView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }

            SettingsTabView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(.green)
    }
}
