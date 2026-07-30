import AppIntents
import Foundation

enum HealthWidgetStyle: String, AppEnum {
    case bento
    case sleep
    case oxygen

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "健康样式"
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .bento: "健康便当",
        .sleep: "睡眠丝带",
        .oxygen: "血氧脉冲"
    ]

    var template: WidgetTemplateKind {
        switch self {
        case .bento: .healthBento
        case .sleep: .sleepRibbon
        case .oxygen: .oxygenPulse
        }
    }
}

enum HealthDataSource: String, AppEnum {
    case appleHealth
    case manual

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "健康数据来源"
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .appleHealth: "自动读取 Apple 健康",
        .manual: "手动填写"
    ]
}

struct HealthWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "设置健康状态"
    static var description = IntentDescription("选择样式与数据来源。自动读取前需要在主 App 内完成 Apple 健康授权。")

    @Parameter(title: "样式", default: .bento)
    var style: HealthWidgetStyle

    @Parameter(title: "数据来源", default: .appleHealth)
    var dataSource: HealthDataSource

    @Parameter(title: "手动心率", default: 67, inclusiveRange: (30, 220))
    var manualHeartRate: Int

    @Parameter(title: "手动睡眠（小时）", default: 7.2, inclusiveRange: (0, 24))
    var manualSleepHours: Double

    @Parameter(title: "手动血氧（%）", default: 98, inclusiveRange: (50, 100))
    var manualOxygenPercentage: Int

    var manualMetrics: HealthMetrics {
        HealthMetrics(
            heartRate: Double(manualHeartRate),
            sleepHours: manualSleepHours,
            oxygenSaturation: Double(manualOxygenPercentage) / 100,
            updatedAt: .now
        )
    }
}

enum WeatherWidgetStyle: String, AppEnum {
    case canvas
    case hourly
    case minimal

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "天气样式"
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .canvas: "天气画布",
        .hourly: "逐时天气",
        .minimal: "极简天气"
    ]

    var template: WidgetTemplateKind {
        switch self {
        case .canvas: .weatherNow
        case .hourly: .weatherHourly
        case .minimal: .weatherMinimal
        }
    }
}

struct WeatherWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "设置天气预报"
    static var description = IntentDescription("输入城市名称并选择天气组件样式。")

    @Parameter(title: "城市", default: "上海")
    var city: String

    @Parameter(title: "样式", default: .canvas)
    var style: WeatherWidgetStyle
}

enum LoveWidgetStyle: String, AppEnum {
    case days
    case orbit

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "纪念日样式"
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .days: "恋爱天数",
        .orbit: "纪念日轨道"
    ]

    var template: WidgetTemplateKind {
        switch self {
        case .days: .loveDays
        case .orbit: .loveOrbit
        }
    }
}

struct LoveWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "设置恋爱纪念日"
    static var description = IntentDescription("设置开始日期、称呼和组件样式。")

    @Parameter(title: "标题", default: "我们在一起")
    var relationshipTitle: String

    @Parameter(title: "你的称呼", default: "你")
    var leftName: String

    @Parameter(title: "对方称呼", default: "我")
    var rightName: String

    @Parameter(title: "开始日期")
    var startDate: Date?

    @Parameter(title: "样式", default: .days)
    var style: LoveWidgetStyle

    var data: LoveWidgetData {
        LoveWidgetData(
            title: relationshipTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ? "我们在一起"
                : relationshipTitle,
            leftName: leftName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "你" : leftName,
            rightName: rightName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "我" : rightName,
            startDate: startDate
                ?? Calendar.autoupdatingCurrent.date(byAdding: .day, value: -100, to: .now)
                ?? .now
        )
    }
}

enum ClockZone: String, AppEnum {
    case shanghai
    case tokyo
    case london
    case newYork
    case paris
    case sydney

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "城市时区"
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .shanghai: "上海",
        .tokyo: "东京",
        .london: "伦敦",
        .newYork: "纽约",
        .paris: "巴黎",
        .sydney: "悉尼"
    ]

    var city: ClockCity {
        switch self {
        case .shanghai: ClockCity(id: rawValue, name: "上海", timeZoneIdentifier: "Asia/Shanghai")
        case .tokyo: ClockCity(id: rawValue, name: "东京", timeZoneIdentifier: "Asia/Tokyo")
        case .london: ClockCity(id: rawValue, name: "伦敦", timeZoneIdentifier: "Europe/London")
        case .newYork: ClockCity(id: rawValue, name: "纽约", timeZoneIdentifier: "America/New_York")
        case .paris: ClockCity(id: rawValue, name: "巴黎", timeZoneIdentifier: "Europe/Paris")
        case .sydney: ClockCity(id: rawValue, name: "悉尼", timeZoneIdentifier: "Australia/Sydney")
        }
    }
}

enum ClockWidgetStyle: String, AppEnum {
    case editorial
    case world
    case calendar

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "时间样式"
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .editorial: "编辑部时钟",
        .world: "世界时间",
        .calendar: "日历时钟"
    ]

    var template: WidgetTemplateKind {
        switch self {
        case .editorial: .editorialClock
        case .world: .worldClock
        case .calendar: .calendarClock
        }
    }
}

struct ClockWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "设置时间画报"
    static var description = IntentDescription("选择时钟样式和世界时间城市。")

    @Parameter(title: "样式", default: .editorial)
    var style: ClockWidgetStyle

    @Parameter(title: "城市一", default: .shanghai)
    var firstCity: ClockZone

    @Parameter(title: "城市二", default: .london)
    var secondCity: ClockZone

    @Parameter(title: "城市三", default: .newYork)
    var thirdCity: ClockZone

    var data: ClockWidgetData {
        ClockWidgetData(cities: [firstCity.city, secondCity.city, thirdCity.city])
    }
}
