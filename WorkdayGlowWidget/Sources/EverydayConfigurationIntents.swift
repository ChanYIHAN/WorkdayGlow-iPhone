import AppIntents
import Foundation

enum PlannerWidgetStyle: String, AppEnum {
    case agenda
    case week
    case focus

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "日程样式"
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .agenda: "玻璃日程",
        .week: "一周计划",
        .focus: "专注此刻"
    ]

    var template: WidgetTemplateKind {
        switch self {
        case .agenda: .glassAgenda
        case .week: .weekPlanner
        case .focus: .focusNow
        }
    }
}

struct PlannerWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "设置日程与专注"
    static var description = IntentDescription("填写三件重要小事，或设置今天的专注目标。")

    @Parameter(title: "样式", default: .agenda)
    var style: PlannerWidgetStyle

    @Parameter(title: "今日标题", default: "今天，慢一点也没关系")
    var headline: String

    @Parameter(title: "事项一时间", default: "09:30")
    var firstTime: String

    @Parameter(title: "事项一", default: "完成本周方案")
    var firstTitle: String

    @Parameter(title: "事项二时间", default: "14:00")
    var secondTime: String

    @Parameter(title: "事项二", default: "散步与晒太阳")
    var secondTitle: String

    @Parameter(title: "事项三时间", default: "19:30")
    var thirdTime: String

    @Parameter(title: "事项三", default: "晚间阅读")
    var thirdTitle: String

    @Parameter(title: "专注分钟", default: 45, inclusiveRange: (5, 180))
    var focusMinutes: Int

    @Parameter(title: "专注目标", default: "专注完成最重要的一件事")
    var focusTitle: String

    var data: PlannerWidgetData {
        PlannerWidgetData(
            headline: normalized(headline, fallback: "今天，慢一点也没关系"),
            items: [
                PlannerItem(
                    id: "one",
                    time: normalized(firstTime, fallback: "09:30"),
                    title: normalized(firstTitle, fallback: "完成本周方案"),
                    isHighlighted: true
                ),
                PlannerItem(
                    id: "two",
                    time: normalized(secondTime, fallback: "14:00"),
                    title: normalized(secondTitle, fallback: "散步与晒太阳"),
                    isHighlighted: false
                ),
                PlannerItem(
                    id: "three",
                    time: normalized(thirdTime, fallback: "19:30"),
                    title: normalized(thirdTitle, fallback: "晚间阅读"),
                    isHighlighted: false
                )
            ],
            focusMinutes: focusMinutes,
            focusTitle: normalized(focusTitle, fallback: "专注完成最重要的一件事")
        )
    }

    private func normalized(_ value: String, fallback: String) -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? fallback : trimmed
    }
}

enum DailyWidgetStyle: String, AppEnum {
    case quote
    case moon
    case sun

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "每日样式"
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .quote: "每日一句",
        .moon: "月相观测",
        .sun: "日光节律"
    ]

    var template: WidgetTemplateKind {
        switch self {
        case .quote: .dailyQuote
        case .moon: .moonPhase
        case .sun: .solarRhythm
        }
    }
}

struct DailyWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "设置每日灵感"
    static var description = IntentDescription("每日语录与月相在本地计算；日出日落时间可手动调整。")

    @Parameter(title: "样式", default: .quote)
    var style: DailyWidgetStyle

    @Parameter(title: "日出时间", default: "06:12")
    var sunrise: String

    @Parameter(title: "日落时间", default: "18:42")
    var sunset: String

    func data(at date: Date) -> DailyWidgetData {
        DailyWidgetData.make(
            date: date,
            sunrise: normalizedTime(sunrise, fallback: "06:12"),
            sunset: normalizedTime(sunset, fallback: "18:42")
        )
    }

    private func normalizedTime(_ value: String, fallback: String) -> String {
        let parts = value.split(separator: ":")
        guard
            parts.count == 2,
            let hour = Int(parts[0]),
            let minute = Int(parts[1]),
            (0...23).contains(hour),
            (0...59).contains(minute)
        else {
            return fallback
        }
        return String(format: "%02d:%02d", hour, minute)
    }
}
