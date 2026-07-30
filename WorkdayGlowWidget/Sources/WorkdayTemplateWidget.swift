import SwiftUI
import WidgetKit

struct WorkdayTemplateWidget: Widget {
    let template: WidgetTemplateKind

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: "WorkdayGlow.\(template.rawValue)",
            intent: WorkdayConfigurationIntent.self,
            provider: WorkdayGlowProvider()
        ) { entry in
            WorkdayTemplateWidgetView(template: template, entry: entry)
                .containerBackground(for: .widget) {
                    WidgetTemplateBackground(template: template, settings: entry.settings)
                }
        }
        .configurationDisplayName(LocalizedStringKey(template.title))
        .description(LocalizedStringKey(template.subtitle))
        .supportedFamilies(supportedFamilies)
        .contentMarginsDisabled()
    }

    private var supportedFamilies: [WidgetFamily] {
        template.supportedSizes.map { size in
            switch size {
            case .small: .systemSmall
            case .medium: .systemMedium
            case .large: .systemLarge
            }
        }
    }
}

private struct WorkdayTemplateWidgetView: View {
    @Environment(\.widgetFamily) private var family

    let template: WidgetTemplateKind
    let entry: WorkdayGlowEntry

    var body: some View {
        WidgetTemplateArtwork(
            template: template,
            settings: entry.settings,
            snapshot: WorkdayCalculator().snapshot(
                for: entry.date,
                settings: entry.settings
            ),
            size: artworkSize
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .widgetURL(URL(string: "workdayglow://dashboard"))
    }

    private var artworkSize: WidgetArtworkSize {
        switch family {
        case .systemSmall: .small
        case .systemLarge: .large
        default: .medium
        }
    }
}
