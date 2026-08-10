import AppIntents
import SwiftUI
import WidgetKit

struct DailyInspirationEntry: TimelineEntry {
    let date: Date
    let style: DailyWidgetStyle
    let data: DailyWidgetData
}

struct DailyInspirationProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> DailyInspirationEntry {
        DailyInspirationEntry(date: .now, style: .quote, data: .preview)
    }

    func snapshot(
        for configuration: DailyWidgetConfigurationIntent,
        in context: Context
    ) async -> DailyInspirationEntry {
        let now = Date()
        return DailyInspirationEntry(
            date: now,
            style: configuration.style,
            data: context.isPreview ? .preview : configuration.data(at: now)
        )
    }

    func timeline(
        for configuration: DailyWidgetConfigurationIntent,
        in context: Context
    ) async -> Timeline<DailyInspirationEntry> {
        let now = Date()
        let entry = DailyInspirationEntry(
            date: now,
            style: configuration.style,
            data: configuration.data(at: now)
        )
        let next = Calendar.autoupdatingCurrent.date(byAdding: .minute, value: 30, to: now)
            ?? now.addingTimeInterval(1_800)
        return Timeline(entries: [entry], policy: .after(next))
    }
}

struct DailyInspirationWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: "WorkdayGlow.DailyInspiration",
            intent: DailyWidgetConfigurationIntent.self,
            provider: DailyInspirationProvider()
        ) { entry in
            DailyInspirationWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    EverydayTemplateBackground(template: entry.style.template)
                }
        }
        .configurationDisplayName("每日灵感")
        .description("每日一句、本地月相和可调整的日光节律。")
        .supportedFamilies([
            .systemSmall, .systemMedium,
            .accessoryInline, .accessoryCircular, .accessoryRectangular
        ])
        .contentMarginsDisabled()
    }
}

private struct DailyInspirationWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: DailyInspirationEntry

    var body: some View {
        switch family {
        case .accessoryInline:
            Label(inlineText, systemImage: entry.style == .moon ? entry.data.moonSymbol : "sparkles")
        case .accessoryCircular:
            if entry.style == .sun {
                Gauge(value: entry.data.solarProgress) {
                    Image(systemName: "sun.max.fill")
                }
                .gaugeStyle(.accessoryCircular)
            } else {
                Image(systemName: entry.data.moonSymbol)
                    .font(.title)
            }
        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 3) {
                Label(rectangularTitle, systemImage: rectangularSymbol)
                    .font(.caption2.weight(.bold))
                Text(rectangularBody)
                    .font(.headline)
                    .lineLimit(2)
            }
        default:
            EverydayTemplateArtwork(
                template: entry.style.template,
                size: family == .systemSmall ? .small : .medium,
                date: entry.date,
                daily: entry.data
            )
        }
    }

    private var inlineText: String {
        switch entry.style {
        case .quote: entry.data.quote
        case .moon: "今夜 \(entry.data.moonName)"
        case .sun: "日落 \(entry.data.sunset)"
        }
    }

    private var rectangularTitle: String {
        switch entry.style {
        case .quote: "每日一句"
        case .moon: "今晚月相"
        case .sun: "日光节律"
        }
    }

    private var rectangularBody: String {
        switch entry.style {
        case .quote: entry.data.quote
        case .moon: "\(entry.data.moonName) · 距满月约 \(entry.data.daysUntilFullMoon) 天"
        case .sun: "\(entry.data.sunrise) 日出 · \(entry.data.sunset) 日落"
        }
    }

    private var rectangularSymbol: String {
        switch entry.style {
        case .quote: "quote.opening"
        case .moon: entry.data.moonSymbol
        case .sun: "sun.horizon.fill"
        }
    }
}
