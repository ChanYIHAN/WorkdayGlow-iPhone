import Foundation

struct HealthMetrics: Sendable {
    let heartRate: Double?
    let sleepHours: Double?
    let oxygenSaturation: Double?
    let updatedAt: Date

    static let preview = HealthMetrics(
        heartRate: 67,
        sleepHours: 6.9,
        oxygenSaturation: 0.98,
        updatedAt: .now
    )
}

struct WeatherHour: Identifiable, Sendable {
    let id: String
    let label: String
    let temperature: Double
    let precipitationProbability: Int
    let weatherCode: Int
}

struct WeatherMetrics: Sendable {
    let isAvailable: Bool
    let locationName: String
    let temperature: Double
    let apparentTemperature: Double
    let humidity: Int
    let windSpeed: Double
    let weatherCode: Int
    let highTemperature: Double
    let lowTemperature: Double
    let sunrise: String
    let sunset: String
    let hourly: [WeatherHour]
    let updatedAt: Date

    static let preview = WeatherMetrics(
        isAvailable: true,
        locationName: "上海",
        temperature: 23,
        apparentTemperature: 24,
        humidity: 58,
        windSpeed: 12,
        weatherCode: 2,
        highTemperature: 30,
        lowTemperature: 19,
        sunrise: "05:07",
        sunset: "18:51",
        hourly: [
            WeatherHour(id: "16", label: "16时", temperature: 23, precipitationProbability: 10, weatherCode: 2),
            WeatherHour(id: "17", label: "17时", temperature: 23, precipitationProbability: 10, weatherCode: 2),
            WeatherHour(id: "18", label: "18时", temperature: 22, precipitationProbability: 35, weatherCode: 61),
            WeatherHour(id: "19", label: "19时", temperature: 21, precipitationProbability: 20, weatherCode: 2),
            WeatherHour(id: "20", label: "20时", temperature: 20, precipitationProbability: 10, weatherCode: 3),
            WeatherHour(id: "21", label: "21时", temperature: 19, precipitationProbability: 8, weatherCode: 3)
        ],
        updatedAt: .now
    )
}

struct LoveWidgetData: Sendable {
    let title: String
    let leftName: String
    let rightName: String
    let startDate: Date

    static let preview = LoveWidgetData(
        title: "我们在一起",
        leftName: "你",
        rightName: "我",
        startDate: Calendar.current.date(byAdding: .day, value: -520, to: .now) ?? .now
    )
}

struct ClockCity: Identifiable, Sendable {
    let id: String
    let name: String
    let timeZoneIdentifier: String
}

struct ClockWidgetData: Sendable {
    let cities: [ClockCity]

    static let preview = ClockWidgetData(
        cities: [
            ClockCity(id: "shanghai", name: "上海", timeZoneIdentifier: "Asia/Shanghai"),
            ClockCity(id: "london", name: "伦敦", timeZoneIdentifier: "Europe/London"),
            ClockCity(id: "new-york", name: "纽约", timeZoneIdentifier: "America/New_York")
        ]
    )
}

extension Int {
    var weatherDescription: String {
        switch self {
        case 0: "晴朗"
        case 1, 2: "局部多云"
        case 3: "阴天"
        case 45, 48: "有雾"
        case 51, 53, 55, 56, 57: "毛毛雨"
        case 61, 63, 65, 66, 67, 80, 81, 82: "有雨"
        case 71, 73, 75, 77, 85, 86: "有雪"
        case 95, 96, 99: "雷雨"
        default: "天气变化中"
        }
    }

    var weatherSymbolName: String {
        switch self {
        case 0: "sun.max.fill"
        case 1, 2: "cloud.sun.fill"
        case 3: "cloud.fill"
        case 45, 48: "cloud.fog.fill"
        case 51, 53, 55, 56, 57: "cloud.drizzle.fill"
        case 61, 63, 65, 66, 67, 80, 81, 82: "cloud.rain.fill"
        case 71, 73, 75, 77, 85, 86: "cloud.snow.fill"
        case 95, 96, 99: "cloud.bolt.rain.fill"
        default: "cloud.fill"
        }
    }
}
