import SwiftUI

struct HomeView: View {
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

    private func loadCards(forPackId packId: String) -> [Card] {
        guard
            let url = Bundle.main.url(forResource: "cards", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let allCards = try? JSONDecoder().decode([Card].self, from: data)
        else {
            return []
        }

        return allCards
            .filter { $0.packId == packId }
            .sorted { $0.sortOrder < $1.sortOrder }
    }

    @ViewBuilder
    private func destination(for pack: Pack) -> some View {
        if pack.isLocked {
            PaywallView()
        } else {
            SessionView(
                packTitle: pack.title,
                cards: loadCards(forPackId: pack.id)
            )
        }
    }

    private func packRow(for pack: Pack) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(pack.title)
                    .font(.headline)

                Text(pack.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(pack.isLocked ? "LOCKED" : "FREE")
                .font(.caption2.weight(.semibold))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(
                            pack.isLocked
                            ? Color.secondary.opacity(0.15)
                            : Color.indigo.opacity(0.15)
                        )
                )
                .foregroundColor(
                    pack.isLocked ? Color.secondary : Color.indigo
                )
        }
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
    }
}

#Preview {
    HomeView()
}
