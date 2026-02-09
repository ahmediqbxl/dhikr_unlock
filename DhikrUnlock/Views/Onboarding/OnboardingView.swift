import SwiftUI
import FamilyControls

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    @StateObject private var screenTimeVM = ScreenTimeViewModel()

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                welcomePage
                    .tag(0)

                howItWorksPage
                    .tag(1)

                authorizationPage
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }

    private var welcomePage: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "hands.and.sparkles.fill")
                .font(.system(size: 80))
                .foregroundStyle(.green)

            VStack(spacing: 12) {
                Text("DhikrUnlock")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Complete your daily dhikr\nto unlock your apps")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            Button {
                withAnimation { currentPage = 1 }
            } label: {
                Text("Get Started")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 48)
        }
    }

    private var howItWorksPage: some View {
        VStack(spacing: 32) {
            Spacer()

            Text("How It Works")
                .font(.largeTitle)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 24) {
                featureRow(
                    icon: "lock.fill",
                    title: "Apps Lock Daily",
                    description: "Selected apps are blocked at the start of each day"
                )
                featureRow(
                    icon: "hand.tap.fill",
                    title: "Complete Your Dhikr",
                    description: "Tap through 6 dhikr phrases to reach your daily goal"
                )
                featureRow(
                    icon: "lock.open.fill",
                    title: "Apps Unlock",
                    description: "Once all dhikr are completed, your apps are unblocked"
                )
            }
            .padding(.horizontal, 32)

            Spacer()

            Button {
                withAnimation { currentPage = 2 }
            } label: {
                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 48)
        }
    }

    private var authorizationPage: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "checkmark.shield.fill")
                .font(.system(size: 64))
                .foregroundStyle(.green)

            VStack(spacing: 12) {
                Text("Screen Time Access")
                    .font(.title)
                    .fontWeight(.bold)

                Text("DhikrUnlock needs Screen Time access to manage app blocking. This data stays on your device.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Spacer()

            VStack(spacing: 12) {
                Button {
                    Task {
                        await screenTimeVM.requestAuthorization()
                        if screenTimeVM.isAuthorized {
                            hasCompletedOnboarding = true
                        }
                    }
                } label: {
                    Text("Authorize Screen Time")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                Button {
                    hasCompletedOnboarding = true
                } label: {
                    Text("Skip for Now")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 48)
        }
    }

    private func featureRow(icon: String, title: String, description: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.green)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
