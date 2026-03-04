import Foundation
import Combine

final class SessionViewModel: ObservableObject {
    // Session configuration
    let packId: String
    let packTitle: String?

    /// True when this session is for the Base pack.
    let isBasePack: Bool

    /// True when this session should apply the daily free limit logic.
    let shouldApplyDailyLimit: Bool

    private let dailyLimitStore: DailyLimitStore
    private static let baseDailyLimit: Int = 10

    // All cards for this session (already filtered and shuffled)
    @Published private(set) var cards: [Card] = []

    // Session state
    @Published private(set) var currentIndex: Int = 0
    @Published private(set) var isSessionEnded: Bool = false
    @Published private(set) var isEmpty: Bool = false
    @Published private(set) var isRevealBlocked: Bool = false

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

    init(
        packId: String,
        packTitle: String? = nil,
        allCards: [Card],
        dailyLimitStore: DailyLimitStore = DailyLimitStore()
    ) {
        self.packId = packId
        self.packTitle = packTitle
        self.dailyLimitStore = dailyLimitStore

        self.isBasePack = packId == "base"
        // For now we assume the user is a free user, so only Base applies the limit.
        self.shouldApplyDailyLimit = isBasePack

        // Filter cards by pack and shuffle once at the start
        let filtered = allCards.filter { $0.packId == packId }
        self.cards = filtered.shuffled()

        dailyLimitStore.refreshIfNeeded()

        self.isEmpty = cards.isEmpty
        self.isSessionEnded = cards.isEmpty
        self.currentIndex = 0

        // Count the initial reveal for Base if under the limit.
        if shouldApplyDailyLimit, !cards.isEmpty {
            if dailyLimitStore.dailyRevealCount >= Self.baseDailyLimit {
                // Limit already exhausted before this session.
                // The UI can react by showing a paywall state.
                isRevealBlocked = true
            } else {
                dailyLimitStore.incrementRevealCount()
            }
        }
    }

    func next() {
        guard !cards.isEmpty, !isSessionEnded else { return }

        if shouldApplyDailyLimit,
           dailyLimitStore.dailyRevealCount >= Self.baseDailyLimit {
            // Daily limit reached for Base; further reveals are blocked.
            // The view can respond by showing a paywall state.
            isRevealBlocked = true
            return
        }

        let nextIndex = currentIndex + 1
        if nextIndex < cards.count {
            if shouldApplyDailyLimit {
                dailyLimitStore.incrementRevealCount()
            }
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

    // MARK: - Daily limit helpers
}


