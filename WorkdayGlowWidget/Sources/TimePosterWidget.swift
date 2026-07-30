import AppIntents
import SwiftUI
import WidgetKit

struct TimePosterEntry: TimelineEntry {
    let date: Date
    let data: ClockWidgetData
    let style: ClockWidgetStyle
}

struct TimePosterProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> TimePosterEntry {
        TimePosterEntry(date: .now, data: .preview, style: .editorial)
    }

    func snapshot(
        for configuration: ClockWidgetConfigurationIntent,
        in context: Context
    ) async -> TimePosterEntry {
        TimePosterEntry(
            date: .now,
            data: context.isPreview ? .preview : configuration.data,
            style: configuration.style
        )
    }

    func timeline(
        for configuration: ClockWidgetConfigurationIntent,
        in context: Context
    ) async -> Timeline<TimePosterEntry> {
        let calendar = Calendar.autoupdatingCurrent
        let now = Date()
        let minuteStart = calendar.date(
            from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: now)
        ) ?? now
        let entries = (0...60).compactMap { offset -> TimePosterEntry? in
            guard let date = calendar.date(byAdding: .minute, value: offset, to: minuteStart) else {
                return nil
            }
            return TimePosterEntry(
                date: date,
                data: configuration.data,
                style: configuration.style
            )
        }
        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct TimePosterWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: "WorkdayGlow.TimePoster",
            intent: ClockWidgetConfigurationIntent.self,
            provider: TimePosterProvider()
        ) { entry in
            TimePosterWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    LifestyleTemplateBackground(template: entry.style.template)
                }
        }
        .configurationDisplayName("时间画报")
        .description("提供编辑部时钟、世界时间和日历时钟三种样式。")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

private struct TimePosterWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: TimePosterEntry

    var body: some View {
        LifestyleTemplateArtwork(
            template: entry.style.template,
            size: family == .systemSmall ? .small : .medium,
            date: entry.date,
            clock: entry.data
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .widgetURL(URL(string: "workdayglow://time"))
    }
}
