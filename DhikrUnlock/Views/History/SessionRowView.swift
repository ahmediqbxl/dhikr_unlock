import SwiftUI

struct SessionRowView: View {
    let session: DhikrSession

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.startDate, style: .date)
                    .font(.headline)

                Text(session.startDate, style: .time)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 4) {
                    Text("\(session.totalCount)")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("/ \(session.totalTarget)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if session.isCompleted {
                    Label("Completed", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                } else {
                    Text("\(Int(session.progress * 100))%")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
