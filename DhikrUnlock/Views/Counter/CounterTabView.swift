import SwiftUI
import SwiftData

struct CounterTabView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = DhikrCounterViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                if viewModel.showCelebration {
                    CompletionCelebrationView {
                        viewModel.startNewSession()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            SessionProgressView(
                                progress: viewModel.sessionProgress,
                                isCompleted: viewModel.isSessionCompleted
                            )

                            ForEach(viewModel.entries, id: \.dhikrTypeRaw) { entry in
                                DhikrCounterCard(
                                    entry: entry,
                                    onTap: { viewModel.increment(entry) },
                                    onReset: { viewModel.resetEntry(entry) }
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Dhikr")
            .toolbar {
                if viewModel.isSessionCompleted && !viewModel.showCelebration {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("New Session") {
                            viewModel.startNewSession()
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.setup(modelContext: modelContext)
        }
    }
}
