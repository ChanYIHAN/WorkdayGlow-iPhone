import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            DiscoveryView()
                .tabItem {
                    Label("发现", systemImage: "house.fill")
                }

            WidgetLibraryView()
                .tabItem {
                    Label("组件", systemImage: "square.grid.2x2.fill")
                }

            DashboardView()
                .tabItem {
                    Label("概览", systemImage: "chart.bar.fill")
                }

            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "slider.horizontal.3")
                }
        }
        .tint(Color("PlumInk"))
    }
}
