import AppIntents
import SwiftUI
import WidgetKit

struct GoldMarketEntry: TimelineEntry {
    let date: Date
    let style: GoldWidgetStyle
    let data: GoldWidgetData
}

struct GoldMarketProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> GoldMarketEntry {
        GoldMarketEntry(date: .now, style: .spot, data: .preview)
    }

    func snapshot(
        for configuration: GoldWidgetConfigurationIntent,
        in context: Context
    ) async -> GoldMarketEntry {
        if context.isPreview {
            return GoldMarketEntry(date: .now, style: configuration.style, data: .preview)
        }
        return await load(configuration)
    }

    func timeline(
        for configuration: GoldWidgetConfigurationIntent,
        in context: Context
    ) async -> Timeline<GoldMarketEntry> {
        let entry = await load(configuration)
        let refresh = Calendar.autoupdatingCurrent.date(
            byAdding: .hour,
            value: 6,
            to: .now
        ) ?? .now.addingTimeInterval(21_600)
        return Timeline(entries: [entry], policy: .after(refresh))
    }

    private func load(_ configuration: GoldWidgetConfigurationIntent) async -> GoldMarketEntry {
        let cacheKey = "gold.\(configuration.style.rawValue)"
        let data: GoldWidgetData
        do {
            data = try await AlphaVantageFinanceService().fetchGold(
                style: configuration.style,
                apiKey: configuration.apiKey
            )
            FinanceDataCache.save(data, key: cacheKey)
        } catch {
            data = FinanceDataCache.load(GoldWidgetData.self, key: cacheKey)
                ?? .unavailable(error.localizedDescription)
        }
        return GoldMarketEntry(date: .now, style: configuration.style, data: data)
    }
}

struct GoldMarketWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: "WorkdayGlow.GoldMarket",
            intent: GoldWidgetConfigurationIntent.self,
            provider: GoldMarketProvider()
        ) { entry in
            GoldMarketWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    FinanceTemplateBackground(template: entry.style.template)
                }
        }
        .configurationDisplayName("黄金价格")
        .description("通过用户自己的 Alpha Vantage Key 显示黄金、白银与近期价格。")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .contentMarginsDisabled()
    }
}

private struct GoldMarketWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: GoldMarketEntry

    var body: some View {
        FinanceTemplateArtwork(
            template: entry.style.template,
            size: artworkSize,
            gold: entry.data
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .widgetURL(URL(string: "workdayglow://finance"))
    }

    private var artworkSize: WidgetArtworkSize {
        switch family {
        case .systemSmall: .small
        case .systemLarge: .large
        default: .medium
        }
    }
}
