import SwiftUI

struct CompletionCelebrationView: View {
    let onNewSession: () -> Void
    @State private var animate = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.15))
                    .frame(width: 160, height: 160)
                    .scaleEffect(animate ? 1.1 : 0.9)

                Circle()
                    .fill(Color.green.opacity(0.25))
                    .frame(width: 120, height: 120)
                    .scaleEffect(animate ? 1.05 : 0.95)

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.green)
                    .scaleEffect(animate ? 1.0 : 0.5)
            }
            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animate)

            VStack(spacing: 8) {
                Text("MashaAllah!")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("You've completed your dhikr")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Text("Your selected apps are now unlocked")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }

            Spacer()

            Button(action: onNewSession) {
                Text("Start New Session")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
        .onAppear { animate = true }
    }
}
