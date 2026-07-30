import AppIntents
import SwiftUI
import WidgetKit

struct LoveAnniversaryEntry: TimelineEntry {
    let date: Date
    let data: LoveWidgetData
    let style: LoveWidgetStyle
}

struct LoveAnniversaryProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> LoveAnniversaryEntry {
        LoveAnniversaryEntry(date: .now, data: .preview, style: .days)
    }

    func snapshot(
        for configuration: LoveWidgetConfigurationIntent,
        in context: Context
    ) async -> LoveAnniversaryEntry {
        LoveAnniversaryEntry(
            date: .now,
            data: context.isPreview ? .preview : configuration.data,
            style: configuration.style
        )
    }

    func timeline(
        for configuration: LoveWidgetConfigurationIntent,
        in context: Context
    ) async -> Timeline<LoveAnniversaryEntry> {
        let now = Date()
        let entry = LoveAnniversaryEntry(
            date: now,
            data: configuration.data,
            style: configuration.style
        )
        let nextMidnight = Calendar.autoupdatingCurrent.date(
            byAdding: .day,
            value: 1,
            to: Calendar.autoupdatingCurrent.startOfDay(for: now)
        ) ?? now.addingTimeInterval(86_400)
        return Timeline(entries: [entry], policy: .after(nextMidnight))
    }
}

struct LoveAnniversaryWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: "WorkdayGlow.LoveAnniversary",
            intent: LoveWidgetConfigurationIntent.self,
            provider: LoveAnniversaryProvider()
        ) { entry in
            LoveAnniversaryWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    LifestyleTemplateBackground(template: entry.style.template)
                }
        }
        .configurationDisplayName("恋爱纪念日")
        .description("记录在一起的天数，并倒数下一个周年纪念日。")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

private struct LoveAnniversaryWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: LoveAnniversaryEntry

    var body: some View {
        LifestyleTemplateArtwork(
            template: entry.style.template,
            size: family == .systemSmall ? .small : .medium,
            date: entry.date,
            love: entry.data
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .widgetURL(URL(string: "workdayglow://love"))
    }
}
