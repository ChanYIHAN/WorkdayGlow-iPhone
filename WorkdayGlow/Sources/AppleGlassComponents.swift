import SwiftUI

enum AppLayout {
    static let gutter: CGFloat = 16
    static let sectionSpacing: CGFloat = 24
    static let cardRadius: CGFloat = 24
    static let compactRadius: CGFloat = 18
    static let minimumTouch: CGFloat = 44
}

struct AppCanvas: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)

            if !reduceTransparency {
                Circle()
                    .fill(Color("SkyGlow").opacity(colorScheme == .dark ? 0.12 : 0.18))
                    .frame(width: 320, height: 320)
                    .blur(radius: 80)
                    .offset(x: 150, y: -280)

                Circle()
                    .fill(Color("AuroraLavender").opacity(colorScheme == .dark ? 0.1 : 0.13))
                    .frame(width: 280, height: 280)
                    .blur(radius: 86)
                    .offset(x: -160, y: 240)
            }
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}

extension View {
    @ViewBuilder
    func appGlassSurface(
        cornerRadius: CGFloat = AppLayout.cardRadius,
        interactive: Bool = false
    ) -> some View {
        modifier(AccessibleGlassSurface(cornerRadius: cornerRadius, interactive: interactive))
    }

    func fallbackGlassSurface(cornerRadius: CGFloat) -> some View {
        self
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(LinearGradient(colors: [.white.opacity(0.65), .primary.opacity(0.06), .white.opacity(0.22)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.06), radius: 14, y: 6)
    }
}

private struct AccessibleGlassSurface: ViewModifier {
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    let cornerRadius: CGFloat
    let interactive: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        if reduceTransparency {
            content.background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: cornerRadius))
        } else {
        #if compiler(>=6.2)
        if #available(iOS 26.0, *) {
            let glass: Glass = interactive ? .regular.interactive() : .regular
            content.glassEffect(
                glass,
                in: .rect(cornerRadius: cornerRadius)
            )
        } else {
            content.fallbackGlassSurface(cornerRadius: cornerRadius)
        }
        #else
        content.fallbackGlassSurface(cornerRadius: cornerRadius)
        #endif
        }
    }
}

struct GlassTag: View {
    let title: String
    let symbol: String
    var tint: Color = .accentColor

    var body: some View {
        Label(title, systemImage: symbol)
            .font(.caption.weight(.semibold))
            .foregroundStyle(tint)
            .padding(.horizontal, 11)
            .frame(minHeight: AppLayout.minimumTouch)
            .contentShape(Capsule())
            .appGlassSurface(cornerRadius: 22)
    }
}

struct AppCardButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.84 : 1)
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.985 : 1)
            .animation(
                reduceMotion ? nil : .spring(response: 0.24, dampingFraction: 0.84),
                value: configuration.isPressed
            )
    }
}

struct SectionBadge: View {
    let text: String
    var tint: Color = Color("SeaGlass")

    var body: some View {
        Text(text.uppercased())
            .font(.caption2.weight(.black))
            .tracking(0.8)
            .foregroundStyle(tint)
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .background(tint.opacity(0.12), in: Capsule())
    }
}
