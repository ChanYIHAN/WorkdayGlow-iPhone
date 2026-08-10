import AppIntents
import SwiftUI
import WidgetKit

struct PlannerEntry: TimelineEntry {
    let date: Date
    let style: PlannerWidgetStyle
    let data: PlannerWidgetData
}

struct PlannerProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> PlannerEntry {
        PlannerEntry(date: .now, style: .agenda, data: .preview)
    }

    func snapshot(
        for configuration: PlannerWidgetConfigurationIntent,
        in context: Context
    ) async -> PlannerEntry {
        PlannerEntry(
            date: .now,
            style: configuration.style,
            data: context.isPreview ? .preview : configuration.data
        )
    }

    func timeline(
        for configuration: PlannerWidgetConfigurationIntent,
        in context: Context
    ) async -> Timeline<PlannerEntry> {
        let now = Date()
        let entry = PlannerEntry(date: now, style: configuration.style, data: configuration.data)
        let tomorrow = Calendar.autoupdatingCurrent.date(
            byAdding: .day,
            value: 1,
            to: Calendar.autoupdatingCurrent.startOfDay(for: now)
        ) ?? now.addingTimeInterval(86_400)
        return Timeline(entries: [entry], policy: .after(tomorrow))
    }
}

struct PlannerWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: "WorkdayGlow.Planner",
            intent: PlannerWidgetConfigurationIntent.self,
            provider: PlannerProvider()
        ) { entry in
            PlannerWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    EverydayTemplateBackground(template: entry.style.template)
                }
        }
        .configurationDisplayName("日程与专注")
        .description("把三件重要小事、一周节奏或专注目标放在桌面与锁屏。")
        .supportedFamilies([
            .systemSmall, .systemMedium, .systemLarge,
            .accessoryInline, .accessoryCircular, .accessoryRectangular
        ])
        .contentMarginsDisabled()
    }
}

private struct PlannerWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: PlannerEntry

    var body: some View {
        switch family {
        case .accessoryInline:
            Label(entry.data.focusTitle, systemImage: "scope")
        case .accessoryCircular:
            VStack(spacing: 0) {
                Text("\(entry.data.focusMinutes)")
                    .font(.title3.weight(.bold))
                Text("MIN")
                    .font(.system(size: 8, weight: .black))
            }
        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 2) {
                Label("下一件事", systemImage: "calendar.badge.clock")
                    .font(.caption2.weight(.bold))
                Text(entry.data.items.first?.title ?? entry.data.focusTitle)
                    .font(.headline)
                    .lineLimit(1)
                Text(entry.data.items.first?.time ?? "今天")
                    .font(.caption2)
            }
        default:
            EverydayTemplateArtwork(
                template: entry.style.template,
                size: artworkSize,
                date: entry.date,
                planner: entry.data
            )
        }
    }

    private var artworkSize: WidgetArtworkSize {
        switch family {
        case .systemSmall: .small
        case .systemLarge: .large
        default: .medium
        }
    }
}
