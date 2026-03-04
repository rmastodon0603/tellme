import SwiftUI

struct SessionView: View {
    @StateObject private var viewModel: SessionViewModel

    init(viewModel: SessionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    private var title: String {
        viewModel.packTitle ?? "Session"
    }

    var body: some View {
        VStack(spacing: 24) {
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)

            content

            Spacer(minLength: 24)

            if !viewModel.isEmpty && !viewModel.isSessionEnded && !viewModel.isRevealBlocked {
                controls
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(Color(.systemBackground))
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isRevealBlocked {
            paywallState
        } else if viewModel.isEmpty {
            emptyState
        } else if viewModel.isSessionEnded {
            endedState
        } else if let card = viewModel.currentCard {
            cardView(for: card)
        } else {
            emptyState
        }
    }

    private var controls: some View {
        VStack(spacing: 12) {
            Button("Next") {
                viewModel.next()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .buttonStyle(.borderedProminent)
            .tint(.indigo)

            Button("Skip") {
                viewModel.skip()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .buttonStyle(.bordered)
        }
    }

    private func cardView(for card: Card) -> some View {
        VStack {
            Spacer(minLength: 0)

            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(.secondarySystemBackground))
                )
                .overlay(
                    Text(card.text)
                        .font(.title3)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(4)
                        .padding(24)
                        .frame(maxWidth: .infinity, alignment: .leading)
                )
                .frame(maxWidth: .infinity)

            Spacer(minLength: 0)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Text("No cards available")
                .font(.headline)

            Text("There aren’t any questions for this pack yet.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }

    private var endedState: some View {
        VStack(spacing: 12) {
            Text("Session ended")
                .font(.headline)

            Text("You’ve reached the end of this session. You can revisit these questions anytime.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }

    private var paywallState: some View {
        PaywallView()
    }
}

#Preview {
    let previewCards = [
        Card(
            id: "preview_base_1",
            packId: "base",
            text: "What is something small I do that makes your day a bit better?",
            sortOrder: 1
        )
    ]
    let viewModel = SessionViewModel(
        packId: "base",
        packTitle: "Base",
        allCards: previewCards
    )

    return NavigationStack {
        SessionView(viewModel: viewModel)
    }
}
