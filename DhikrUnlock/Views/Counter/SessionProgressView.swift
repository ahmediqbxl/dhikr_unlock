import SwiftUI

struct SessionProgressView: View {
    let progress: Double
    let isCompleted: Bool

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Session Progress")
                    .font(.headline)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(isCompleted ? .green : .primary)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 12)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(isCompleted ? Color.green : Color.blue)
                        .frame(width: geometry.size.width * min(progress, 1.0), height: 12)
                        .animation(.easeInOut(duration: 0.3), value: progress)
                }
            }
            .frame(height: 12)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
        }
    }
}
