import AppIntents
import Foundation
import SwiftUI
import WidgetKit

struct WeatherForecastEntry: TimelineEntry {
    let date: Date
    let weather: WeatherMetrics
    let style: WeatherWidgetStyle
}

struct WeatherForecastProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> WeatherForecastEntry {
        WeatherForecastEntry(date: .now, weather: .preview, style: .canvas)
    }

    func snapshot(
        for configuration: WeatherWidgetConfigurationIntent,
        in context: Context
    ) async -> WeatherForecastEntry {
        let weather: WeatherMetrics
        if context.isPreview {
            weather = .preview
        } else {
            weather = await WeatherDataService().fetch(city: configuration.city)
        }

        return WeatherForecastEntry(
            date: .now,
            weather: weather,
            style: configuration.style
        )
    }

    func timeline(
        for configuration: WeatherWidgetConfigurationIntent,
        in context: Context
    ) async -> Timeline<WeatherForecastEntry> {
        let now = Date()
        let weather = await WeatherDataService().fetch(city: configuration.city)
        let entry = WeatherForecastEntry(
            date: now,
            weather: weather,
            style: configuration.style
        )
        let refreshDate = Calendar.autoupdatingCurrent.date(
            byAdding: .hour,
            value: 1,
            to: now
        ) ?? now.addingTimeInterval(3_600)
        return Timeline(entries: [entry], policy: .after(refreshDate))
    }
}

struct WeatherForecastWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: "WorkdayGlow.WeatherForecast",
            intent: WeatherWidgetConfigurationIntent.self,
            provider: WeatherForecastProvider()
        ) { entry in
            WeatherForecastWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    LifestyleTemplateBackground(template: entry.style.template)
                }
        }
        .configurationDisplayName("天气预报")
        .description("通过城市名称显示当前天气和逐时预报。数据来源：Open-Meteo。")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

private struct WeatherForecastWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: WeatherForecastEntry

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            LifestyleTemplateArtwork(
                template: entry.style.template,
                size: family == .systemSmall ? .small : .medium,
                date: entry.date,
                weather: entry.weather
            )

            Text("Open-Meteo")
                .font(.system(size: 7))
                .foregroundStyle(
                    entry.style == .hourly
                        ? Color.white.opacity(0.28)
                        : Color("PlumInk").opacity(0.28)
                )
                .padding(7)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .widgetURL(URL(string: "workdayglow://weather"))
    }
}

private final class WeatherDataService {
    func fetch(city rawCity: String) async -> WeatherMetrics {
        let city = normalizedCity(rawCity)

        do {
            let location = try await geocode(city: city)
            return try await forecast(for: location)
        } catch {
            return fallbackWeather(city: city)
        }
    }

