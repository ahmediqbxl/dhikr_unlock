import SwiftUI
import SwiftData

@main
struct DhikrUnlockApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            DhikrGoal.self,
            DhikrSession.self,
            DhikrEntry.self
        ])
    }
}
