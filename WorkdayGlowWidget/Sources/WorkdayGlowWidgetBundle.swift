import SwiftUI
import WidgetKit

@main
struct WorkdayGlowWidgetBundle: WidgetBundle {
    var body: some Widget {
        WorkdayGlowWidget()
        WorkdayTemplateWidget(template: .minimalCountdown)
        WorkdayTemplateWidget(template: .incomeBento)
        WorkdayTemplateWidget(template: .weekRhythm)
        WorkdayTemplateWidget(template: .progressOrbit)
        WorkdayTemplateWidget(template: .paydayCalendar)
        WorkdayTemplateWidget(template: .afterworkPlan)
        HealthStatusWidget()
        WeatherForecastWidget()
        LoveAnniversaryWidget()
        TimePosterWidget()
    }
}
