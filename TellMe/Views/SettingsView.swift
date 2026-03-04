import SwiftUI

struct SettingsView: View {
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
                Button("Restore Purchases (coming soon)") {}
                    .foregroundStyle(.primary)
                    .disabled(true)
            }
        }
        .navigationTitle("Settings")
        .listStyle(.insetGrouped)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
