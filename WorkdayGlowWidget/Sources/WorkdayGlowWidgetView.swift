import SwiftUI
import WidgetKit

struct WorkdayGlowWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: WorkdayGlowEntry

    private let calculator = WorkdayCalculator()

    private var snapshot: WorkdaySnapshot {
        calculator.snapshot(for: entry.date, settings: entry.settings)
    }

    private var palette: GlowPalette {
        entry.settings.theme.palette
    }

    var body: some View {
        Group {
            switch family {
            case .systemSmall:
                smallLayout
            case .systemMedium:
                mediumLayout
            default:
                largeLayout
            }
        }
        .foregroundStyle(.white)
        .widgetURL(URL(string: "workdayglow://dashboard"))
        .accessibilityElement(children: .contain)
    }

    private var smallLayout: some View {
        VStack(alignment: .leading, spacing: 10) {
            statusHeader

            Spacer(minLength: 2)

            countdown(size: 33)

            Text(smallSubtitle)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.52))
                .lineLimit(1)

            GlowProgressRail(progress: snapshot.progress, palette: palette)

            HStack {
                Text("\(snapshot.progressPercent)%")
                Spacer()
                Label(
                    snapshot.daysUntilPayday == 0 ? "今天发薪" : "\(snapshot.daysUntilPayday)天发薪",
                    systemImage: "banknote.fill"
                )
            }
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundStyle(.white.opacity(0.62))
        }
        .padding(16)
    }

    private var mediumLayout: some View {
        VStack(alignment: .leading, spacing: 10) {
            statusHeader

            HStack(alignment: .firstTextBaseline) {
                countdown(size: 42)
                Spacer(minLength: 14)
                Text("\(snapshot.progressPercent)%")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.48))
                    .monospacedDigit()
            }

            GlowProgressRail(progress: snapshot.progress, palette: palette)

            HStack {
                Label(
                    calculator.timeLabel(minute: entry.settings.startMinute),
                    systemImage: "building.2.fill"
                )
                .foregroundStyle(palette.accentStart)

                Spacer()

                Label(
                    calculator.timeLabel(minute: entry.settings.safeEndMinute),
                    systemImage: "sofa.fill"
                )
                .foregroundStyle(palette.highlight)
            }
            .font(.caption)
            .fontWeight(.semibold)
            .monospacedDigit()

            HStack(spacing: 0) {
                compactStat(
                    icon: "banknote.fill",
                    value: entry.settings.privacyMode
                        ? "••••"
                        : "\(entry.settings.currency.symbol)\(snapshot.todayEarnings.formatted(.number.precision(.fractionLength(0...2))))",
                    label: "今日预计",
                    tint: palette.accentStart
                )

                Rectangle()
                    .fill(Color.white.opacity(0.12))
                    .frame(width: 1, height: 34)

                compactStat(
                    icon: "calendar.badge.clock",
                    value: snapshot.daysUntilPayday == 0 ? "今天" : "\(snapshot.daysUntilPayday) 天",
                    label: "距离发薪",
                    tint: palette.highlight
                )
            }
        }
        .padding(18)
    }

    private var largeLayout: some View {
        VStack(alignment: .leading, spacing: 16) {
            statusHeader

            VStack(alignment: .leading, spacing: 4) {
                Text(snapshot.status == .working ? "距离下班" : "今天")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.48))

                countdown(size: 56)
            }

            VStack(alignment: .trailing, spacing: 8) {
                Text("\(snapshot.progressPercent)%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white.opacity(0.52))

                GlowProgressRail(progress: snapshot.progress, palette: palette)
                    .frame(height: 14)
            }

            HStack {
                schedulePoint(
                    title: "上班",
                    time: calculator.timeLabel(minute: entry.settings.startMinute),
                    symbol: "building.2.fill",
                    tint: palette.accentStart
                )

                Spacer()

                schedulePoint(
                    title: "下班",
                    time: calculator.timeLabel(minute: entry.settings.safeEndMinute),
                    symbol: "sofa.fill",
                    tint: palette.highlight
                )
            }

            Spacer(minLength: 0)

            HStack(spacing: 12) {
                largeStatCard(
                    icon: "banknote.fill",
                    value: entry.settings.privacyMode
                        ? "••••"
                        : "\(entry.settings.currency.symbol)\(snapshot.todayEarnings.formatted(.number.precision(.fractionLength(0...2))))",
                    label: "今日预计",
                    tint: palette.accentStart
                )

                largeStatCard(
                    icon: "calendar.badge.clock",
                    value: snapshot.daysUntilPayday == 0 ? "今天" : "\(snapshot.daysUntilPayday) 天",
                    label: "距离发薪",
                    tint: palette.highlight
                )
            }
        }
        .padding(20)
    }

    private var statusHeader: some View {
        HStack {
            Label("奕刻", systemImage: entry.settings.theme.symbolName)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.white.opacity(0.58))

            Spacer()

            HStack(spacing: 5) {
                if snapshot.status == .working {
                    Circle()
                        .fill(palette.accentStart)
                        .frame(width: 6, height: 6)
                }
                Text(snapshot.status.title)
            }
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundStyle(snapshot.status == .working ? palette.accentStart : .white.opacity(0.62))
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .background(Color.white.opacity(0.08), in: Capsule())
        }
    }

    @ViewBuilder
    private func countdown(size: CGFloat) -> some View {
        if snapshot.status == .working, let endDate = snapshot.endDate {
            Text(
                timerInterval: entry.date...endDate,
                countsDown: true,
                showsHours: true
            )
            .contentTransition(.numericText(countsDown: true))
            .font(.system(size: size, weight: .medium, design: .rounded))
            .fontWidth(.expanded)
            .monospacedDigit()
            .minimumScaleFactor(0.6)
            .lineLimit(1)
            .accessibilityLabel("距离下班倒计时")
        } else {
            Text(snapshot.countdownFallback)
                .font(.system(size: size, weight: .medium, design: .rounded))
                .fontWidth(.expanded)
                .monospacedDigit()
                .minimumScaleFactor(0.6)
                .lineLimit(1)
        }
    }

    private var smallSubtitle: String {
        switch snapshot.status {
        case .working: "今天已经完成 \(snapshot.progressPercent)%"
        case .beforeWork: "保持自己的节奏"
        case .finished: "辛苦了，享受晚上"
        case .restDay: "今天不计算工作进度"
        }
    }

    private func compactStat(
        icon: String,
        value: String,
        label: String,
        tint: Color
    ) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(tint)

            VStack(alignment: .leading, spacing: 1) {
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.4))
            }

            Spacer(minLength: 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 10)
    }

    private func schedulePoint(
        title: String,
        time: String,
        symbol: String,
        tint: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(title, systemImage: symbol)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.46))
            Text(time)
                .font(.title3)
                .fontWeight(.semibold)
                .monospacedDigit()
                .foregroundStyle(tint)
        }
    }

    private func largeStatCard(
        icon: String,
        value: String,
        label: String,
        tint: Color
    ) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.4))
        }
        .foregroundStyle(tint)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct WorkdayGlowWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WorkdayGlowWidgetView(
                entry: WorkdayGlowEntry(date: previewDate, settings: .preview)
            )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("小号")

            WorkdayGlowWidgetView(
                entry: WorkdayGlowEntry(date: previewDate, settings: .preview)
            )
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("中号")

            WorkdayGlowWidgetView(
                entry: WorkdayGlowEntry(date: previewDate, settings: .preview)
            )
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .previewDisplayName("大号")
        }
    }

    private static var previewDate: Date {
        Calendar.current.startOfDay(for: .now)
            .addingTimeInterval((13 * 60 + 25) * 60)
    }
}
