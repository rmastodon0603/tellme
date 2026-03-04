import Foundation

final class DailyLimitStore {
    private enum Keys {
        static let dailyRevealCount = "dailyRevealCount"
        static let dailyRevealDate = "dailyRevealDate"
    }

    private let userDefaults: UserDefaults
    private let calendar: Calendar

    /// Number of reveals recorded for the current stored date.
    var dailyRevealCount: Int {
        get {
            refreshIfNeeded()
            return userDefaults.integer(forKey: Keys.dailyRevealCount)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.dailyRevealCount)
        }
    }

    /// Stored date for the current daily limit, in "YYYY-MM-DD" format.
    var dailyRevealDate: String {
        get {
            if let stored = userDefaults.string(forKey: Keys.dailyRevealDate) {
                return stored
            }
            let today = Self.currentDateString(using: calendar)
            userDefaults.set(today, forKey: Keys.dailyRevealDate)
            return today
        }
        set {
            userDefaults.set(newValue, forKey: Keys.dailyRevealDate)
        }
    }

    init(
        userDefaults: UserDefaults = .standard,
        calendar: Calendar = .current
    ) {
        self.userDefaults = userDefaults
        self.calendar = calendar
    }

    /// Ensures the stored date matches today's date; if not, resets the count for today.
    func refreshIfNeeded() {
        let today = Self.currentDateString(using: calendar)
        if dailyRevealDate != today {
            reset(forDateString: today)
        }
    }

    /// Increments the reveal count for today, resetting first if the day has changed.
    func incrementRevealCount() {
        refreshIfNeeded()
        dailyRevealCount += 1
    }

    /// Manually reset the counter for today.
    func resetForToday() {
        let today = Self.currentDateString(using: calendar)
        reset(forDateString: today)
    }

    // MARK: - Private helpers

    private func reset(forDateString dateString: String) {
        dailyRevealDate = dateString
        dailyRevealCount = 0
    }

    private static func currentDateString(using calendar: Calendar) -> String {
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let year = components.year ?? 0
        let month = components.month ?? 0
        let day = components.day ?? 0
        // "YYYY-MM-DD" with zero-padded month/day
        return String(format: "%04d-%02d-%02d", year, month, day)
    }
}

