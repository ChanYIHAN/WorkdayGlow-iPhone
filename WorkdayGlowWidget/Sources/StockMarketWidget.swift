import AppIntents
import SwiftUI
import WidgetKit

struct StockMarketEntry: TimelineEntry {
    let date: Date
    let style: StockWidgetStyle
    let data: StockWidgetData
}

struct StockMarketProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> StockMarketEntry {
        StockMarketEntry(date: .now, style: .watchlist, data: .preview)
    }

    func snapshot(
        for configuration: StockWidgetConfigurationIntent,
        in context: Context
    ) async -> StockMarketEntry {
        if context.isPreview {
            return StockMarketEntry(date: .now, style: configuration.style, data: .preview)
        }
        return await load(configuration)
    }

    func timeline(
        for configuration: StockWidgetConfigurationIntent,
        in context: Context
    ) async -> Timeline<StockMarketEntry> {
        let entry = await load(configuration)
        let refresh = Calendar.autoupdatingCurrent.date(
            byAdding: .hour,
            value: 18,
            to: .now
        ) ?? .now.addingTimeInterval(64_800)
        return Timeline(entries: [entry], policy: .after(refresh))
    }

    private func load(_ configuration: StockWidgetConfigurationIntent) async -> StockMarketEntry {
        let allRequests: [(symbol: String, name: String)] = [
            (symbol: configuration.firstSymbol, name: configuration.firstName),
            (symbol: configuration.secondSymbol, name: configuration.secondName),
            (symbol: configuration.thirdSymbol, name: configuration.thirdName)
        ]
        let requests: [(symbol: String, name: String)]
        switch configuration.style {
        case .quote:
            requests = Array(allRequests.prefix(1))
        case .dual:
            requests = Array(allRequests.prefix(2))
        case .watchlist:
            requests = allRequests
        }
        let cacheKey = "stocks." + requests.map { $0.symbol }.joined(separator: "-")
        let data: StockWidgetData
        do {
            data = try await AlphaVantageFinanceService().fetchStocks(
                symbols: requests,
                apiKey: configuration.apiKey
            )
            FinanceDataCache.save(data, key: cacheKey)
        } catch {
            data = FinanceDataCache.load(StockWidgetData.self, key: cacheKey)
                ?? .unavailable(error.localizedDescription)
        }
        return StockMarketEntry(date: .now, style: configuration.style, data: data)
    }
}

struct StockMarketWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: "WorkdayGlow.StockMarket",
            intent: StockWidgetConfigurationIntent.self,
            provider: StockMarketProvider()
        ) { entry in
            StockMarketWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    FinanceTemplateBackground(template: entry.style.template)
                }
        }
        .configurationDisplayName("港美股行情")
        .description("显示 Alpha Vantage 最新日线收盘价；免费模式不提供实时交易行情。")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .contentMarginsDisabled()
    }
}

private struct StockMarketWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: StockMarketEntry

    var body: some View {
        FinanceTemplateArtwork(
            template: entry.style.template,
            size: artworkSize,
            stocks: entry.data
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
