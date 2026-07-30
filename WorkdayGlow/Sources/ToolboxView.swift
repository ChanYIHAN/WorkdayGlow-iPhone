import SwiftUI
import UIKit

struct ToolboxView: View {
    private let shortcuts = ShortcutBridge.presets

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    hero
                    shortcutGrid
                    setupGuide
                    limitationNote
                }
                .padding()
                .padding(.bottom, 24)
            }
            .background(Color("GalleryCanvas").ignoresSafeArea())
            .navigationTitle("快捷工具")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        ShortcutBridge.openShortcutEditor()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("新建快捷指令")
                }
            }
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("CONTROL")
                        .font(.system(size: 11, weight: .black))
                        .tracking(2.4)
                        .foregroundStyle(Color("SeaGlass"))

                    Text("把系统开关\n变成桌面捷径")
                        .font(.title)
                        .fontWeight(.black)
                        .fontDesign(.rounded)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.08))
                    Image(systemName: "switch.2")
                        .font(.title2)
                        .foregroundStyle(Color("AuroraLavender"))
                }
                .frame(width: 54, height: 54)
            }

            HStack(spacing: 8) {
                ForEach(shortcuts) { shortcut in
                    Image(systemName: shortcut.symbol)
                        .font(.caption)
                        .foregroundStyle(shortcut.tint)
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .background(Color.white.opacity(0.08), in: Capsule())
                }
            }
        }
        .padding(20)
        .foregroundStyle(.white)
        .background(
            LinearGradient(
                colors: [Color("GlowCanvas"), Color("PlumInk")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 30, style: .continuous)
        )
        .overlay(alignment: .topTrailing) {
            Circle()
                .fill(Color("AuroraLavender").opacity(0.18))
                .frame(width: 150, height: 150)
                .blur(radius: 18)
                .offset(x: 44, y: -65)
                .allowsHitTesting(false)
        }
    }

    private var shortcutGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(shortcuts) { shortcut in
                Button {
                    ShortcutBridge.run(named: shortcut.name)
                } label: {
                    VStack(alignment: .leading, spacing: 13) {
                        HStack {
                            Image(systemName: shortcut.symbol)
                                .font(.headline)
                                .foregroundStyle(shortcut.tint)
                                .frame(width: 38, height: 38)
                                .background(shortcut.tint.opacity(0.12), in: Circle())
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }

                        Text(shortcut.title)
                            .font(.headline)
                            .foregroundStyle(.primary)

                        Text(shortcut.name)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(15)
                    .background(
                        Color.white.opacity(0.9),
                        in: RoundedRectangle(cornerRadius: 22, style: .continuous)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var setupGuide: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label("第一次使用", systemImage: "wand.and.stars")
                    .font(.headline)
                Spacer()
                Button("打开快捷指令") {
                    ShortcutBridge.openShortcutEditor()
                }
                .font(.caption)
                .buttonStyle(.bordered)
            }

            guideRow(
                number: 1,
                text: "在“快捷指令”App 新建四条快捷指令，名称分别为：切换 Wi-Fi、切换蓝牙、切换蜂窝数据、切换飞行模式。"
            )
            guideRow(
                number: 2,
                text: "每条快捷指令加入对应的“设置”动作，并把开/关选项改为“切换”。"
            )
            guideRow(
                number: 3,
                text: "添加“快捷工具”桌面组件；如果你使用了不同名称，长按组件并在编辑页修改名称。"
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var limitationNote: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "checkmark.shield.fill")
                .foregroundStyle(Color("SeaGlass"))
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text("合规的系统快捷方式")
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text("iOS 不向普通 App 开放直接切换这些系统状态的接口，因此这里使用 Apple 自带“快捷指令”执行，不申请额外权限，也不使用私有设置地址。")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(Color("SeaGlass").opacity(0.09), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private func guideRow(number: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: 11) {
            Text("\(number)")
                .font(.caption)
                .fontWeight(.black)
                .frame(width: 24, height: 24)
                .background(Color("ButterGlow"), in: Circle())
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

struct ShortcutPreset: Identifiable {
    let id: String
    let title: String
    let name: String
    let symbol: String
    let tint: Color
}

@MainActor
enum ShortcutBridge {
    static let presets: [ShortcutPreset] = [
        ShortcutPreset(
            id: "wifi",
            title: "Wi-Fi",
            name: "切换 Wi-Fi",
            symbol: "wifi",
            tint: Color("SkyGlow")
        ),
        ShortcutPreset(
            id: "bluetooth",
            title: "蓝牙",
            name: "切换蓝牙",
            symbol: "point.3.connected.trianglepath.dotted",
            tint: Color("AuroraLavender")
        ),
        ShortcutPreset(
            id: "cellular",
            title: "蜂窝数据",
            name: "切换蜂窝数据",
            symbol: "antenna.radiowaves.left.and.right",
            tint: Color("SeaGlass")
        ),
        ShortcutPreset(
            id: "airplane",
            title: "飞行模式",
            name: "切换飞行模式",
            symbol: "airplane",
            tint: Color("AuroraCoral")
        )
    ]

    static func run(named name: String) {
        var components = URLComponents()
        components.scheme = "shortcuts"
        components.host = "run-shortcut"
        components.queryItems = [URLQueryItem(name: "name", value: name)]
        guard let url = components.url else { return }
        UIApplication.shared.open(url)
    }

    static func openShortcutEditor() {
        guard let url = URL(string: "shortcuts://create-shortcut") else { return }
        UIApplication.shared.open(url)
    }

    static func openExternalURL(_ rawValue: String) {
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: trimmed), let scheme = url.scheme?.lowercased() else {
            UIApplication.shared.open(URL(string: "music://")!)
            return
        }

        let allowedSchemes = ["https", "http", "music"]
        UIApplication.shared.open(allowedSchemes.contains(scheme) ? url : URL(string: "music://")!)
    }
}
