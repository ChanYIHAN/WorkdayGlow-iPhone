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
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .hydrationBloom: "饮水花园",
        .stressBalance: "压力平衡",
        .standRhythm: "站立节奏",
        .mindfulMinutes: "正念分钟",
        .cycleWellness: "周期关怀",
        .heartZones: "心率区间",
        .sleepStages: "睡眠阶段",
        .airQuality: "空气质量",
        .rainRadar: "降雨雷达",
        .sunriseForecast: "晨昏预报",
        .weeklyWeather: "一周天气",
        .pollenCare: "花粉关怀",
        .couplePhoto: "双人相框",
        .loveLetters: "情书便签",
        .nextDate: "下次约会",
        .flipClock: "翻页时钟",
        .wordClock: "文字时钟",
        .focusClock: "专注时钟",
        .countdownEvent: "事件倒计时",
        .timezoneStrip: "时区长条",
        .batteryPanel: "电量面板",
        .storageMeter: "存储仪表",
        .qrLauncher: "二维码入口",
        .quickNotes: "快捷便签",
        .appLauncher: "应用启动台",
        .photoStack: "照片叠层",
        .memoryDate: "那年今日",
        .panoramicPhoto: "宽幅记忆",
        .scrapbook: "手帐拼贴",
        .albumShelf: "专辑陈列架",
        .lyricsCard: "歌词摘录",
        .nowPlayingMinimal: "极简在听",
        .playlistCover: "歌单封面",
        .cryptoPair: "数字资产双卡",
        .portfolioPulse: "组合脉搏",
        .marketHeatmap: "市场热力图",
        .budgetRing: "预算圆环",
        .savingsGoal: "储蓄目标",
        .expenseSnapshot: "支出快照",
        .habitTracker: "习惯打卡",
        .pomodoroBoard: "番茄专注",
        .taskPriority: "优先级看板",
        .meetingCountdown: "会议倒计时",
        .monthOverview: "月度总览",
        .studyPlan: "学习计划",
        .projectMilestone: "项目里程碑",
        .affirmation: "今日肯定",
        .gratitudePrompt: "感恩提问",
        .zodiacDay: "星座日签",
        .festivalCountdown: "节日倒计时",
        .vacationCountdown: "假期倒计时",
        .weekendCountdown: "周末倒计时",
        .salaryProgress: "本月收入进度",
        .overtimeEarnings: "加班收益估算",
        .yearProgress: "年度进度"
    ]

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
