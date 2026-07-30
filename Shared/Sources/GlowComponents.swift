import SwiftUI

enum HeroDensity: Equatable {
    case compact
    case regular
    case expanded

    var displaySize: CGFloat {
        switch self {
        case .compact: 32
        case .regular: 46
        case .expanded: 58
        }
    }

    var spacing: CGFloat {
        switch self {
        case .compact: 10
        case .regular: 14
        case .expanded: 18
        }
    }
}

struct WorkdayHeroCard: View {
    let settings: WorkdaySettings
    let snapshot: WorkdaySnapshot
    var density: HeroDensity = .expanded
    var showsStats = true

    private var palette: GlowPalette { settings.theme.palette }
    private let calculator = WorkdayCalculator()

    var body: some View {
        VStack(alignment: .leading, spacing: density.spacing) {
            header
            countdown
            progressSection

            if density != .compact {
                timeLabels
            }

            if showsStats {
                Divider()
                    .overlay(Color.white.opacity(0.12))
                stats
            }
        }
        .padding(density == .compact ? 14 : 20)
        .foregroundStyle(.white)
        .background(palette.cardGradient)
        .clipShape(RoundedRectangle(cornerRadius: density == .compact ? 24 : 30, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: density == .compact ? 24 : 30, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        }
        .shadow(color: palette.accentEnd.opacity(0.15), radius: 26, y: 16)
        .accessibilityElement(children: .contain)
    }

    private var header: some View {
        HStack {
            Text(snapshot.status == .working ? "距离下班" : "今日节奏")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.white.opacity(0.58))

            Spacer()

            Label(snapshot.status.title, systemImage: snapshot.status.symbolName)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(snapshot.status == .working ? palette.accentStart : .white.opacity(0.74))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.08), in: Capsule())
        }
    }

    private var countdown: some View {
        Group {
            if snapshot.status == .working, let endDate = snapshot.endDate {
                Text(
                    timerInterval: snapshot.date...endDate,
                    countsDown: true,
                    showsHours: true
                )
                .contentTransition(.numericText(countsDown: true))
                .accessibilityLabel("距离下班倒计时")
            } else {
                Text(snapshot.countdownFallback)
                    .contentTransition(.numericText())
            }
        }
        .font(.system(size: density.displaySize, weight: .medium, design: .rounded))
        .fontWidth(.expanded)
        .monospacedDigit()
        .minimumScaleFactor(0.62)
        .lineLimit(1)
    }

    private var progressSection: some View {
        VStack(alignment: .trailing, spacing: 7) {
            Text("\(snapshot.progressPercent)%")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.white.opacity(0.56))

            GlowProgressRail(progress: snapshot.progress, palette: palette)
        }
    }

    private var timeLabels: some View {
        HStack {
            Label(
                calculator.timeLabel(minute: settings.startMinute),
                systemImage: "building.2.fill"
            )
            .foregroundStyle(palette.accentStart)

            Spacer()

            Label(
                calculator.timeLabel(minute: settings.safeEndMinute),
                systemImage: "sofa.fill"
            )
            .foregroundStyle(palette.highlight)
        }
        .font(.subheadline)
        .fontWeight(.semibold)
        .monospacedDigit()
    }

    private var stats: some View {
        HStack(spacing: 12) {
            GlowStat(
                icon: "banknote.fill",
                value: settings.privacyMode
                    ? "••••"
                    : "\(settings.currency.symbol)\(snapshot.todayEarnings.formatted(.number.precision(.fractionLength(0...2))))",
                label: "今日预计",
                tint: palette.accentStart
            )

            Rectangle()
                .fill(Color.white.opacity(0.12))
                .frame(width: 1, height: 42)

            GlowStat(
                icon: "calendar.badge.clock",
                value: snapshot.daysUntilPayday == 0 ? "今天" : "\(snapshot.daysUntilPayday) 天",
                label: "距离发薪",
                tint: palette.highlight
            )
        }
    }
}

struct GlowProgressRail: View {
    let progress: Double
    let palette: GlowPalette

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let clamped = min(max(progress, 0), 1)

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.12))

                Capsule()
                    .fill(palette.accentGradient)
                    .frame(width: max(width * clamped, clamped > 0 ? 10 : 0))

                if clamped > 0, clamped < 1 {
                    Circle()
                        .fill(.white)
                        .frame(width: 7, height: 7)
                        .shadow(color: .white.opacity(0.8), radius: 5)
                        .offset(x: max((width - 7) * clamped, 0))
                }
            }
        }
        .frame(height: 12)
        .accessibilityLabel("今日工作进度")
        .accessibilityValue("\(Int((progress * 100).rounded()))%")
    }
}

struct GlowStat: View {
    let icon: String
    let value: String
    let label: String
    let tint: Color

    var body: some View {
        VStack(spacing: 3) {
            Label(value, systemImage: icon)
                .font(.headline)
                .fontWeight(.semibold)
                .monospacedDigit()
                .foregroundStyle(tint)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(label)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.42))
        }
        .frame(maxWidth: .infinity)
    }
}
