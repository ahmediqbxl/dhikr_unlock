import SwiftUI

struct SessionDetailView: View {
    let session: DhikrSession

    private var sortedEntries: [DhikrEntry] {
        session.entries.sorted {
            DhikrType.allCases.firstIndex(of: $0.dhikrType ?? .subhanAllah) ?? 0 <
            DhikrType.allCases.firstIndex(of: $1.dhikrType ?? .subhanAllah) ?? 0
        }
    }

    var body: some View {
        List {
            Section("Summary") {
                LabeledContent("Date") {
                    Text(session.startDate, style: .date)
                }
                LabeledContent("Started") {
                    Text(session.startDate, style: .time)
                }
                if let completionDate = session.completionDate {
                    LabeledContent("Completed") {
                        Text(completionDate, style: .time)
                    }
                    LabeledContent("Duration") {
                        Text(durationText(from: session.startDate, to: completionDate))
                    }
                }
                LabeledContent("Status") {
                    Text(session.isCompleted ? "Completed" : "In Progress")
                        .foregroundStyle(session.isCompleted ? .green : .orange)
                }
            }

            Section("Dhikr Counts") {
                ForEach(sortedEntries, id: \.dhikrTypeRaw) { entry in
                    if let dhikrType = entry.dhikrType {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(dhikrType.transliteration)
                                    .font(.headline)
                                Text(dhikrType.arabicText)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            HStack(spacing: 4) {
                                Text("\(entry.count)")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(entry.isCompleted ? .green : .primary)
                                Text("/ \(entry.targetCount)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
        }
        .navigationTitle("Session Details")
    }

    private func durationText(from start: Date, to end: Date) -> String {
        let interval = end.timeIntervalSince(start)
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        }
        return "\(seconds)s"
    }
}
