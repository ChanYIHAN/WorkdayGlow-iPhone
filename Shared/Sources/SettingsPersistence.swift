import Foundation

struct SettingsPersistence: Sendable {
    private static let storageKey = "workdayGlow.settings.v1"

    func load() -> WorkdaySettings {
        let defaults = UserDefaults.standard
        guard
            let data = defaults.data(forKey: Self.storageKey),
            var decoded = try? JSONDecoder().decode(WorkdaySettings.self, from: data)
        else {
            return .default
        }
        decoded.normalize()
        return decoded
    }

    func save(_ settings: WorkdaySettings) {
        var normalized = settings
        normalized.normalize()
        guard let data = try? JSONEncoder().encode(normalized) else { return }
        let defaults = UserDefaults.standard
        defaults.set(data, forKey: Self.storageKey)
    }
}
