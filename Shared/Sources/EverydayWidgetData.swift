import Foundation

struct PlannerItem: Identifiable, Sendable {
    let id: String
    let time: String
    let title: String
    let isHighlighted: Bool
}

struct PlannerWidgetData: Sendable {
    let headline: String
    let items: [PlannerItem]
    let focusMinutes: Int
    let focusTitle: String

    static let preview = PlannerWidgetData(
        headline: "今天，慢一点也没关系",
        items: [
            PlannerItem(id: "one", time: "09:30", title: "完成本周方案", isHighlighted: true),
            PlannerItem(id: "two", time: "14:00", title: "散步与晒太阳", isHighlighted: false),
            PlannerItem(id: "three", time: "19:30", title: "晚间阅读", isHighlighted: false)
        ],
        focusMinutes: 45,
        focusTitle: "专注完成最重要的一件事"
    )
}

struct DailyWidgetData: Sendable {
    let quote: String
    let quoteSource: String
    let moonPhase: Double
    let moonName: String
    let moonSymbol: String
    let daysUntilFullMoon: Int
    let sunrise: String
    let sunset: String
    let solarProgress: Double

    static func make(
        date: Date,
        sunrise: String = "06:12",
        sunset: String = "18:42"
    ) -> DailyWidgetData {
        let quotes: [(String, String)] = [
            ("把今天过好，明天会自己出现。", "每日小记"),
            ("允许生活有留白，也是一种前进。", "每日小记"),
            ("不必追赶所有光，找到自己的节奏。", "每日小记"),
            ("认真休息，是为了继续热爱。", "每日小记"),
            ("普通的一天，也值得被好好收藏。", "每日小记"),
            ("慢慢来，清醒、知足，也勇敢。", "每日小记"),
            ("把注意力还给此刻正在发生的事。", "每日小记")
        ]
        let day = Calendar.autoupdatingCurrent.ordinality(of: .day, in: .year, for: date) ?? 1
        let quote = quotes[(day - 1) % quotes.count]
        let phase = moonPhaseFraction(for: date)

        return DailyWidgetData(
            quote: quote.0,
            quoteSource: quote.1,
            moonPhase: phase,
            moonName: moonDescription(phase),
            moonSymbol: moonSymbolName(phase),
            daysUntilFullMoon: daysToFullMoon(phase),
            sunrise: sunrise,
            sunset: sunset,
            solarProgress: daylightProgress(date: date, sunrise: sunrise, sunset: sunset)
        )
    }

    static let preview = make(date: .now)

    private static func moonPhaseFraction(for date: Date) -> Double {
        let reference = Date(timeIntervalSince1970: 947_182_440) // 2000-01-06 18:14 UTC
        let synodicMonth = 29.530_588_67
        let days = date.timeIntervalSince(reference) / 86_400
        let cycles = days / synodicMonth
        return cycles - floor(cycles)
    }

    private static func moonDescription(_ phase: Double) -> String {
        switch phase {
        case 0..<0.03, 0.97...1: "新月"
        case 0.03..<0.22: "蛾眉月"
        case 0.22..<0.28: "上弦月"
        case 0.28..<0.47: "盈凸月"
        case 0.47..<0.53: "满月"
        case 0.53..<0.72: "亏凸月"
        case 0.72..<0.78: "下弦月"
        default: "残月"
        }
    }

    private static func moonSymbolName(_ phase: Double) -> String {
        switch phase {
        case 0..<0.03, 0.97...1: "moonphase.new.moon"
        case 0.03..<0.22: "moonphase.waxing.crescent"
        case 0.22..<0.28: "moonphase.first.quarter"
        case 0.28..<0.47: "moonphase.waxing.gibbous"
        case 0.47..<0.53: "moonphase.full.moon"
        case 0.53..<0.72: "moonphase.waning.gibbous"
        case 0.72..<0.78: "moonphase.last.quarter"
        default: "moonphase.waning.crescent"
        }
    }

    private static func daysToFullMoon(_ phase: Double) -> Int {
        let distance = phase <= 0.5 ? 0.5 - phase : 1.5 - phase
        return max(Int((distance * 29.530_588_67).rounded()), 0)
    }

    private static func daylightProgress(date: Date, sunrise: String, sunset: String) -> Double {
        let calendar = Calendar.autoupdatingCurrent
        let startOfDay = calendar.startOfDay(for: date)

        func time(_ value: String, fallbackHour: Int) -> Date {
            let parts = value.split(separator: ":").compactMap { Int($0) }
            let hour = parts.first ?? fallbackHour
            let minute = parts.count > 1 ? parts[1] : 0
            return calendar.date(byAdding: .minute, value: hour * 60 + minute, to: startOfDay) ?? startOfDay
        }

        let start = time(sunrise, fallbackHour: 6)
        let end = time(sunset, fallbackHour: 18)
        guard end > start else { return 0 }
        return min(max(date.timeIntervalSince(start) / end.timeIntervalSince(start), 0), 1)
    }
}
