import SwiftUI

struct PaywallView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Unlock More")
                .font(.title)
                .fontWeight(.semibold)

            Text("Additional packs and features will be available here.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
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
    }
}
