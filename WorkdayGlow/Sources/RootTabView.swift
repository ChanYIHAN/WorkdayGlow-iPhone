import SwiftUI

private enum RootTab: Hashable {
    case discovery
    case widgets
    case tools
    case dashboard
    case settings
}

struct RootTabView: View {
    @State private var selectedTab: RootTab = .discovery

    var body: some View {
        TabView(selection: $selectedTab) {
            DiscoveryView()
                .tabItem {
                    Label("发现", systemImage: "house.fill")
                }
                .tag(RootTab.discovery)

            WidgetLibraryView()
                .tabItem {
                    Label("组件", systemImage: "square.grid.2x2.fill")
                }
                .tag(RootTab.widgets)

            ToolboxView()
                .tabItem {
                    Label("工具", systemImage: "switch.2")
                }
                .tag(RootTab.tools)

            DashboardView()
                .tabItem {
                    Label("概览", systemImage: "chart.bar.fill")
                }
                .tag(RootTab.dashboard)

            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "slider.horizontal.3")
                }
                .tag(RootTab.settings)
        }
        .tint(Color.accentColor)
        .onOpenURL(perform: handleDeepLink)
    }

    private func handleDeepLink(_ url: URL) {
        let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []
        let value: (String) -> String? = { name in
            queryItems.first(where: { $0.name == name })?.value
        }

        switch url.host {
        case "shortcut":
            selectedTab = .tools
            guard let name = value("name"), !name.isEmpty else { return }
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 350_000_000)
                ShortcutBridge.run(named: name)
            }
        case "tools":
            selectedTab = .tools
        case "widgets":
            selectedTab = .widgets
        case "open":
            selectedTab = .widgets
            guard let destination = value("url"), !destination.isEmpty else { return }
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 350_000_000)
                ShortcutBridge.openExternalURL(destination)
            }
        case "photos", "music", "health", "weather", "love", "time", "finance", "planner", "daily":
            selectedTab = .widgets
        default:
            break
        }
    }
}
