import AppIntents
import SwiftUI
import WidgetKit

enum CollectionWidgetStyle: String, CaseIterable, AppEnum {
    case hydrationBloom
    case stressBalance
    case standRhythm
    case mindfulMinutes
    case cycleWellness
    case heartZones
    case sleepStages
    case airQuality
    case rainRadar
    case sunriseForecast
    case weeklyWeather
    case pollenCare
    case couplePhoto
    case loveLetters
    case nextDate
    case flipClock
    case wordClock
    case focusClock
    case countdownEvent
    case timezoneStrip
    case batteryPanel
    case storageMeter
    case qrLauncher
    case quickNotes
    case appLauncher
    case photoStack
    case memoryDate
    case panoramicPhoto
    case scrapbook
    case albumShelf
    case lyricsCard
    case nowPlayingMinimal
    case playlistCover
    case cryptoPair
    case portfolioPulse
    case marketHeatmap
    case budgetRing
    case savingsGoal
    case expenseSnapshot
    case habitTracker
    case pomodoroBoard
    case taskPriority
    case meetingCountdown
    case monthOverview
    case studyPlan
    case projectMilestone
    case affirmation
    case gratitudePrompt
    case zodiacDay
    case festivalCountdown
    case vacationCountdown
    case weekendCountdown
    case salaryProgress
    case overtimeEarnings
    case yearProgress

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "灵感合集样式"
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] {
        Dictionary(uniqueKeysWithValues: allCases.map { style in
            (
                style,
                DisplayRepresentation(
                    title: LocalizedStringResource(stringLiteral: style.template.title)
                )
            )
        })
    }

    var template: WidgetTemplateKind {
        WidgetTemplateKind(rawValue: rawValue) ?? .hydrationBloom
    }
}

struct CollectionWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "设置灵感合集"
    static var description = IntentDescription("从新增的 55 款原创设计中选择一款。")

    @Parameter(title: "样式", default: .hydrationBloom)
    var style: CollectionWidgetStyle
}

struct CollectionEntry: TimelineEntry {
    let date: Date
    let style: CollectionWidgetStyle
}

struct CollectionProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> CollectionEntry {
        CollectionEntry(date: .now, style: .hydrationBloom)
    }

    func snapshot(
        for configuration: CollectionWidgetConfigurationIntent,
        in context: Context
    ) async -> CollectionEntry {
        CollectionEntry(date: .now, style: configuration.style)
    }

    func timeline(
        for configuration: CollectionWidgetConfigurationIntent,
        in context: Context
    ) async -> Timeline<CollectionEntry> {
        let now = Date()
        let next = Calendar.autoupdatingCurrent.date(byAdding: .minute, value: 30, to: now)
            ?? now.addingTimeInterval(1_800)
        return Timeline(
            entries: [CollectionEntry(date: now, style: configuration.style)],
            policy: .after(next)
        )
    }
}

struct CollectionWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: "WorkdayGlow.Collection",
            intent: CollectionWidgetConfigurationIntent.self,
            provider: CollectionProvider()
        ) { entry in
            CollectionWidgetView(entry: entry)
            .containerBackground(for: .widget) {
                ExpansionTemplateBackground(template: entry.style.template)
            }
            .widgetURL(URL(string: "workdayglow://widgets"))
        }
        .configurationDisplayName("灵感合集")
        .description("健康、效率、生活、照片、音乐与行情等 55 款原创桌面设计。")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .contentMarginsDisabled()
    }
}

private struct CollectionWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: CollectionEntry

    var body: some View {
        ExpansionTemplateArtwork(
            template: entry.style.template,
            size: artworkSize
        )
    }

    private var artworkSize: WidgetArtworkSize {
        switch family {
        case .systemSmall: .small
        case .systemLarge: .large
        default: .medium
        }
    }
}
