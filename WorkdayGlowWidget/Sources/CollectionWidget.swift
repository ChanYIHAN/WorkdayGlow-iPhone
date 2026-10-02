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
    case packingList
    case flightBoard
    case jetlagClock
    case tripBudget
    case tripJournal
    case commutePlan
    case cityWishlist
    case weekendRoute
    case breathingGuide
    case eyeRest
    case stretchBreak
    case walkInvitation
    case moodJournal
    case sleepRitual
    case waterSchedule
    case digitalSunset
    case todayThree
    case deepWork
    case weeklyReflection
    case readingGoal
    case ideaInbox
    case deadlineRail
    case homeReset
    case skillJourney
    case dailyPoem
    case coffeeMoment
    case petCompanion
    case colorMood
    case soundtrackDay
    case memoryCapsule

    case departureTicket
    case eveningHorizon
    case holidayWindow
    case incomeLedger
    case paydayTicket
    case hourlyValue
    case seasonCompass
    case weekDots
    case monthRibbon
    case recoveryGarden
    case walkMap
    case sleepMoon
    case pulseRibbon
    case activityReceipt
    case skyWindow
    case windCompass
    case rainRibbon
    case weatherTicket
    case togetherConstellation
    case anniversaryTicket
    case littlePromise
    case lovePostmark
    case quietDial
    case timezoneTicket
    case dayArc
    case minuteTypography
    case shortcutRosette
    case connectionBento
    case batteryDial
    case noteReceipt
    case galleryWindow
    case contactSheet
    case memoryPostcard
    case photoEditorial
    case vinylSleeve
    case musicRibbon
    case playlistTicket
    case albumMosaic
    case budgetLedger
    case exchangeTicket
    case marketRibbon
    case savingsConstellation
    case dayItinerary
    case focusDial
    case habitConstellation
    case morningLetter
    case moonConstellation
    case teaReceipt

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
        .yearProgress: "年度进度",
        .packingList: "旅行清单",
        .flightBoard: "航班便签",
        .jetlagClock: "时差对照",
        .tripBudget: "旅途预算",
        .tripJournal: "旅途一页",
        .commutePlan: "通勤计划",
        .cityWishlist: "城市愿望",
        .weekendRoute: "周末路线",
        .breathingGuide: "呼吸节拍",
        .eyeRest: "护眼休息",
        .stretchBreak: "伸展间歇",
        .walkInvitation: "散步邀请",
        .moodJournal: "心情记录",
        .sleepRitual: "晚安仪式",
        .waterSchedule: "饮水时段",
        .digitalSunset: "数字日落",
        .todayThree: "今日三件事",
        .deepWork: "深度工作",
        .weeklyReflection: "周末复盘",
        .readingGoal: "阅读目标",
        .ideaInbox: "灵感收件箱",
        .deadlineRail: "截止时间轴",
        .homeReset: "居家整理",
        .skillJourney: "技能旅程",
        .dailyPoem: "诗意日签",
        .coffeeMoment: "咖啡时刻",
        .petCompanion: "桌面伙伴",
        .colorMood: "今日色彩",
        .soundtrackDay: "今日配乐",
        .memoryCapsule: "记忆胶囊",
        .departureTicket: "下班车票",
        .eveningHorizon: "傍晚地平线",
        .holidayWindow: "假日窗口",
        .incomeLedger: "收入账页",
        .paydayTicket: "发薪凭笺",
        .hourlyValue: "时薪刻度",
        .seasonCompass: "四季罗盘",
        .weekDots: "一周点阵",
        .monthRibbon: "月份丝带",
        .recoveryGarden: "恢复花园",
        .walkMap: "步行足迹",
        .sleepMoon: "月下睡眠",
        .pulseRibbon: "脉搏丝带",
        .activityReceipt: "活动小票",
        .skyWindow: "天空之窗",
        .windCompass: "风向罗盘",
        .rainRibbon: "雨量丝带",
        .weatherTicket: "出门天气签",
        .togetherConstellation: "相伴星图",
        .anniversaryTicket: "纪念日票根",
        .littlePromise: "小小约定",
        .lovePostmark: "心动邮戳",
        .quietDial: "静谧表盘",
        .timezoneTicket: "时区登机牌",
        .dayArc: "一天弧线",
        .minuteTypography: "分钟排印",
        .shortcutRosette: "快捷花盘",
        .connectionBento: "连接便当",
        .batteryDial: "电池刻度盘",
        .noteReceipt: "便签小票",
        .galleryWindow: "记忆窗格",
        .contactSheet: "相片索引",
        .memoryPostcard: "记忆明信片",
        .photoEditorial: "照片扉页",
        .vinylSleeve: "唱片封套",
        .musicRibbon: "旋律丝带",
        .playlistTicket: "歌单票签",
        .albumMosaic: "唱片拼贴",
        .budgetLedger: "预算账笺",
        .exchangeTicket: "换汇票据",
        .marketRibbon: "行情折线",
        .savingsConstellation: "储蓄星图",
        .dayItinerary: "今日行程签",
        .focusDial: "专注表盘",
        .habitConstellation: "习惯星群",
        .morningLetter: "晨间来信",
        .moonConstellation: "月夜星图",
        .teaReceipt: "茶歇小笺"
    ]

    var template: WidgetTemplateKind {
        WidgetTemplateKind(rawValue: rawValue) ?? .hydrationBloom
    }
}

struct CollectionWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "设置灵感合集"
    static var description = IntentDescription("从新增的 133 款原创设计中选择一款。")

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
        .description("健康、效率、生活、照片、音乐与行情等 133 款原创桌面设计。")
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
