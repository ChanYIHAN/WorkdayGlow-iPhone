import AppIntents
import ImageIO
import SwiftUI
import UIKit
import WidgetKit

struct MusicLauncherEntry: TimelineEntry {
    let date: Date
    let style: MusicWidgetStyle
    let title: String
    let artist: String
    let coverData: Data?
    let bridgeURL: URL
}

struct MusicLauncherProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> MusicLauncherEntry {
        MusicLauncherEntry(
            date: .now,
            style: .vinyl,
            title: "Midnight Drive",
            artist: "YOUR DAILY MIX",
            coverData: nil,
            bridgeURL: musicBridgeURL("music://")
        )
    }

    func snapshot(
        for configuration: MusicWidgetConfigurationIntent,
        in context: Context
    ) async -> MusicLauncherEntry {
        makeEntry(configuration)
    }

    func timeline(
        for configuration: MusicWidgetConfigurationIntent,
        in context: Context
    ) async -> Timeline<MusicLauncherEntry> {
        Timeline(entries: [makeEntry(configuration)], policy: .never)
    }

    private func makeEntry(_ configuration: MusicWidgetConfigurationIntent) -> MusicLauncherEntry {
        let title = normalized(configuration.titleText, fallback: "Midnight Drive")
        let artist = normalized(configuration.artistText, fallback: "YOUR DAILY MIX")
        let destination = normalized(configuration.musicURL, fallback: "music://")
        let coverData = configuration.coverImage.flatMap {
            MusicCoverThumbnailer.thumbnailData(from: $0.data)
        }

        return MusicLauncherEntry(
            date: .now,
            style: configuration.style,
            title: title,
            artist: artist,
            coverData: coverData,
            bridgeURL: musicBridgeURL(destination)
        )
    }

    private func normalized(_ value: String, fallback: String) -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? fallback : trimmed
    }
}

struct MusicLauncherWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: "WorkdayGlow.MusicLauncher",
            intent: MusicWidgetConfigurationIntent.self,
            provider: MusicLauncherProvider()
        ) { entry in
            MusicLauncherWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    CreativeTemplateBackground(template: entry.style.template)
                }
        }
        .configurationDisplayName("音乐播放器")
        .description("展示自定义封面与歌单信息，点击后打开 Apple Music 分享链接。")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

private struct MusicLauncherWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: MusicLauncherEntry

    var body: some View {
        Link(destination: entry.bridgeURL) {
            Group {
                switch entry.style {
                case .vinyl:
                    vinyl
                case .glass:
                    glass
                case .wave:
                    wave
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .accessibilityLabel("打开音乐：\(entry.title)，\(entry.artist)")
    }

    private var vinyl: some View {
        Group {
            if family == .systemSmall {
                VStack(alignment: .leading, spacing: 7) {
                    HStack {
                        Text("NOW SPINNING")
                            .font(.system(size: 8, weight: .black))
                            .tracking(1.4)
                            .foregroundStyle(.white.opacity(0.42))
                        Spacer()
                        Image(systemName: "music.note")
                            .foregroundStyle(Color("SeaGlass"))
                    }

                    Spacer()
                    record(diameter: 82)
                    Text(entry.title)
                        .font(.caption)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    Text(entry.artist)
                        .font(.system(size: 8, weight: .semibold))
                        .tracking(0.7)
                        .foregroundStyle(.white.opacity(0.4))
                        .lineLimit(1)
                }
            } else {
                HStack(spacing: 18) {
                    record(diameter: 118)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("NOW SPINNING")
                            .font(.system(size: 8, weight: .black))
                            .tracking(1.5)
                            .foregroundStyle(.white.opacity(0.42))
                        Text(entry.title)
                            .font(.title3)
                            .fontWeight(.black)
                            .lineLimit(2)
                        Text(entry.artist)
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.48))
                            .lineLimit(1)
                        Label("在 Apple Music 中打开", systemImage: "play.fill")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color("SeaGlass"))
                            .padding(.top, 7)
                    }
                    Spacer(minLength: 0)
                }
            }
        }
        .padding(family == .systemSmall ? 15 : 17)
        .foregroundStyle(.white)
    }

    private var glass: some View {
        HStack(spacing: 16) {
            cover
                .frame(width: family == .systemSmall ? 72 : 104, height: family == .systemSmall ? 72 : 104)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                }

            VStack(alignment: .leading, spacing: 5) {
                Text("正在播放")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.58))
                Text(entry.title)
                    .font(family == .systemSmall ? .headline : .title3)
                    .fontWeight(.black)
                    .lineLimit(2)
                Text(entry.artist)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.58))
                    .lineLimit(1)
                HStack(spacing: 15) {
                    Image(systemName: "backward.fill")
                    Image(systemName: "play.fill")
                        .padding(9)
                        .background(.white, in: Circle())
                        .foregroundStyle(Color("PlumInk"))
                    Image(systemName: "forward.fill")
                }
                .font(.caption)
                .padding(.top, 4)
            }
            Spacer(minLength: 0)
        }
        .padding(17)
        .foregroundStyle(.white)
    }

    private var wave: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "waveform")
                    .foregroundStyle(Color("RoseGlow"))
                Spacer()
                Image(systemName: "play.fill")
                    .font(.caption)
                    .padding(8)
                    .background(Color("PlumInk"), in: Circle())
                    .foregroundStyle(.white)
            }

            Spacer()
            Text(entry.title)
                .font(family == .systemSmall ? .headline : .title3)
                .fontWeight(.black)
                .lineLimit(1)
            Text(entry.artist)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)

            HStack(alignment: .center, spacing: 3) {
                ForEach(0..<20, id: \.self) { index in
                    Capsule()
                        .fill(index < 8 ? Color("RoseGlow") : Color("PlumInk").opacity(0.16))
                        .frame(height: CGFloat(5 + ((index * 7) % 20)))
                }
            }
            .frame(height: 25)
        }
        .padding(15)
        .foregroundStyle(Color("PlumInk"))
    }

    private func record(diameter: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(Color.black.opacity(0.78))
            ForEach([0.82, 0.62, 0.42], id: \.self) { scale in
                Circle()
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    .scaleEffect(scale)
            }
            cover
                .frame(width: diameter * 0.42, height: diameter * 0.42)
                .clipShape(Circle())
            Circle()
                .fill(Color("GlowCanvas"))
                .frame(width: diameter * 0.07, height: diameter * 0.07)
        }
        .frame(width: diameter, height: diameter)
    }

    @ViewBuilder
    private var cover: some View {
        if let data = entry.coverData, let image = UIImage(data: data) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            ZStack {
                LinearGradient(
                    colors: [Color("RoseGlow"), Color("AuroraLavender"), Color("SkyGlow")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                Image(systemName: "music.quarternote.3")
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.84))
            }
        }
    }
}

private func musicBridgeURL(_ destination: String) -> URL {
    var components = URLComponents()
    components.scheme = "workdayglow"
    components.host = "open"
    components.queryItems = [URLQueryItem(name: "url", value: destination)]
    return components.url ?? URL(string: "workdayglow://music")!
}

private enum MusicCoverThumbnailer {
    static func thumbnailData(from data: Data, maxPixelSize: Int = 1_000) -> Data? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixelSize
        ]
        guard let image = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else {
            return nil
        }
        return UIImage(cgImage: image).jpegData(compressionQuality: 0.84)
    }
}
