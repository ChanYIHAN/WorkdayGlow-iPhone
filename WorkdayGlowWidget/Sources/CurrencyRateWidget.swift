import AppIntents
import SwiftUI
import WidgetKit

struct CurrencyRateEntry: TimelineEntry {
    let date: Date
    let style: CurrencyWidgetStyle
    let data: CurrencyWidgetData
}

struct CurrencyRateProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> CurrencyRateEntry {
        CurrencyRateEntry(date: .now, style: .minimal, data: .preview)
    }

    func snapshot(
        for configuration: CurrencyWidgetConfigurationIntent,
        in context: Context
    ) async -> CurrencyRateEntry {
        if context.isPreview {
            return CurrencyRateEntry(date: .now, style: configuration.style, data: .preview)
        }
        return await load(configuration)
    }

    func timeline(
        for configuration: CurrencyWidgetConfigurationIntent,
        in context: Context
    ) async -> Timeline<CurrencyRateEntry> {
        let entry = await load(configuration)
        let refresh = Calendar.autoupdatingCurrent.date(
            byAdding: .hour,
            value: 12,
            to: .now
        ) ?? .now.addingTimeInterval(43_200)
        return Timeline(entries: [entry], policy: .after(refresh))
    }

    private func load(_ configuration: CurrencyWidgetConfigurationIntent) async -> CurrencyRateEntry {
        let cacheKey = [
            "currency",
            configuration.baseCurrency.rawValue,
            configuration.quoteCurrency.rawValue,
            String(configuration.amount)
        ].joined(separator: ".")

        let data: CurrencyWidgetData
        do {
            data = try await ECBExchangeRateService().fetch(
                base: configuration.baseCurrency,
                quote: configuration.quoteCurrency,
                amount: configuration.amount
            )
            FinanceDataCache.save(data, key: cacheKey)
        } catch {
            data = FinanceDataCache.load(CurrencyWidgetData.self, key: cacheKey)
                ?? .unavailable(
                    baseCode: configuration.baseCurrency.rawValue,
                    quoteCode: configuration.quoteCurrency.rawValue,
                    amount: configuration.amount,
                    message: error.localizedDescription
                )
        }
        return CurrencyRateEntry(date: .now, style: configuration.style, data: data)
    }
}

struct CurrencyRateWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: "WorkdayGlow.CurrencyRate",
            intent: CurrencyWidgetConfigurationIntent.self,
            provider: CurrencyRateProvider()
        ) { entry in
            CurrencyRateWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    FinanceTemplateBackground(template: entry.style.template)
                }
        }
        .configurationDisplayName("汇率换算")
        .description("使用 ECB 每日参考汇率，提供极简、矩阵和旅行换算三种样式。")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .contentMarginsDisabled()
    }
}

private struct CurrencyRateWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: CurrencyRateEntry

    var body: some View {
        FinanceTemplateArtwork(
            template: entry.style.template,
            size: artworkSize,
            currency: entry.data
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
