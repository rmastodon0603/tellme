import Foundation
import Combine

final class SessionViewModel: ObservableObject {
    // Session configuration
    let packId: String
    let packTitle: String?

    // All cards for this session (already filtered and shuffled)
    @Published private(set) var cards: [Card] = []

    // Session state
    @Published private(set) var currentIndex: Int = 0
    @Published private(set) var isSessionEnded: Bool = false
    @Published private(set) var isEmpty: Bool = false

    var currentCard: Card? {
        guard !isSessionEnded,
              !cards.isEmpty,
              currentIndex >= 0,
              currentIndex < cards.count
        else {
            return nil
        }
        return cards[currentIndex]
    }

    init(packId: String, packTitle: String? = nil, allCards: [Card]) {
        self.packId = packId
        self.packTitle = packTitle

        // Filter cards by pack and shuffle once at the start
        let filtered = allCards.filter { $0.packId == packId }
        self.cards = filtered.shuffled()

        self.isEmpty = cards.isEmpty
        self.isSessionEnded = cards.isEmpty
        self.currentIndex = 0
    }

    func next() {
        guard !cards.isEmpty, !isSessionEnded else { return }

        let nextIndex = currentIndex + 1
        if nextIndex < cards.count {
            currentIndex = nextIndex
        } else {
            isSessionEnded = true
        }
    }

    func skip() {
        // For MVP, skipping behaves the same as moving to the next card.
        next()
    }

    func endSession() {
        isSessionEnded = true
    }
}

