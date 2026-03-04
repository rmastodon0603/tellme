import SwiftUI

struct PaywallView: View {
    #if DEBUG
    @EnvironmentObject private var entitlementStore: EntitlementStore
    #endif

    var body: some View {
        VStack(spacing: 16) {
            Text("Unlock More")
                .font(.title)
                .fontWeight(.semibold)

            Text("Additional packs and features will be available here.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            #if DEBUG
            Spacer().frame(height: 24)

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
    }
}

#Preview {
    NavigationStack {
        PaywallView()
            .environmentObject(EntitlementStore())
    }
}
