import AppIntents
import SwiftUI
import WidgetKit

struct UtilityShortcut: Identifiable {
    let id: String
    let title: String
    let symbol: String
    let tint: Color
    let shortcutName: String

    var bridgeURL: URL {
        var components = URLComponents()
        components.scheme = "workdayglow"
        components.host = "shortcut"
        components.queryItems = [URLQueryItem(name: "name", value: shortcutName)]
        return components.url ?? URL(string: "workdayglow://tools")!
    }
}

struct UtilityLauncherEntry: TimelineEntry {
    let date: Date
    let style: UtilityWidgetStyle
    let shortcuts: [UtilityShortcut]
}

struct UtilityLauncherProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> UtilityLauncherEntry {
        entry(style: .deck)
    }

    func snapshot(
        for configuration: UtilityWidgetConfigurationIntent,
        in context: Context
    ) async -> UtilityLauncherEntry {
        entry(configuration: configuration)
    }

    func timeline(
        for configuration: UtilityWidgetConfigurationIntent,
        in context: Context
    ) async -> Timeline<UtilityLauncherEntry> {
        Timeline(entries: [entry(configuration: configuration)], policy: .never)
    }

    private func entry(
        configuration: UtilityWidgetConfigurationIntent? = nil,
        style: UtilityWidgetStyle? = nil
    ) -> UtilityLauncherEntry {
        UtilityLauncherEntry(
            date: .now,
            style: configuration?.style ?? style ?? .deck,
            shortcuts: [
                UtilityShortcut(
                    id: "wifi",
                    title: "Wi-Fi",
                    symbol: "wifi",
                    tint: Color("SkyGlow"),
                    shortcutName: normalized(configuration?.wifiShortcutName, fallback: "切换 Wi-Fi")
                ),
                UtilityShortcut(
                    id: "bluetooth",
                    title: "蓝牙",
                    symbol: "point.3.connected.trianglepath.dotted",
                    tint: Color("AuroraLavender"),
                    shortcutName: normalized(configuration?.bluetoothShortcutName, fallback: "切换蓝牙")
                ),
                UtilityShortcut(
                    id: "cellular",
                    title: "蜂窝",
                    symbol: "antenna.radiowaves.left.and.right",
                    tint: Color("SeaGlass"),
                    shortcutName: normalized(configuration?.cellularShortcutName, fallback: "切换蜂窝数据")
                ),
                UtilityShortcut(
                    id: "airplane",
                    title: "飞行",
                    symbol: "airplane",
                    tint: Color("AuroraCoral"),
                    shortcutName: normalized(configuration?.airplaneShortcutName, fallback: "切换飞行模式")
                )
            ]
        )
    }

    private func normalized(_ value: String?, fallback: String) -> String {
        let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmed.isEmpty ? fallback : trimmed
    }
}

struct UtilityLauncherWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: "WorkdayGlow.UtilityLauncher",
            intent: UtilityWidgetConfigurationIntent.self,
            provider: UtilityLauncherProvider()
        ) { entry in
            UtilityLauncherWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    CreativeTemplateBackground(template: entry.style.template)
                }
        }
        .configurationDisplayName("快捷工具")
        .description("通过系统“快捷指令”运行 Wi-Fi、蓝牙、蜂窝数据和飞行模式动作。")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

private struct UtilityLauncherWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: UtilityLauncherEntry

    var body: some View {
        Group {
            switch entry.style {
            case .deck:
                deck
            case .stack:
                stack
            case .focus:
                focus
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .widgetURL(URL(string: "workdayglow://tools"))
    }

    private var deck: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("快捷控制")
                        .font(.headline)
                        .fontWeight(.black)
                    Text("SHORTCUT CONSOLE")
                        .font(.system(size: 8, weight: .bold))
                        .tracking(1.5)
                        .foregroundStyle(.white.opacity(0.38))
                }
                Spacer()
                Image(systemName: "command")
                    .foregroundStyle(Color("SeaGlass"))
            }

            if family == .systemSmall {
                compactGrid
            } else {
                HStack(spacing: 9) {
                    ForEach(entry.shortcuts) { shortcut in
                        Link(destination: shortcut.bridgeURL) {
                            VStack(spacing: 7) {
                                Image(systemName: shortcut.symbol)
                                    .font(.headline)
                                    .foregroundStyle(shortcut.tint)
                                    .frame(width: 33, height: 33)
                                    .background(shortcut.tint.opacity(0.14), in: Circle())
                                Text(shortcut.title)
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundStyle(.white.opacity(0.64))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(
                                Color.white.opacity(0.07),
                                in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                            )
                        }
                    }
                }
            }
        }
        .padding(family == .systemSmall ? 15 : 17)
        .foregroundStyle(.white)
    }

    private var stack: some View {
        VStack(alignment: .leading, spacing: 11) {
            HStack {
                Image(systemName: "bolt.fill")
                    .foregroundStyle(Color("AuroraCoral"))
                Text("QUICK SWITCH")
                    .font(.system(size: 9, weight: .black))
                    .tracking(1.4)
                Spacer()
            }

            Spacer(minLength: 0)
            compactGrid
        }
        .padding(15)
        .foregroundStyle(Color("PlumInk"))
    }

    private var focus: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "moon.stars.fill")
                    .foregroundStyle(Color("ButterGlow"))
                Spacer()
                Text(entry.date, style: .time)
                    .font(.caption2)
                    .monospacedDigit()
                    .foregroundStyle(.white.opacity(0.45))
            }

            Spacer()
            Text("安静一会儿")
                .font(family == .systemSmall ? .title3 : .title2)
                .fontWeight(.black)
            Text("连接、飞行与离线状态")
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.52))

            HStack(spacing: 7) {
                ForEach(entry.shortcuts) { shortcut in
                    Link(destination: shortcut.bridgeURL) {
                        Image(systemName: shortcut.symbol)
                            .font(.caption)
                            .foregroundStyle(shortcut.tint)
                            .frame(maxWidth: family == .systemSmall ? nil : .infinity)
                            .frame(width: family == .systemSmall ? 29 : nil, height: 31)
                            .background(Color.white.opacity(0.1), in: Capsule())
                    }
                }
            }
        }
        .padding(16)
        .foregroundStyle(.white)
    }

    private var compactGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
            ForEach(entry.shortcuts) { shortcut in
                Link(destination: shortcut.bridgeURL) {
                    Image(systemName: shortcut.symbol)
                        .font(.headline)
                        .foregroundStyle(shortcut.tint)
                        .frame(maxWidth: .infinity)
                        .frame(height: 39)
                        .background(
                            Color.white.opacity(entry.style == .focus ? 0.1 : 0.68),
                            in: RoundedRectangle(cornerRadius: 13, style: .continuous)
                        )
                }
            }
        }
    }
}
