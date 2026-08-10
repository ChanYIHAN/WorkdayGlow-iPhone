import AppIntents
import Foundation

enum WidgetWorkweek: String, AppEnum {
    case weekdays
    case everyDay
    case sixDays

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "工作日"

    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .weekdays: "周一至周五",
        .sixDays: "周一至周六",
        .everyDay: "每天"
    ]

    var weekdays: Set<Int> {
        switch self {
        case .weekdays: [2, 3, 4, 5, 6]
        case .sixDays: [2, 3, 4, 5, 6, 7]
        case .everyDay: [1, 2, 3, 4, 5, 6, 7]
        }
    }
}

extension WorkdayTheme: AppEnum {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "主题"

    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .aurora: "极光",
        .dusk: "暮色",
        .seaSalt: "海盐"
    ]
}

extension CurrencyCode: AppEnum {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "货币"

    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .cny: "人民币 ¥",
        .hkd: "港币 HK$",
        .usd: "美元 $",
        .eur: "欧元 €"
    ]
}

struct WorkdayConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "设置奕刻"
    static var description = IntentDescription("设置上下班时间、收入估算和组件主题。")

    @Parameter(title: "上班小时", default: 9)
    var startHour: Int

    @Parameter(title: "上班分钟", default: 0)
    var startMinute: Int

    @Parameter(title: "下班小时", default: 18)
    var endHour: Int

    @Parameter(title: "下班分钟", default: 0)
    var endMinute: Int

    @Parameter(title: "工作日", default: .weekdays)
    var workweek: WidgetWorkweek

    @Parameter(title: "月薪", default: 15_000)
    var monthlySalary: Double

    @Parameter(title: "每月发薪日", default: 10)
    var paydayDay: Int

    @Parameter(title: "货币", default: .cny)
    var currency: CurrencyCode

    @Parameter(title: "隐藏金额", default: false)
    var privacyMode: Bool

    @Parameter(title: "主题", default: .aurora)
    var theme: WorkdayTheme

    var settings: WorkdaySettings {
        var result = WorkdaySettings(
            startMinute: clampedHour(startHour) * 60 + clampedMinute(startMinute),
            endMinute: clampedHour(endHour) * 60 + clampedMinute(endMinute),
            monthlySalary: max(monthlySalary, 0),
            paydayDay: min(max(paydayDay, 1), 28),
            workdays: workweek.weekdays,
            currency: currency,
            privacyMode: privacyMode,
            theme: theme
        )
        result.normalize()
        return result
    }

    private func clampedHour(_ value: Int) -> Int {
        min(max(value, 0), 23)
    }

    private func clampedMinute(_ value: Int) -> Int {
        min(max(value, 0), 59)
    }
}
