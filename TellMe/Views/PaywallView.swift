import SwiftUI

struct PaywallView: View {
    @EnvironmentObject private var purchaseManager: PurchaseManager
    #if DEBUG
    @EnvironmentObject private var entitlementStore: EntitlementStore
    #endif

    var body: some View {
        VStack(spacing: 20) {
            Text("Unlock More")
                .font(.title)
                .fontWeight(.semibold)

            Text("Additional packs and features will be available here.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            if let error = purchaseManager.lastError {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }

            Spacer().frame(height: 8)

            // Primary: real StoreKit purchase
            Group {
                if purchaseManager.isLoadingProducts {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                } else if purchaseManager.product != nil {
                    Button {
                        Task { await purchaseManager.purchase() }
                    } label: {
                        Text(purchaseManager.purchaseInProgress ? "Purchasing…" : "Unlock Now")
                    }
                    .disabled(purchaseManager.purchaseInProgress)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .buttonStyle(.borderedProminent)
                    .tint(.indigo)
                } else {
                    Button {
                        Task { await purchaseManager.loadProducts() }
                    } label: {
                        Text("Load offer")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .buttonStyle(.borderedProminent)
                    .tint(.indigo)
                }
            }

            Button("Restore Purchases") {
                Task { await purchaseManager.restorePurchases() }
            }
            .disabled(purchaseManager.purchaseInProgress)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .buttonStyle(.bordered)

            #if DEBUG
            Spacer().frame(height: 16)
            Button("Unlock (DEV)") {
                entitlementStore.setPro(true)
            }
            .font(.subheadline.weight(.semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .buttonStyle(.bordered)
            #endif
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .navigationTitle("Upgrade")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await purchaseManager.loadProducts()
            await purchaseManager.refreshEntitlements()
        }
    }
}

#Preview {
    let store = EntitlementStore()
    NavigationStack {
        PaywallView()
            .environmentObject(PurchaseManager(entitlementStore: store))
            .environmentObject(store)
    }
}
