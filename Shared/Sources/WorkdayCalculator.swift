import Foundation

enum WorkdayStatus: String, Codable, Sendable {
    case beforeWork
    case working
    case finished
    case restDay

    var title: String {
        switch self {
        case .beforeWork: "未开始"
        case .working: "工作中"
        case .finished: "已下班"
        case .restDay: "休息日"
        }
    }

    var symbolName: String {
        switch self {
        case .beforeWork: "sunrise.fill"
        case .working: "circle.fill"
        case .finished: "sparkles"
        case .restDay: "cup.and.saucer.fill"
        }
    }
}

struct WorkdaySnapshot: Sendable {
    let date: Date
    let startDate: Date?
    let endDate: Date?
    let status: WorkdayStatus
    let progress: Double
    let todayEarnings: Double
    let dailyEarnings: Double
    let daysUntilPayday: Int
    let nextWorkDate: Date?

    var progressPercent: Int {
        Int((progress * 100).rounded())
    }

    var countdownFallback: String {
        switch status {
        case .working:
            guard let endDate else { return "—" }
            let remaining = max(Int(endDate.timeIntervalSince(date)), 0)
            let hours = remaining / 3_600
            let minutes = (remaining % 3_600) / 60
            return String(format: "%02d:%02d", hours, minutes)
        case .beforeWork:
            guard let startDate else { return "稍后开始" }
            return startDate.formatted(date: .omitted, time: .shortened)
        case .finished:
            return "今日完成"
        case .restDay:
            return "休息一下"
        }
    }
}

struct WorkdayCalculator: Sendable {
    private var calendar: Calendar

    init(calendar: Calendar = .autoupdatingCurrent) {
        self.calendar = calendar
    }

    func snapshot(for date: Date, settings: WorkdaySettings) -> WorkdaySnapshot {
        let startOfDay = calendar.startOfDay(for: date)
        let weekday = calendar.component(.weekday, from: date)
        let isWorkday = settings.workdays.contains(weekday)
        let startDate = calendar.date(
            byAdding: .minute,
            value: settings.startMinute,
            to: startOfDay
        )
        let endDate = calendar.date(
            byAdding: .minute,
            value: settings.safeEndMinute,
            to: startOfDay
        )

        let status: WorkdayStatus
        let progress: Double

        if !isWorkday {
            status = .restDay
            progress = 0
        } else if let startDate, date < startDate {
            status = .beforeWork
            progress = 0
        } else if let endDate, date >= endDate {
            status = .finished
            progress = 1
        } else {
            status = .working
            if let startDate, let endDate {
                let total = max(endDate.timeIntervalSince(startDate), 1)
                progress = min(max(date.timeIntervalSince(startDate) / total, 0), 1)
            } else {
                progress = 0
            }
        }

        // 21.75 is the commonly used average number of paid workdays per month.
        let dailyEarnings = settings.monthlySalary / 21.75
        let todayEarnings = isWorkday ? dailyEarnings * progress : 0

        return WorkdaySnapshot(
            date: date,
            startDate: startDate,
            endDate: endDate,
            status: status,
            progress: progress,
            todayEarnings: todayEarnings,
            dailyEarnings: dailyEarnings,
            daysUntilPayday: daysUntilPayday(from: date, day: settings.paydayDay),
            nextWorkDate: nextWorkDate(after: date, settings: settings)
        )
    }

    func timeLabel(minute: Int) -> String {
        let safeMinute = min(max(minute, 0), (24 * 60) - 1)
        return String(format: "%02d:%02d", safeMinute / 60, safeMinute % 60)
    }

    private func daysUntilPayday(from date: Date, day: Int) -> Int {
        let today = calendar.startOfDay(for: date)
        let clampedDay = min(max(day, 1), 28)
        var components = calendar.dateComponents([.year, .month], from: today)
        components.day = clampedDay

        guard var payday = calendar.date(from: components) else { return 0 }
        if payday < today {
            payday = calendar.date(byAdding: .month, value: 1, to: payday) ?? payday
        }
        return max(calendar.dateComponents([.day], from: today, to: payday).day ?? 0, 0)
    }

    private func nextWorkDate(after date: Date, settings: WorkdaySettings) -> Date? {
        let startToday = calendar.startOfDay(for: date)
        for offset in 0...8 {
            guard
                let candidateDay = calendar.date(byAdding: .day, value: offset, to: startToday),
                let candidateStart = calendar.date(
                    byAdding: .minute,
                    value: settings.startMinute,
                    to: candidateDay
                )
            else {
                continue
            }

            let weekday = calendar.component(.weekday, from: candidateDay)
            if settings.workdays.contains(weekday), candidateStart > date {
                return candidateStart
            }
        }
        return nil
    }
}
