import SwiftUI
import FamilyControls
import ManagedSettings
import DeviceActivity
import os.log

private let logger = Logger(subsystem: "com.dhikrunlock.app", category: "ScreenTime")

class ScreenTimeViewModel: ObservableObject {
    @Published var activitySelection: FamilyActivitySelection {
        didSet {
            SharedDataStore.shared.familyActivitySelection = activitySelection
            if blockingEnabled && !SharedDataStore.shared.dhikrCompletedToday {
                applyShields()
            }
        }
    }

    @Published var blockingEnabled: Bool {
        didSet {
            SharedDataStore.shared.blockingEnabled = blockingEnabled
            if blockingEnabled {
                startMonitoring()
                if !SharedDataStore.shared.dhikrCompletedToday {
                    applyShields()
                }
            } else {
                stopMonitoring()
                clearShields()
            }
        }
    }

    @Published var isAuthorized = false

    private let store = ManagedSettingsStore()
    private let center = DeviceActivityCenter()

    var authorizationStatus: String {
        isAuthorized ? "Authorized" : "Not Authorized"
    }

    var selectionCount: Int {
        activitySelection.applicationTokens.count + activitySelection.categoryTokens.count
    }

    init() {
        let sharedStore = SharedDataStore.shared
        activitySelection = sharedStore.familyActivitySelection
        blockingEnabled = sharedStore.blockingEnabled
        isAuthorized = AuthorizationCenter.shared.authorizationStatus == .approved
    }

    @MainActor
    func requestAuthorization() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            isAuthorized = true
        } catch {
            isAuthorized = false
        }
    }

    func applyShields() {
        let selection = SharedDataStore.shared.familyActivitySelection
        store.shield.applications = selection.applicationTokens.isEmpty ? nil : selection.applicationTokens
        store.shield.applicationCategories = selection.categoryTokens.isEmpty
            ? nil
            : .specific(selection.categoryTokens)
    }

    func clearShields() {
        store.clearAllSettings()
    }

    func startMonitoring() {
        let sharedStore = SharedDataStore.shared
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: sharedStore.scheduleStartHour, minute: sharedStore.scheduleStartMinute),
            intervalEnd: DateComponents(hour: sharedStore.scheduleEndHour, minute: sharedStore.scheduleEndMinute),
            repeats: true
        )

        let activityName = DeviceActivityName("dhikr.daily")
        center.stopMonitoring([activityName])

        do {
            try center.startMonitoring(activityName, during: schedule)
        } catch {
            logger.error("Failed to start monitoring: \(error.localizedDescription)")
        }
    }

    func stopMonitoring() {
        center.stopMonitoring()
    }
}
