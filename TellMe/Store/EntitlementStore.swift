import Foundation
import Combine

final class EntitlementStore: ObservableObject {
    private enum Keys {
        static let isPro = "entitlement_isPro"
    }

    private let userDefaults: UserDefaults

    @Published var isPro: Bool {
        didSet {
            userDefaults.set(isPro, forKey: Keys.isPro)
        }
    }

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.isPro = userDefaults.bool(forKey: Keys.isPro)
    }

    func setPro(_ value: Bool) {
        isPro = value
    }
}

