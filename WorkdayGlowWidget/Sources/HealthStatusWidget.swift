import AppIntents
import SwiftUI
import WidgetKit

struct HealthStatusEntry: TimelineEntry {
    let date: Date
    let metrics: HealthMetrics
    let style: HealthWidgetStyle
}

struct HealthStatusProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> HealthStatusEntry {
        HealthStatusEntry(date: .now, metrics: .preview, style: .bento)
    }

    func snapshot(
        for configuration: HealthWidgetConfigurationIntent,
        in context: Context
    ) async -> HealthStatusEntry {
        let metrics: HealthMetrics
        if context.isPreview {
            metrics = .preview
        } else {
            metrics = await metrics(for: configuration)
        }

        return HealthStatusEntry(
            date: .now,
            metrics: metrics,
            style: configuration.style
        )
    }

    func timeline(
        for configuration: HealthWidgetConfigurationIntent,
        in context: Context
    ) async -> Timeline<HealthStatusEntry> {
        let now = Date()
        let metrics = await metrics(for: configuration, referenceDate: now)
        let entry = HealthStatusEntry(
            date: now,
            metrics: metrics,
            style: configuration.style
        )
        let refreshDate = Calendar.autoupdatingCurrent.date(
            byAdding: .minute,
            value: 30,
            to: now
        ) ?? now.addingTimeInterval(1_800)
        return Timeline(entries: [entry], policy: .after(refreshDate))
    }

    private func metrics(
        for configuration: HealthWidgetConfigurationIntent,
        referenceDate: Date = .now
    ) async -> HealthMetrics {
        switch configuration.dataSource {
        case .appleHealth:
            return await HealthDataService().fetchMetrics(referenceDate: referenceDate)
        case .manual:
            return configuration.manualMetrics
        }
    }
}

struct HealthStatusWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: "WorkdayGlow.HealthStatus",
            intent: HealthWidgetConfigurationIntent.self,
            provider: HealthStatusProvider()
        ) { entry in
            HealthStatusWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    LifestyleTemplateBackground(template: entry.style.template)
                }
        }
        .configurationDisplayName("健康状态")
        .description("自动读取最近心率、昨夜睡眠和血氧，也可切换为手动数据。")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

private struct HealthStatusWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: HealthStatusEntry

    var body: some View {
        LifestyleTemplateArtwork(
            template: entry.style.template,
            size: family == .systemSmall ? .small : .medium,
            date: entry.date,
            health: entry.metrics
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .widgetURL(URL(string: "workdayglow://health"))
    }
}
