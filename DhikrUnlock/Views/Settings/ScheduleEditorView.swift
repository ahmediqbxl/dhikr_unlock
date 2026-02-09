import SwiftUI

struct ScheduleEditorView: View {
    @State private var startTime: Date
    @State private var endTime: Date

    private let store = SharedDataStore.shared

    init() {
        let calendar = Calendar.current
        let startHour = SharedDataStore.shared.scheduleStartHour
        let startMinute = SharedDataStore.shared.scheduleStartMinute
        let endHour = SharedDataStore.shared.scheduleEndHour
        let endMinute = SharedDataStore.shared.scheduleEndMinute

        let start = calendar.date(from: DateComponents(hour: startHour, minute: startMinute)) ?? .now
        let end = calendar.date(from: DateComponents(hour: endHour, minute: endMinute)) ?? .now

        _startTime = State(initialValue: start)
        _endTime = State(initialValue: end)
    }

    var body: some View {
        List {
            Section {
                DatePicker("Blocking Starts", selection: $startTime, displayedComponents: .hourAndMinute)
                DatePicker("Blocking Ends", selection: $endTime, displayedComponents: .hourAndMinute)
            } header: {
                Text("Daily Schedule")
            } footer: {
                Text("Apps will be blocked during this time window until you complete your dhikr.")
            }
        }
        .navigationTitle("Schedule")
        .onChange(of: startTime) { _, newValue in
            let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            store.scheduleStartHour = components.hour ?? 5
            store.scheduleStartMinute = components.minute ?? 0
        }
        .onChange(of: endTime) { _, newValue in
            let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            store.scheduleEndHour = components.hour ?? 23
            store.scheduleEndMinute = components.minute ?? 59
        }
    }
}
