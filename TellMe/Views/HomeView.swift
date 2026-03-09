import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var entitlementStore: EntitlementStore
    @EnvironmentObject private var purchaseManager: PurchaseManager
    // Temporary static data; will be replaced by JSON-loaded data later.
    private let packs: [Pack] = [
        Pack(
            id: "base",
            title: "Base",
            subtitle: "Everyday questions to start talking",
            isFree: true,
            isLocked: false,
            dailyFreeLimit: 10,
            sortOrder: 1
        ),
        Pack(
            id: "between_us",
            title: "Between Us",
            subtitle: "Conversations about your relationship",
            isFree: false,
            isLocked: true,
            dailyFreeLimit: nil,
            sortOrder: 2
        ),
        Pack(
            id: "deeper_about_you",
            title: "Deeper About You",
            subtitle: "Go deeper into each other’s world",
            isFree: false,
            isLocked: true,
            dailyFreeLimit: nil,
            sortOrder: 3
        )
    ]

    private var sortedPacks: [Pack] {
        packs.sorted { $0.sortOrder < $1.sortOrder }
    }

    private func loadAllCards() -> [Card] {
        guard
            let url = Bundle.main.url(forResource: "cards", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let allCards = try? JSONDecoder().decode([Card].self, from: data)
        else {
            return []
        }
        return allCards
    }

    private func isLocked(_ pack: Pack) -> Bool {
        pack.isLocked && !entitlementStore.isPro
    }

    private func badgeText(for pack: Pack) -> String {
        if entitlementStore.isPro {
            return "UNLOCKED"
        } else {
            return pack.id == "base" ? "FREE" : "LOCKED"
        }
    }

    @ViewBuilder
    private func destination(for pack: Pack) -> some View {
        if isLocked(pack) {
            PaywallView()
        } else {
            let viewModel = SessionViewModel(
                packId: pack.id,
                packTitle: pack.title,
                allCards: loadAllCards(),
                entitlementStore: entitlementStore
            )
            SessionView(viewModel: viewModel)
        }
    }

    private func packRow(for pack: Pack) -> some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(pack.title)
                    .font(.headline)

                Text(pack.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            let locked = isLocked(pack)

            Text(badgeText(for: pack))
                .font(.caption2.weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(
                            locked
                            ? Color.secondary.opacity(0.15)
                            : Color.indigo.opacity(0.15)
                        )
                )
                .foregroundColor(
                    locked ? Color.secondary : Color.indigo
                )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.secondary.opacity(0.16), lineWidth: 1)
        )
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Packs") {
                    ForEach(sortedPacks) { pack in
                        NavigationLink {
                            destination(for: pack)
                        } label: {
                            packRow(for: pack)
                        }
                    }
                }
            }
            .navigationTitle("TellMe")
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color(.systemBackground))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .tint(.indigo)
        }
        .task {
            await purchaseManager.refreshEntitlements()
        }
    }
}

#Preview {
    let store = EntitlementStore()
    HomeView()
        .environmentObject(store)
        .environmentObject(PurchaseManager(entitlementStore: store))
}
