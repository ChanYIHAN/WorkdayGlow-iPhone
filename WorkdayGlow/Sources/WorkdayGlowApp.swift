import SwiftUI

@main
struct WorkdayGlowApp: App {
    @StateObject private var store = SettingsStore()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(store)
                .tint(Color("AuroraMint"))
                .preferredColorScheme(.light)
        }
    }
}
