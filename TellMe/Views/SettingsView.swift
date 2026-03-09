import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var purchaseManager: PurchaseManager

    var body: some View {
        List {
            Section("About Tell Me") {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Tell Me")
                        .font(.headline)
                    Text("A calm couples conversation app, MVP preview.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Text("Version")
                    Spacer()
                    Text("0.1.0")
                        .foregroundStyle(.secondary)
                }
            }

            Section("Privacy") {
                Text("Tell Me stores content locally on your device. No accounts, syncing, or analytics are enabled in this MVP.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Section("Purchases") {
                if purchaseManager.purchaseInProgress {
                    HStack {
                        Text("Restoring…")
                            .foregroundStyle(.secondary)
                        Spacer()
                        ProgressView()
                    }
                } else {
                    Button("Restore Purchases") {
                        Task { await purchaseManager.restorePurchases() }
                    }
                    .foregroundStyle(.primary)
                }

                if let feedback = purchaseManager.restoreFeedback {
                    Text(feedback)
                        .font(.subheadline)
                        .foregroundStyle(feedback.hasPrefix("Restore failed") || feedback == "No purchases to restore" ? Color.red : Color.secondary)
                }
            }
        }
        .navigationTitle("Settings")
        .listStyle(.insetGrouped)
    }
}

#Preview {
    let store = EntitlementStore()
    return NavigationStack {
        SettingsView()
            .environmentObject(PurchaseManager(entitlementStore: store))
    }
}
