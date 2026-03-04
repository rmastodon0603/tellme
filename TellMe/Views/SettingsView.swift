import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section("General") {
                Toggle("Example setting", isOn: .constant(true))
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
