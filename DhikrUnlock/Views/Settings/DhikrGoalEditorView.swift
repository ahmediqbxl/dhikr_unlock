import SwiftUI
import SwiftData

struct DhikrGoalEditorView: View {
    @Query(sort: \DhikrGoal.dhikrTypeRaw) private var goals: [DhikrGoal]

    var body: some View {
        List {
            ForEach(goals, id: \.dhikrTypeRaw) { goal in
                if let dhikrType = goal.dhikrType {
                    DhikrGoalRow(goal: goal, dhikrType: dhikrType)
                }
            }
        }
        .navigationTitle("Dhikr Goals")
    }
}

private struct DhikrGoalRow: View {
    @Bindable var goal: DhikrGoal
    let dhikrType: DhikrType

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(dhikrType.transliteration)
                    .font(.headline)
                Text(dhikrType.arabicText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Stepper(value: $goal.targetCount, in: 1...999) {
                Text("\(goal.targetCount)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .monospacedDigit()
                    .frame(minWidth: 40, alignment: .trailing)
            }
        }
        .padding(.vertical, 4)
    }
}
