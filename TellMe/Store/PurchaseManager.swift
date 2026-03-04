import Foundation
import Combine
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    static let starterPackProductId = "starter_pack"

    private let entitlementStore: EntitlementStore

    @Published private(set) var isLoadingProducts = false
    @Published private(set) var product: Product?
    @Published private(set) var purchaseInProgress = false
    @Published private(set) var lastError: String?

    var isPurchased: Bool {
        entitlementStore.isPro
    }

    init(entitlementStore: EntitlementStore) {
        self.entitlementStore = entitlementStore
    }

    func loadProducts() async {
        isLoadingProducts = true
        lastError = nil
        defer { isLoadingProducts = false }

        do {
            let products = try await Product.products(for: [Self.starterPackProductId])
            product = products.first
            if product == nil {
                lastError = "Product not found"
            }
        } catch {
            lastError = error.localizedDescription
            product = nil
        }
    }

    func purchase() async {
        guard let product = product else {
            lastError = "Product not available"
            return
        }
        purchaseInProgress = true
        lastError = nil
        defer { purchaseInProgress = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    if transaction.productID == Self.starterPackProductId {
                        await transaction.finish()
                        entitlementStore.setPro(true)
                    }
                case .unverified:
                    lastError = "Purchase verification failed"
                }
            case .userCancelled:
                break
            case .pending:
                lastError = "Purchase is pending approval"
            @unknown default:
                lastError = "Unknown result"
            }
        } catch {
            lastError = error.localizedDescription
        }
    }

    func restorePurchases() async {
        purchaseInProgress = true
        lastError = nil
        defer { purchaseInProgress = false }

        await refreshEntitlements()
    }

    /// Re-checks current transactions and updates entitlement (isPro) accordingly.
    func refreshEntitlements() async {
        var hasStarterPack = false
        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction) where transaction.productID == Self.starterPackProductId:
                hasStarterPack = true
                break
            case .verified, .unverified:
                continue
            }
        }
        entitlementStore.setPro(hasStarterPack)
    }
}
