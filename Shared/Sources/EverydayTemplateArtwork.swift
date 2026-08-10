import SwiftUI

struct EverydayTemplateBackground: View {
    let template: WidgetTemplateKind

    var body: some View {
        switch template {
        case .glassAgenda:
            LinearGradient(
                colors: [Color("SkyGlow").opacity(0.82), Color("AuroraLavender").opacity(0.76)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .weekPlanner:
            LinearGradient(
                colors: [Color("SoftCream"), Color("ButterGlow").opacity(0.32)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .focusNow:
            LinearGradient(
                colors: [Color("PlumInk"), Color("GlowSurfaceAlt")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .dailyQuote:
            LinearGradient(
                colors: [Color("SoftCream"), Color("RoseGlow").opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .moonPhase:
            LinearGradient(
                colors: [Color("GlowSurfaceAlt"), Color("PlumInk")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .solarRhythm:
            LinearGradient(
                colors: [Color("ButterGlow"), Color("AuroraCoral").opacity(0.78), Color("AuroraLavender").opacity(0.66)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            Color("GalleryCanvas")
        }
    }
}

struct EverydayTemplateArtwork: View {
    let template: WidgetTemplateKind
    let size: WidgetArtworkSize
    let date: Date
    let planner: PlannerWidgetData
    let daily: DailyWidgetData

    init(
        template: WidgetTemplateKind,
        size: WidgetArtworkSize,
        date: Date = .now,
        planner: PlannerWidgetData = .preview,
        daily: DailyWidgetData = .preview
    ) {
        self.template = template
        self.size = size
        self.date = date
        self.planner = planner
        self.daily = daily
    }

    var body: some View {
        Group {
            switch template {
            case .glassAgenda: glassAgenda
            case .weekPlanner: weekPlanner
            case .focusNow: focusNow
            case .dailyQuote: dailyQuote
            case .moonPhase: moonPhase
            case .solarRhythm: solarRhythm
            default: EmptyView()
            }
        }
        .accessibilityElement(children: .contain)
    }

    private var glassAgenda: some View {
        VStack(alignment: .leading, spacing: size == .large ? 15 : 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(date.formatted(.dateTime.month(.abbreviated).day().weekday(.wide)))
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color("PlumInk").opacity(0.52))
                    Text(planner.headline)
                        .font(.headline)
                        .foregroundStyle(Color("PlumInk"))
                }
                Spacer()
                Image(systemName: "calendar.badge.clock")
                    .font(.title2)
                    .foregroundStyle(Color("PlumInk"))
            }

            ForEach(planner.items.prefix(size == .large ? 3 : 2)) { item in
                HStack(spacing: 10) {
                    Text(item.time)
                        .font(.caption.monospacedDigit().weight(.semibold))
                        .frame(width: 42, alignment: .leading)
                    Capsule()
                        .fill(item.isHighlighted ? Color("AuroraCoral") : Color.white.opacity(0.5))
                        .frame(width: 4, height: 28)
                    Text(item.title)
                        .font(.subheadline.weight(item.isHighlighted ? .bold : .medium))
                        .lineLimit(1)
                    Spacer()
                }
                .padding(.horizontal, 11)
                .frame(minHeight: 42)
                .background(Color.white.opacity(0.32), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
        .padding(size == .large ? 20 : 17)
    }

    private var weekPlanner: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack {
                Text("一周计划")
                    .font(.headline)
                Spacer()
                Text("WEEK \(weekOfYear)")
                    .font(.caption2.weight(.black))
                    .tracking(1.1)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 6) {
                ForEach(weekDays) { day in
                    VStack(spacing: 5) {
                        Text(day.weekday)
                            .font(.caption2)
                        Text("\(day.day)")
                            .font(.caption.weight(.bold))
                            .frame(width: 29, height: 29)
                            .background(day.isToday ? Color("PlumInk") : Color.white.opacity(0.55), in: Circle())
                            .foregroundStyle(day.isToday ? Color.white : Color("PlumInk"))
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            if size == .large {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(planner.items) { item in
                        Label("\(item.time)  \(item.title)", systemImage: item.isHighlighted ? "circle.inset.filled" : "circle")
                            .font(.subheadline)
                    }
                }
                .padding(14)
                .background(Color.white.opacity(0.52), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
        }
        .padding(size == .large ? 20 : 17)
        .foregroundStyle(Color("PlumInk"))
    }

    private var focusNow: some View {
        VStack(alignment: .leading, spacing: 11) {
            HStack {
                Label("专注此刻", systemImage: "scope")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color("SeaGlass"))
                Spacer()
                Text("勿扰")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.white.opacity(0.48))
            }

            Text("\(planner.focusMinutes)")
                .font(.system(size: size == .small ? 50 : 58, weight: .medium, design: .rounded))
                .fontWidth(.expanded)
                .monospacedDigit()
                .overlay(alignment: .bottomTrailing) {
                    Text("MIN")
                        .font(.caption2.weight(.black))
                        .tracking(1)
                        .offset(x: 30, y: -7)
                }

            Text(planner.focusTitle)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.6))
                .lineLimit(size == .small ? 2 : 1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(size == .small ? 15 : 18)
        .foregroundStyle(.white)
    }

    private var dailyQuote: some View {
        VStack(alignment: .leading, spacing: size == .small ? 9 : 13) {
            HStack {
                Image(systemName: "quote.opening")
                    .font(.title2)
                    .foregroundStyle(Color("AuroraCoral"))
                Spacer()
                Text(date.formatted(.dateTime.month().day()))
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)
            }

            Text(daily.quote)
                .font(size == .small ? .headline : .title3)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .fixedSize(horizontal: false, vertical: true)

            Text("— \(daily.quoteSource)")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(size == .small ? 15 : 18)
        .foregroundStyle(Color("PlumInk"))
    }

    private var moonPhase: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.08))
                Image(systemName: daily.moonSymbol)
                    .font(.system(size: size == .small ? 54 : 68, weight: .light))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color("ButterGlow"))
            }
            .frame(width: size == .small ? 92 : 112, height: size == .small ? 92 : 112)

            if size != .small {
                VStack(alignment: .leading, spacing: 7) {
                    Text("今晚月相")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white.opacity(0.45))
                    Text(daily.moonName)
                        .font(.title2.weight(.bold))
                    Text(daily.daysUntilFullMoon == 0 ? "今夜接近满月" : "距满月约 \(daily.daysUntilFullMoon) 天")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.54))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: size == .small ? .center : .leading)
        .padding(size == .small ? 14 : 18)
        .foregroundStyle(.white)
    }

    private var solarRhythm: some View {
        VStack(alignment: .leading, spacing: size == .small ? 10 : 14) {
            HStack {
                Label("日光节律", systemImage: "sun.horizon.fill")
                    .font(.caption.weight(.bold))
                Spacer()
                Text(date, style: .time)
                    .font(.caption.monospacedDigit().weight(.bold))
            }

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.3))
                    .frame(height: 9)
                GeometryReader { proxy in
                    Circle()
                        .fill(.white)
                        .frame(width: 18, height: 18)
                        .shadow(color: .white.opacity(0.7), radius: 9)
                        .offset(x: max((proxy.size.width - 18) * daily.solarProgress, 0), y: -4.5)
                }
                .frame(height: 9)
            }

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("日出")
                    Text(daily.sunrise)
                        .fontWeight(.bold)
                        .monospacedDigit()
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("日落")
                    Text(daily.sunset)
                        .fontWeight(.bold)
                        .monospacedDigit()
                }
            }
            .font(.caption2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(size == .small ? 15 : 18)
        .foregroundStyle(Color("PlumInk"))
    }

    private var weekOfYear: Int {
        Calendar.autoupdatingCurrent.component(.weekOfYear, from: date)
    }

    private var weekDays: [WeekDay] {
        let calendar = Calendar.autoupdatingCurrent
        let start = calendar.dateInterval(of: .weekOfYear, for: date)?.start ?? date
        return (0..<7).compactMap { offset in
            guard let item = calendar.date(byAdding: .day, value: offset, to: start) else { return nil }
            return WeekDay(
                id: offset,
                weekday: item.formatted(.dateTime.weekday(.narrow)),
                day: calendar.component(.day, from: item),
                isToday: calendar.isDate(item, inSameDayAs: date)
            )
        }
    }
}

private struct WeekDay: Identifiable {
    let id: Int
    let weekday: String
    let day: Int
    let isToday: Bool
}
