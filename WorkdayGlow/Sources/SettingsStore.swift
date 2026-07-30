import Foundation
import SwiftUI

@MainActor
final class SettingsStore: ObservableObject {
    @Published var settings: WorkdaySettings {
        didSet {
            persistence.save(settings)
        }
    }

    private let persistence = SettingsPersistence()

    init() {
        settings = persistence.load()
    }

    func reset() {
        settings = .default
    }
}
