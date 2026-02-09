import SwiftUI

struct DhikrCounterCard: View {
    let entry: DhikrEntry
    let onTap: () -> Void
    let onReset: () -> Void

    private var dhikrType: DhikrType {
        entry.dhikrType ?? .subhanAllah
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ProgressRingView(
                    progress: entry.progress,
                    lineWidth: 5,
                    size: 50,
                    foregroundColor: entry.isCompleted ? .green : .blue
                )

                VStack(alignment: .leading, spacing: 4) {
                    Text(dhikrType.arabicText)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .environment(\.layoutDirection, .rightToLeft)

                    Text(dhikrType.transliteration)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(entry.count)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(entry.isCompleted ? .green : .primary)
                        .contentTransition(.numericText())

                    Text("/ \(entry.targetCount)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(entry.isCompleted ? Color.green.opacity(0.08) : Color(.systemBackground))
                    .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(entry.isCompleted ? Color.green.opacity(0.3) : Color.clear, lineWidth: 1.5)
            }
        }
        .buttonStyle(.plain)
        .disabled(entry.isCompleted)
        .contextMenu {
            Button(role: .destructive) {
                onReset()
            } label: {
                Label("Reset Count", systemImage: "arrow.counterclockwise")
            }
        }
        .animation(.easeInOut(duration: 0.2), value: entry.count)
    }
}
