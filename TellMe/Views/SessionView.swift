import SwiftUI

struct SessionView: View {
    let packTitle: String
    let cards: [Card]

    @State private var currentIndex: Int = 0

    private var currentCard: Card? {
        guard !cards.isEmpty, currentIndex < cards.count else { return nil }
        return cards[currentIndex]
    }

    var body: some View {
        VStack(spacing: 24) {
            Text(packTitle)
                .font(.title)
                .fontWeight(.semibold)

            if let card = currentCard {
                Text(card.text)
                    .font(.title3)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("No cards available for this session.")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            Spacer()

            if !cards.isEmpty {
                Button("Next Card") {
                    guard !cards.isEmpty else { return }
                    currentIndex = (currentIndex + 1) % cards.count
                }
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .navigationTitle(packTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SessionView(
            packTitle: "Base",
            cards: [
                Card(
                    id: "preview_base_1",
                    packId: "base",
                    text: "What is something small I do that makes your day a bit better?",
                    sortOrder: 1
                )
            ]
        )
    }
}
