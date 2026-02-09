import SwiftUI
import FamilyControls

struct SettingsTabView: View {
    @StateObject private var screenTimeVM = ScreenTimeViewModel()
    @State private var showingAppPicker = false

    var body: some View {
        NavigationStack {
            List {
                Section("Dhikr") {
                    NavigationLink {
                        DhikrGoalEditorView()
                    } label: {
                        Label("Dhikr Goals", systemImage: "target")
                    }
                }

                Section("App Blocking") {
                    Toggle(isOn: $screenTimeVM.blockingEnabled) {
                        Label("Enable Blocking", systemImage: "lock.shield.fill")
                    }

                    Button {
                        showingAppPicker = true
                    } label: {
                        HStack {
                            Label("Select Apps to Block", systemImage: "app.badge.fill")
                            Spacer()
                            let count = screenTimeVM.selectionCount
                            if count > 0 {
                                Text("\(count) selected")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .familyActivityPicker(
                        isPresented: $showingAppPicker,
                        selection: $screenTimeVM.activitySelection
                    )

                    NavigationLink {
                        ScheduleEditorView()
                    } label: {
                        Label("Schedule", systemImage: "clock.fill")
                    }
                }

                Section("Screen Time") {
                    HStack {
                        Label("Authorization", systemImage: "checkmark.shield.fill")
                        Spacer()
                        Text(screenTimeVM.authorizationStatus)
                            .foregroundStyle(.secondary)
                    }

                    if !screenTimeVM.isAuthorized {
                        Button("Request Authorization") {
                            Task { await screenTimeVM.requestAuthorization() }
                        }
                    }
                }

                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
