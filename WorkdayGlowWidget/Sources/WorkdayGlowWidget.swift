import AppIntents
import SwiftUI
import WidgetKit

struct WorkdayGlowEntry: TimelineEntry {
    let date: Date
    let settings: WorkdaySettings
}

struct WorkdayGlowProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> WorkdayGlowEntry {
        WorkdayGlowEntry(date: previewDate, settings: .preview)
    }

    func snapshot(
        for configuration: WorkdayConfigurationIntent,
        in context: Context,
    ) async -> WorkdayGlowEntry {
        WorkdayGlowEntry(
            date: context.isPreview ? previewDate : .now,
            settings: context.isPreview ? .preview : configuration.settings
        )
    }

    func timeline(
        for configuration: WorkdayConfigurationIntent,
        in context: Context,
    ) async -> Timeline<WorkdayGlowEntry> {
        let now = Date()
        let settings = configuration.settings
        let dates = timelineDates(startingAt: now, settings: settings)
        let entries = dates.map {
            WorkdayGlowEntry(date: $0, settings: settings)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

    private func timelineDates(startingAt now: Date, settings: WorkdaySettings) -> [Date] {
        let calendar = Calendar.autoupdatingCurrent
        let horizon = calendar.date(byAdding: .day, value: 1, to: now)
            ?? now.addingTimeInterval(86_400)

        var dates = [now]

        // Cached entries keep the progress rail and status reasonably fresh without
        // asking the extension to run continuously.
        var cursor = calendar.date(byAdding: .minute, value: 30, to: now) ?? horizon
        while cursor <= horizon {
            dates.append(cursor)
            cursor = calendar.date(byAdding: .minute, value: 30, to: cursor) ?? horizon.addingTimeInterval(1)
        }

        for dayOffset in 0...1 {
            guard let day = calendar.date(byAdding: .day, value: dayOffset, to: calendar.startOfDay(for: now)) else {
                continue
            }
            if let start = calendar.date(byAdding: .minute, value: settings.startMinute, to: day),
               start >= now, start <= horizon {
                dates.append(start)
            }
            if let end = calendar.date(byAdding: .minute, value: settings.safeEndMinute, to: day),
               end >= now, end <= horizon {
                dates.append(end)
            }
        }

        return Array(Set(dates)).sorted()
    }

    private var previewDate: Date {
        let calendar = Calendar.current
        let day = calendar.startOfDay(for: .now)
        return calendar.date(byAdding: .minute, value: 13 * 60 + 25, to: day) ?? .now
    }
}

struct WorkdayGlowWidget: Widget {
    private let kind = "WorkdayGlowWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: WorkdayConfigurationIntent.self,
            provider: WorkdayGlowProvider()
        ) { entry in
            WorkdayGlowWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    entry.settings.theme.palette.backgroundGradient
                }
        }
        .configurationDisplayName("奕刻")
        .description("查看距离下班的时间、今日进度、预计收入和发薪倒计时。")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .contentMarginsDisabled()
    }
}