    private func geocode(city: String) async throws -> GeocodedLocation {
        var components = URLComponents(
            string: "https://geocoding-api.open-meteo.com/v1/search"
        )
        components?.queryItems = [
            URLQueryItem(name: "name", value: city),
            URLQueryItem(name: "count", value: "1"),
            URLQueryItem(name: "language", value: "zh"),
            URLQueryItem(name: "format", value: "json")
        ]

        guard let url = components?.url else {
            throw WeatherServiceError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        try validate(response: response)
        let decoded = try JSONDecoder().decode(GeocodingResponse.self, from: data)
        guard let result = decoded.results?.first else {
            throw WeatherServiceError.locationNotFound
        }
        return GeocodedLocation(
            name: result.name,
            latitude: result.latitude,
            longitude: result.longitude
        )
    }

    private func forecast(for location: GeocodedLocation) async throws -> WeatherMetrics {
        var components = URLComponents(string: "https://api.open-meteo.com/v1/forecast")
        components?.queryItems = [
            URLQueryItem(name: "latitude", value: String(location.latitude)),
            URLQueryItem(name: "longitude", value: String(location.longitude)),
            URLQueryItem(
                name: "current",
                value: "temperature_2m,apparent_temperature,relative_humidity_2m,weather_code,wind_speed_10m"
            ),
            URLQueryItem(
                name: "hourly",
                value: "temperature_2m,precipitation_probability,weather_code"
            ),
            URLQueryItem(
                name: "daily",
                value: "weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset"
            ),
            URLQueryItem(name: "timezone", value: "auto"),
            URLQueryItem(name: "forecast_days", value: "2")
        ]

        guard let url = components?.url else {
            throw WeatherServiceError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        try validate(response: response)
        let decoded = try JSONDecoder().decode(ForecastResponse.self, from: data)

        let requestedStartIndex = decoded.hourly.time.firstIndex {
            $0 >= decoded.current.time
        } ?? 0
        let availableCount = [
            decoded.hourly.time.count,
            decoded.hourly.temperature.count,
            decoded.hourly.precipitationProbability.count,
            decoded.hourly.weatherCode.count
        ].min() ?? 0
        let startIndex = min(requestedStartIndex, availableCount)
        let endIndex = min(startIndex + 6, availableCount)
        let hours = (startIndex..<endIndex).map { index in
            WeatherHour(
                id: decoded.hourly.time[index],
                label: hourLabel(decoded.hourly.time[index]),
                temperature: decoded.hourly.temperature[index],
                precipitationProbability: decoded.hourly.precipitationProbability[index],
                weatherCode: decoded.hourly.weatherCode[index]
            )
        }

        return WeatherMetrics(
            isAvailable: true,
            locationName: location.name,
            temperature: decoded.current.temperature,
            apparentTemperature: decoded.current.apparentTemperature,
            humidity: decoded.current.humidity,
            windSpeed: decoded.current.windSpeed,
            weatherCode: decoded.current.weatherCode,
            highTemperature: decoded.daily.highTemperature.first ?? decoded.current.temperature,
            lowTemperature: decoded.daily.lowTemperature.first ?? decoded.current.temperature,
            sunrise: timeOnly(decoded.daily.sunrise.first),
            sunset: timeOnly(decoded.daily.sunset.first),
            hourly: hours,
            updatedAt: .now
        )
    }

    private func normalizedCity(_ city: String) -> String {
        let result = city.trimmingCharacters(in: .whitespacesAndNewlines)
        return result.count >= 2 ? result : "上海"
    }

    private func validate(response: URLResponse) throws {
        guard
            let httpResponse = response as? HTTPURLResponse,
            200..<300 ~= httpResponse.statusCode
        else {
            throw WeatherServiceError.invalidResponse
        }
    }

    private func hourLabel(_ value: String) -> String {
        guard let time = value.split(separator: "T").last else { return value }
        return "\(time.prefix(2))时"
    }

    private func timeOnly(_ value: String?) -> String {
        guard let value, let time = value.split(separator: "T").last else { return "—" }
        return String(time.prefix(5))
    }

    private func fallbackWeather(city: String) -> WeatherMetrics {
        return WeatherMetrics(
            isAvailable: false,
            locationName: city,
            temperature: 0,
            apparentTemperature: 0,
            humidity: 0,
            windSpeed: 0,
            weatherCode: 3,
            highTemperature: 0,
            lowTemperature: 0,
            sunrise: "—",
            sunset: "—",
            hourly: [],
            updatedAt: .now
        )
    }
}

private struct GeocodedLocation {
    let name: String
    let latitude: Double
    let longitude: Double
}

private struct GeocodingResponse: Decodable {
    let results: [GeocodingResult]?
}

private struct GeocodingResult: Decodable {
    let name: String
    let latitude: Double
    let longitude: Double
}

private struct ForecastResponse: Decodable {
    let current: ForecastCurrent
    let hourly: ForecastHourly
    let daily: ForecastDaily
}

private struct ForecastCurrent: Decodable {
    let time: String
    let temperature: Double
    let apparentTemperature: Double
    let humidity: Int
    let weatherCode: Int
    let windSpeed: Double

    enum CodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case apparentTemperature = "apparent_temperature"
        case humidity = "relative_humidity_2m"
        case weatherCode = "weather_code"
        case windSpeed = "wind_speed_10m"
    }
}

private struct ForecastHourly: Decodable {
    let time: [String]
    let temperature: [Double]
    let precipitationProbability: [Int]
    let weatherCode: [Int]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case precipitationProbability = "precipitation_probability"
        case weatherCode = "weather_code"
    }
}

private struct ForecastDaily: Decodable {
    let highTemperature: [Double]
    let lowTemperature: [Double]
    let sunrise: [String]
    let sunset: [String]

    enum CodingKeys: String, CodingKey {
        case highTemperature = "temperature_2m_max"
        case lowTemperature = "temperature_2m_min"
        case sunrise
        case sunset
    }
}

private enum WeatherServiceError: Error {
    case invalidURL
    case invalidResponse
    case locationNotFound
}
