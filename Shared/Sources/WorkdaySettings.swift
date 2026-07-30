import Foundation

enum WorkdayTheme: String, Codable, CaseIterable, Identifiable, Sendable {
    case aurora
    case dusk
    case seaSalt

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .aurora: "极光"
        case .dusk: "暮色"
        case .seaSalt: "海盐"
        }
    }

    var symbolName: String {
        switch self {
        case .aurora: "sparkles"
        case .dusk: "sun.horizon.fill"
        case .seaSalt: "water.waves"
        }
    }
}

enum CurrencyCode: String, Codable, CaseIterable, Identifiable, Sendable {
    case cny = "CNY"
    case hkd = "HKD"
    case usd = "USD"
    case eur = "EUR"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .cny: "人民币"
        case .hkd: "港币"
        case .usd: "美元"
        case .eur: "欧元"
        }
    }

    var symbol: String {
        switch self {
        case .cny: "¥"
        case .hkd: "HK$"
        case .usd: "$"
        case .eur: "€"
        }
    }
}

struct WorkdaySettings: Codable, Equatable, Sendable {
    var startMinute: Int
    var endMinute: Int
    var monthlySalary: Double
    var paydayDay: Int
    var workdays: Set<Int>
    var currency: CurrencyCode
    var privacyMode: Bool
    var theme: WorkdayTheme

    static let `default` = WorkdaySettings(
        startMinute: 9 * 60,
        endMinute: 18 * 60,
        monthlySalary: 15_000,
        paydayDay: 10,
        workdays: [2, 3, 4, 5, 6],
        currency: .cny,
        privacyMode: false,
        theme: .aurora
    )

    static let preview = WorkdaySettings(
        startMinute: 9 * 60,
        endMinute: 20 * 60,
        monthlySalary: 22_000,
        paydayDay: 15,
        workdays: [1, 2, 3, 4, 5, 6, 7],
        currency: .cny,
        privacyMode: false,
        theme: .aurora
    )

    var safeEndMinute: Int {
        max(endMinute, startMinute + 30)
    }

    mutating func normalize() {
        startMinute = min(max(startMinute, 0), (23 * 60) + 29)
        endMinute = min(max(endMinute, startMinute + 30), (24 * 60) - 1)
        monthlySalary = max(monthlySalary, 0)
        paydayDay = min(max(paydayDay, 1), 28)
        if workdays.isEmpty {
            workdays = [2, 3, 4, 5, 6]
        }
    }
}
