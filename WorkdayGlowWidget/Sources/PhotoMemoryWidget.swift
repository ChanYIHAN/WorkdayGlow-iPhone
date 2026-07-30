import AppIntents
import ImageIO
import SwiftUI
import UIKit
import WidgetKit

struct PhotoMemoryEntry: TimelineEntry {
    let date: Date
    let style: PhotoWidgetStyle
    let photos: [Data]
    let caption: String
}

struct PhotoMemoryProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> PhotoMemoryEntry {
        PhotoMemoryEntry(
            date: .now,
            style: .polaroid,
            photos: [],
            caption: "把喜欢的瞬间留在桌面"
        )
    }

    func snapshot(
        for configuration: PhotoWidgetConfigurationIntent,
        in context: Context
    ) async -> PhotoMemoryEntry {
        makeEntry(configuration)
    }

    func timeline(
        for configuration: PhotoWidgetConfigurationIntent,
        in context: Context
    ) async -> Timeline<PhotoMemoryEntry> {
        Timeline(entries: [makeEntry(configuration)], policy: .never)
    }

    private func makeEntry(_ configuration: PhotoWidgetConfigurationIntent) -> PhotoMemoryEntry {
        let files = [
            configuration.firstPhoto,
            configuration.secondPhoto,
            configuration.thirdPhoto
        ]
        let photos = files.compactMap { file in
            guard let file else { return nil }
            return PhotoThumbnailer.thumbnailData(from: file.data)
        }
        let caption = configuration.caption.trimmingCharacters(in: .whitespacesAndNewlines)
        return PhotoMemoryEntry(
            date: .now,
            style: configuration.style,
            photos: photos,
            caption: caption.isEmpty ? "把喜欢的瞬间留在桌面" : caption
        )
    }
}

struct PhotoMemoryWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: "WorkdayGlow.PhotoMemory",
            intent: PhotoWidgetConfigurationIntent.self,
            provider: PhotoMemoryProvider()
        ) { entry in
            PhotoMemoryWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    CreativeTemplateBackground(template: entry.style.template)
                }
        }
        .configurationDisplayName("相册记忆")
        .description("从“文件”选择照片，提供拍立得、胶片和三格画廊三种版式。")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .contentMarginsDisabled()
    }
}

private struct PhotoMemoryWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: PhotoMemoryEntry

    var body: some View {
        Group {
            switch entry.style {
            case .polaroid:
                polaroid
            case .filmstrip:
                filmstrip
            case .mosaic:
                mosaic
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .widgetURL(URL(string: "workdayglow://photos"))
    }

    private var polaroid: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(Color.white)
                .rotationEffect(.degrees(-2))
                .padding(family == .systemSmall ? 12 : 15)
                .shadow(color: Color("PlumInk").opacity(0.12), radius: 9, y: 5)

            VStack(spacing: 7) {
                photo(at: 0)
                    .clipShape(RoundedRectangle(cornerRadius: 3, style: .continuous))

                HStack {
                    Text(entry.caption)
                        .font(.system(size: family == .systemSmall ? 8 : 10, weight: .black))
                        .lineLimit(1)
                    Spacer()
                    Image(systemName: "heart.fill")
                        .font(.caption2)
                        .foregroundStyle(Color("RoseGlow"))
                }
            }
            .padding(family == .systemSmall ? 19 : 23)
            .foregroundStyle(Color("PlumInk"))
        }
    }

    private var filmstrip: some View {
        VStack(spacing: 8) {
            HStack {
                Text("NO. \(entry.date.formatted(.dateTime.month().day()))")
                Spacer()
                Text("MOMENTS")
            }
            .font(.system(size: 8, weight: .bold))
            .tracking(1.3)
            .foregroundStyle(.white.opacity(0.55))

            HStack(spacing: family == .systemSmall ? 5 : 9) {
                ForEach(0..<visiblePhotoCount, id: \.self) { index in
                    filmFrame(index: index)
                }
            }

            Text(entry.caption)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(.white.opacity(0.62))
                .lineLimit(1)
        }
        .padding(family == .systemSmall ? 12 : 17)
    }

    private var mosaic: some View {
        HStack(spacing: 7) {
            photo(at: 0)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            VStack(spacing: 7) {
                photo(at: 1)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                photo(at: 2)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .frame(width: family == .systemLarge ? 135 : family == .systemSmall ? 58 : 92)
        }
        .padding(family == .systemSmall ? 9 : 12)
        .overlay(alignment: .bottomLeading) {
            Text(entry.caption)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .lineLimit(1)
                .padding(.horizontal, family == .systemSmall ? 14 : 19)
                .padding(.vertical, family == .systemSmall ? 13 : 17)
                .shadow(radius: 4)
        }
    }

    private var visiblePhotoCount: Int {
        switch family {
        case .systemSmall: 2
        case .systemLarge: 3
        default: 3
        }
    }

    private func filmFrame(index: Int) -> some View {
        VStack(spacing: 4) {
            perforations
            photo(at: index)
                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            perforations
        }
        .frame(maxWidth: .infinity)
    }

    private var perforations: some View {
        HStack(spacing: 4) {
            ForEach(0..<4, id: \.self) { _ in
                Capsule()
                    .fill(Color.white.opacity(0.35))
                    .frame(height: 3)
            }
        }
    }

    @ViewBuilder
    private func photo(at index: Int) -> some View {
        if let image = image(at: index) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            ZStack {
                LinearGradient(
                    colors: fallbackColors(index),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                Circle()
                    .fill(Color.white.opacity(0.22))
                    .frame(width: index == 1 ? 80 : 112, height: index == 1 ? 80 : 112)
                    .blur(radius: 4)
                    .offset(x: index == 2 ? 30 : -25, y: index == 1 ? -18 : 24)
                Image(systemName: entry.photos.isEmpty ? "photo.badge.plus" : "camera.aperture")
                    .font(.title2)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.white.opacity(0.72))
            }
        }
    }

    private func image(at index: Int) -> UIImage? {
        guard !entry.photos.isEmpty else { return nil }
        let data = entry.photos[index % entry.photos.count]
        return UIImage(data: data)
    }

    private func fallbackColors(_ index: Int) -> [Color] {
        switch index % 3 {
        case 1:
            [Color("SkyGlow"), Color("AuroraLavender")]
        case 2:
            [Color("ButterGlow"), Color("RoseGlow")]
        default:
            [Color("SeaGlass"), Color("SkyGlow"), Color("AuroraLavender")]
        }
    }
}

private enum PhotoThumbnailer {
    static func thumbnailData(from data: Data, maxPixelSize: Int = 1_200) -> Data? {
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
        return UIImage(cgImage: image).jpegData(compressionQuality: 0.82)
    }
}
