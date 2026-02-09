import Foundation

enum AppGroupConstants {
    static let appGroupID = "group.com.dhikrunlock.shared"

    static let familyActivitySelectionKey = "familyActivitySelection"
    static let dhikrCompletedTodayKey = "dhikrCompletedToday"
    static let dhikrCompletedDateKey = "dhikrCompletedDate"
    static let blockingEnabledKey = "blockingEnabled"
    static let scheduleStartHourKey = "scheduleStartHour"
    static let scheduleStartMinuteKey = "scheduleStartMinute"
    static let scheduleEndHourKey = "scheduleEndHour"
    static let scheduleEndMinuteKey = "scheduleEndMinute"

    static var sharedDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupID)
    }
}
