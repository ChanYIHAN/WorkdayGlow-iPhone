import SwiftUI

struct WidgetPreviewView: View {
    @EnvironmentObject private var store: SettingsStore

    let template: WidgetTemplateKind
    let size: WidgetArtworkSize
    var cornerRadius: CGFloat = 28

    var body: some View {
        TimelineView(.periodic(from: .now, by: 60)) { timeline in
            let snapshot = WorkdayCalculator().snapshot(
                for: timeline.date,
                settings: store.settings
            )

            ZStack {
                WidgetTemplateBackground(template: template, settings: store.settings)

                WidgetTemplateArtwork(
                    template: template,
                    settings: store.settings,
                    snapshot: snapshot,
                    size: size
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
            }
            .shadow(color: Color("PlumInk").opacity(0.08), radius: 18, y: 10)
        }
        .aspectRatio(previewAspectRatio, contentMode: .fit)
    }

    private var previewAspectRatio: CGFloat {
        switch size {
        case .small: 1
        case .medium: 2.08
        case .large: 0.96
        }
    }
}

struct WidgetSizeChips: View {
    let sizes: [WidgetArtworkSize]
    var foreground: Color = .secondary

    var body: some View {
        HStack(spacing: 6) {
            ForEach(sizes) { size in
                Text(size.title)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(foreground)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(foreground.opacity(0.09), in: Capsule())
            }
        }
    }
}

struct TemplateSectionHeader: View {
    let title: String
    let subtitle: String?

    init(_ title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)

                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
    }
}

struct TemplateCategoryStrip: View {
    @Binding var selection: WidgetTemplateCategory

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(WidgetTemplateCategory.allCases) { category in
                    Button {
                        withAnimation(.snappy) {
                            selection = category
                        }
                    } label: {
                        Label(category.title, systemImage: category.symbolName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(
                                selection == category
                                    ? Color.white
                                    : Color("PlumInk").opacity(0.78)
                            )
                            .padding(.horizontal, 16)
                            .padding(.vertical, 11)
                            .background(
                                selection == category
                                    ? AnyShapeStyle(Color("PlumInk"))
                                    : AnyShapeStyle(Color.white.opacity(0.86)),
                                in: Capsule()
                            )
                            .overlay {
                                if selection != category {
                                    Capsule()
                                        .stroke(Color("PlumInk").opacity(0.08), lineWidth: 1)
                                }
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
        .contentMargins(.horizontal, 0, for: .scrollContent)
    }
}
