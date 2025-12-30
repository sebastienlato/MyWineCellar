import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            Theme.Colors.charcoal.ignoresSafeArea()
            Text("Settings (coming soon)")
                .foregroundStyle(Theme.Colors.textPrimary)
        }
    }
}

#Preview {
    SettingsView()
}
