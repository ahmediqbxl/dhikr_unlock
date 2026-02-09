import Foundation
import FamilyControls

final class SharedDataStore {
    static let shared = SharedDataStore()

    private let defaults: UserDefaults?

    private init() {
        defaults = AppGroupConstants.sharedDefaults
    }

    // MARK: - Family Activity Selection

    var familyActivitySelection: FamilyActivitySelection {
        get {
            guard let data = defaults?.data(forKey: AppGroupConstants.familyActivitySelectionKey),
                  let selection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data) else {
                return FamilyActivitySelection()
            }
            return selection
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            defaults?.set(data, forKey: AppGroupConstants.familyActivitySelectionKey)
        }
    }

    // MARK: - Dhikr Completion

    var dhikrCompletedToday: Bool {
        get {
            guard let completedDate = defaults?.object(forKey: AppGroupConstants.dhikrCompletedDateKey) as? Date else {
                return false
            }
            return Calendar.current.isDateInToday(completedDate) &&
                   (defaults?.bool(forKey: AppGroupConstants.dhikrCompletedTodayKey) ?? false)
        }
        set {
            defaults?.set(newValue, forKey: AppGroupConstants.dhikrCompletedTodayKey)
            if newValue {
                defaults?.set(Date.now, forKey: AppGroupConstants.dhikrCompletedDateKey)
            }
        }
    }

    // MARK: - Blocking

    var blockingEnabled: Bool {
        get { defaults?.bool(forKey: AppGroupConstants.blockingEnabledKey) ?? false }
        set { defaults?.set(newValue, forKey: AppGroupConstants.blockingEnabledKey) }
    }

    // MARK: - Schedule

    var scheduleStartHour: Int {
        get { defaults?.integer(forKey: AppGroupConstants.scheduleStartHourKey) ?? 5 }
        set { defaults?.set(newValue, forKey: AppGroupConstants.scheduleStartHourKey) }
    }

    var scheduleStartMinute: Int {
        get { defaults?.integer(forKey: AppGroupConstants.scheduleStartMinuteKey) ?? 0 }
        set { defaults?.set(newValue, forKey: AppGroupConstants.scheduleStartMinuteKey) }
    }

    var scheduleEndHour: Int {
        get { defaults?.integer(forKey: AppGroupConstants.scheduleEndHourKey) ?? 23 }
        set { defaults?.set(newValue, forKey: AppGroupConstants.scheduleEndHourKey) }
    }

    var scheduleEndMinute: Int {
        get { defaults?.integer(forKey: AppGroupConstants.scheduleEndMinuteKey) ?? 59 }
        set { defaults?.set(newValue, forKey: AppGroupConstants.scheduleEndMinuteKey) }
    }

    var hasSelectedApps: Bool {
        !familyActivitySelection.applicationTokens.isEmpty ||
        !familyActivitySelection.categoryTokens.isEmpty
    }
}
