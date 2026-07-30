import SwiftUI

struct GlowPalette {
    let accentStart: Color
    let accentEnd: Color
    let highlight: Color
    let canvas: Color
    let surface: Color
    let surfaceAlt: Color

    var accentGradient: LinearGradient {
        LinearGradient(
            colors: [accentStart, accentEnd],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [canvas, surfaceAlt],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var cardGradient: LinearGradient {
        LinearGradient(
            colors: [surface, surfaceAlt],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

extension WorkdayTheme {
    var palette: GlowPalette {
        switch self {
        case .aurora:
            GlowPalette(
                accentStart: Color("AuroraMint"),
                accentEnd: Color("AuroraLavender"),
                highlight: Color("AuroraCoral"),
                canvas: Color("GlowCanvas"),
                surface: Color("GlowSurface"),
                surfaceAlt: Color("GlowSurfaceAlt")
            )
        case .dusk:
            GlowPalette(
                accentStart: Color("AuroraCoral"),
                accentEnd: Color("AuroraLavender"),
                highlight: .orange,
                canvas: Color("GlowCanvas"),
                surface: Color("GlowSurface"),
                surfaceAlt: Color("GlowSurfaceAlt")
            )
        case .seaSalt:
            GlowPalette(
                accentStart: Color("AuroraMint"),
                accentEnd: .cyan,
                highlight: .blue,
                canvas: Color("GlowCanvas"),
                surface: Color("GlowSurface"),
                surfaceAlt: Color("GlowSurfaceAlt")
            )
        }
    }
}
