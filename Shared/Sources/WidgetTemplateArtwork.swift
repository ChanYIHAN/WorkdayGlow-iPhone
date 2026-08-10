import SwiftUI

struct WidgetTemplateBackground: View {
    let template: WidgetTemplateKind
    let settings: WorkdaySettings

    var body: some View {
        switch template {
        case .workdayRail:
            settings.theme.palette.backgroundGradient
        case .minimalCountdown:
            LinearGradient(
                colors: [Color("SoftCream"), Color("ButterGlow").opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .incomeBento:
            LinearGradient(
                colors: [Color("PlumInk"), Color("GlowSurfaceAlt")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .weekRhythm:
            LinearGradient(
                colors: [Color("SoftCream"), Color("RoseGlow").opacity(0.13)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .progressOrbit:
            LinearGradient(
                colors: [Color("GlowCanvas"), Color("PlumInk")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .paydayCalendar:
            LinearGradient(
                colors: [Color("GalleryCanvas"), Color("AuroraLavender").opacity(0.28)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .afterworkPlan:
            LinearGradient(
                colors: [Color("RoseGlow"), Color("ButterGlow")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .healthBento, .sleepRibbon, .oxygenPulse,
             .stepOrbit, .activeBento, .recoveryArc,
             .weatherNow, .weatherHourly, .weatherMinimal,
             .loveDays, .loveOrbit,
             .editorialClock, .worldClock, .calendarClock:
            LifestyleTemplateBackground(template: template)
        case .controlDeck, .shortcutStack, .focusConsole,
             .photoPolaroid, .photoFilmstrip, .photoMosaic,
             .musicVinyl, .musicGlass, .musicWave:
            CreativeTemplateBackground(template: template)
        case .currencyMinimal, .currencyMatrix, .travelConverter,
             .goldSpot, .goldTrend, .metalsDuo,
             .stockQuote, .watchlistBento, .dualMarket:
            FinanceTemplateBackground(template: template)
        case .glassAgenda, .weekPlanner, .focusNow,
             .dailyQuote, .moonPhase, .solarRhythm:
            EverydayTemplateBackground(template: template)
        }
    }
}

struct WidgetTemplateArtwork: View {
    let template: WidgetTemplateKind
    let settings: WorkdaySettings
    let snapshot: WorkdaySnapshot
    let size: WidgetArtworkSize

    private let calculator = WorkdayCalculator()

    var body: some View {
        Group {
            switch template {
            case .workdayRail:
                WorkdayHeroCard(
                    settings: settings,
                    snapshot: snapshot,
                    density: size == .small ? .compact : .regular,
                    showsStats: size != .small
                )
            case .minimalCountdown:
                minimalCountdown
            case .incomeBento:
                incomeBento
            case .weekRhythm:
                weekRhythm
            case .progressOrbit:
                progressOrbit
            case .paydayCalendar:
                paydayCalendar
            case .afterworkPlan:
                afterworkPlan
            case .healthBento, .sleepRibbon, .oxygenPulse,
                 .stepOrbit, .activeBento, .recoveryArc,
                 .weatherNow, .weatherHourly, .weatherMinimal,
                 .loveDays, .loveOrbit,
                 .editorialClock, .worldClock, .calendarClock:
                LifestyleTemplateArtwork(
                    template: template,
                    size: size,
                    date: snapshot.date
                )
            case .controlDeck, .shortcutStack, .focusConsole,
                 .photoPolaroid, .photoFilmstrip, .photoMosaic,
                 .musicVinyl, .musicGlass, .musicWave:
                CreativeTemplateArtwork(template: template, size: size)
            case .currencyMinimal, .currencyMatrix, .travelConverter,
                 .goldSpot, .goldTrend, .metalsDuo,
                 .stockQuote, .watchlistBento, .dualMarket:
                FinanceTemplateArtwork(template: template, size: size)
            case .glassAgenda, .weekPlanner, .focusNow,
                 .dailyQuote, .moonPhase, .solarRhythm:
                EverydayTemplateArtwork(
                    template: template,
                    size: size,
                    date: snapshot.date
                )
            }
        }
        .accessibilityElement(children: .contain)
    }

    private var minimalCountdown: some View {
        VStack(alignment: .leading, spacing: size == .small ? 8 : 10) {
            HStack {
                Label("下班倒计时", systemImage: "hourglass.bottomhalf.filled")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("PlumInk").opacity(0.62))

                Spacer()

                Circle()
                    .fill(snapshot.status == .working ? Color("SeaGlass") : Color("RoseGlow"))
                    .frame(width: 8, height: 8)
            }

            Spacer(minLength: 0)

            if size == .small {
                countdownText(fontSize: 38, color: Color("PlumInk"))

                Text(snapshot.status == .working ? "再坚持一小会儿" : snapshot.status.title)
                    .font(.caption2)
                    .foregroundStyle(Color("PlumInk").opacity(0.46))
            } else {
                HStack(alignment: .bottom, spacing: 16) {
                    VStack(alignment: .leading, spacing: 2) {
                        countdownText(fontSize: 46, color: Color("PlumInk"))
                        Text("今天已完成 \(snapshot.progressPercent)%")
                            .font(.caption)
                            .foregroundStyle(Color("PlumInk").opacity(0.5))
                    }

                    Spacer(minLength: 0)

                    Text(calculator.timeLabel(minute: settings.safeEndMinute))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .monospacedDigit()
                        .foregroundStyle(Color("PlumInk"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.66), in: Capsule())
                }
            }

            ProgressView(value: snapshot.progress)
                .tint(Color("RoseGlow"))
        }
        .padding(size == .small ? 16 : 18)
        .foregroundStyle(Color("PlumInk"))
    }

    private var incomeBento: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: "briefcase.fill")
                    .font(.title3)
                    .foregroundStyle(Color("SeaGlass"))

                Spacer(minLength: 0)

                Text(money(snapshot.todayEarnings))
                    .font(size == .large ? .largeTitle : .title2)
                    .fontWeight(.bold)
                    .monospacedDigit()
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)

                Text("今日已赚")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.45))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(14)
            .background(Color("SeaGlass").opacity(0.14), in: RoundedRectangle(cornerRadius: 18, style: .continuous))

            VStack(spacing: 10) {
                bentoStat(
                    icon: "sun.max.fill",
                    label: "日薪",
                    value: money(snapshot.dailyEarnings),
                    tint: Color("ButterGlow")
                )

                bentoStat(
                    icon: "calendar.badge.clock",
                    label: "发薪",
                    value: snapshot.daysUntilPayday == 0 ? "今天" : "\(snapshot.daysUntilPayday) 天",
                    tint: Color("RoseGlow")
                )

                if size == .large {
                    bentoStat(
                        icon: "chart.line.uptrend.xyaxis",
                        label: "进度",
                        value: "\(snapshot.progressPercent)%",
                        tint: Color("SkyGlow")
                    )
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(size == .large ? 18 : 14)
        .foregroundStyle(.white)
    }

    private var weekRhythm: some View {
        VStack(alignment: .leading, spacing: size == .large ? 18 : 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("本周节奏")
                        .font(.headline)
                    Text("把每一天过成自己的拍子")
                        .font(.caption2)
                        .foregroundStyle(Color("PlumInk").opacity(0.46))
                }

                Spacer()

                Image(systemName: "waveform.path.ecg")
                    .font(.title3)
                    .foregroundStyle(Color("RoseGlow"))
            }

            HStack(spacing: 6) {
                ForEach(weekItems) { item in
                    VStack(spacing: size == .large ? 10 : 6) {
                        Text(item.label)
                            .font(.caption2)
                            .fontWeight(.semibold)

                        ZStack {
                            Capsule()
                                .fill(item.isToday ? Color("PlumInk") : Color.white.opacity(0.7))

                            if item.isWorkday {
                                Circle()
                                    .fill(item.isToday ? Color("ButterGlow") : Color("SeaGlass"))
                                    .frame(width: 7, height: 7)
                            } else {
                                Image(systemName: "cup.and.saucer.fill")
                                    .font(.system(size: 8))
                                    .foregroundStyle(item.isToday ? Color("ButterGlow") : Color("RoseGlow"))
                            }
                        }
                        .frame(height: size == .large ? 62 : 42)
                    }
                    .foregroundStyle(item.isToday ? Color("PlumInk") : Color("PlumInk").opacity(0.58))
                    .frame(maxWidth: .infinity)
                }
            }

            if size == .large {
                HStack(spacing: 8) {
                    Label("\(snapshot.progressPercent)% 今日进度", systemImage: "chart.bar.fill")
                    Spacer()
                    Label("\(snapshot.daysUntilPayday) 天后发薪", systemImage: "banknote.fill")
                }
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Color("PlumInk").opacity(0.62))
            }
        }
        .padding(size == .large ? 20 : 16)
        .foregroundStyle(Color("PlumInk"))
    }

    private var progressOrbit: some View {
        Group {
            if size == .small {
                VStack(spacing: 10) {
                    orbitRing(diameter: 92)
                    Text(snapshot.status == .working ? "向下班靠近中" : snapshot.status.title)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white.opacity(0.58))
                }
            } else {
                HStack(spacing: 18) {
                    orbitRing(diameter: 112)

                    VStack(alignment: .leading, spacing: 10) {
                        Label("进度轨道", systemImage: "circle.hexagongrid.fill")
                            .font(.headline)

                        orbitLegend(
                            color: Color("SeaGlass"),
                            title: "今日工作",
                            value: "\(snapshot.progressPercent)%"
                        )

                        orbitLegend(
                            color: Color("AuroraLavender"),
                            title: "本月时间",
                            value: "\(monthProgressPercent)%"
                        )
                    }

                    Spacer(minLength: 0)
                }
            }
        }
        .padding(size == .small ? 14 : 18)
        .foregroundStyle(.white)
    }

    private var paydayCalendar: some View {
        VStack(alignment: .leading, spacing: size == .large ? 12 : 7) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 1) {
                    Text(snapshot.date.formatted(.dateTime.month(.wide)))
                        .font(.headline)
                    Text("发薪日 · \(settings.paydayDay) 日")
                        .font(.caption2)
                        .foregroundStyle(Color("PlumInk").opacity(0.48))
                }

                Spacer()

                Label(
                    snapshot.daysUntilPayday == 0 ? "今天到账" : "还有 \(snapshot.daysUntilPayday) 天",
                    systemImage: "banknote.fill"
                )
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Color("PlumInk"))
                .padding(.horizontal, 9)
                .padding(.vertical, 5)
                .background(Color("ButterGlow"), in: Capsule())
            }

            LazyVGrid(columns: calendarColumns, spacing: size == .large ? 8 : 4) {
                ForEach(Array(calendarCells.enumerated()), id: \.offset) { _, day in
                    if let day {
                        Text("\(day)")
                            .font(size == .large ? .caption : .caption2)
                            .fontWeight(day == settings.paydayDay ? .bold : .regular)
                            .foregroundStyle(day == settings.paydayDay ? Color("PlumInk") : Color("PlumInk").opacity(0.58))
                            .frame(maxWidth: .infinity)
                            .frame(height: size == .large ? 25 : 17)
                            .background(
                                day == settings.paydayDay ? Color("ButterGlow") : Color.clear,
                                in: Circle()
                            )
                    } else {
                        Color.clear
                            .frame(height: size == .large ? 25 : 17)
                    }
                }
            }
        }
        .padding(size == .large ? 20 : 14)
        .foregroundStyle(Color("PlumInk"))
    }

    private var afterworkPlan: some View {
        Group {
            if size == .small {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "sun.horizon.fill")
                        Spacer()
                        Text(calculator.timeLabel(minute: settings.safeEndMinute))
                            .font(.caption)
                            .fontWeight(.bold)
                            .monospacedDigit()
                    }

                    Spacer()

                    Text("今晚\n不加班")
                        .font(.title2)
                        .fontWeight(.black)
                        .fontDesign(.rounded)
                        .lineSpacing(-2)

                    Text("把时间还给自己")
                        .font(.caption2)
                        .foregroundStyle(Color("PlumInk").opacity(0.55))
                }
            } else {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.38))
                        Image(systemName: "sofa.fill")
                            .font(.system(size: 38))
                    }
                    .frame(width: 92, height: 92)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("TONIGHT")
                            .font(.caption2)
                            .fontWeight(.black)
                            .tracking(2)
                            .foregroundStyle(Color("PlumInk").opacity(0.5))

                        Text(snapshot.status == .finished ? "现在就去生活" : "今晚准时下班")
                            .font(.title2)
                            .fontWeight(.black)
                            .fontDesign(.rounded)

                        Text("散步、看电影，或者什么都不做。")
                            .font(.caption)
                            .foregroundStyle(Color("PlumInk").opacity(0.58))
                            .lineLimit(2)
                    }

                    Spacer(minLength: 0)
                }
            }
        }
        .padding(size == .small ? 16 : 18)
        .foregroundStyle(Color("PlumInk"))
    }

    @ViewBuilder
    private func countdownText(fontSize: CGFloat, color: Color) -> some View {
        if snapshot.status == .working, let endDate = snapshot.endDate {
            Text(timerInterval: snapshot.date...endDate, countsDown: true, showsHours: true)
                .contentTransition(.numericText(countsDown: true))
                .accessibilityLabel("距离下班倒计时")
                .modifier(CountdownTypography(size: fontSize, color: color))
        } else {
            Text(snapshot.countdownFallback)
                .modifier(CountdownTypography(size: fontSize, color: color))
        }
    }

    private func bentoStat(icon: String, label: String, value: String, tint: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(tint)
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 1) {
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.4))
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func orbitRing(diameter: CGFloat) -> some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.08), lineWidth: 12)

            Circle()
                .trim(from: 0, to: max(snapshot.progress, 0.025))
                .stroke(
                    Color("SeaGlass"),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            Circle()
                .inset(by: 18)
                .stroke(Color.white.opacity(0.06), lineWidth: 8)

            Circle()
                .inset(by: 18)
                .trim(from: 0, to: max(monthProgress, 0.025))
                .stroke(
                    Color("AuroraLavender"),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            VStack(spacing: 0) {
                Text("\(snapshot.progressPercent)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .monospacedDigit()
                Text("%")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.46))
            }
        }
        .frame(width: diameter, height: diameter)
    }

    private func orbitLegend(color: Color, title: String, value: String) -> some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(title)
                .foregroundStyle(.white.opacity(0.54))
            Spacer()
            Text(value)
                .fontWeight(.bold)
                .monospacedDigit()
        }
        .font(.caption)
    }

    private func money(_ value: Double) -> String {
        if settings.privacyMode {
            return "••••"
        }
        return "\(settings.currency.symbol)\(value.formatted(.number.precision(.fractionLength(0...2))))"
    }

    private var monthProgress: Double {
        let calendar = Calendar.autoupdatingCurrent
        let day = calendar.component(.day, from: snapshot.date)
        let total = calendar.range(of: .day, in: .month, for: snapshot.date)?.count ?? 30
        return min(max(Double(day) / Double(total), 0), 1)
    }

    private var monthProgressPercent: Int {
        Int((monthProgress * 100).rounded())
    }

    private var weekItems: [WeekRhythmItem] {
        let calendar = Calendar.autoupdatingCurrent
        let interval = calendar.dateInterval(of: .weekOfYear, for: snapshot.date)
        let weekStart = interval?.start ?? calendar.startOfDay(for: snapshot.date)
        let labels = ["日", "一", "二", "三", "四", "五", "六"]

        return (0..<7).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: weekStart) else {
                return nil
            }
            let weekday = calendar.component(.weekday, from: date)
            return WeekRhythmItem(
                id: offset,
                label: labels[weekday - 1],
                isToday: calendar.isDate(date, inSameDayAs: snapshot.date),
                isWorkday: settings.workdays.contains(weekday)
            )
        }
    }

    private var calendarCells: [Int?] {
        let calendar = Calendar.autoupdatingCurrent
        let components = calendar.dateComponents([.year, .month], from: snapshot.date)
        guard
            let firstDay = calendar.date(from: components),
            let dayRange = calendar.range(of: .day, in: .month, for: firstDay)
        else {
            return []
        }

        let leadingEmptyCount = calendar.component(.weekday, from: firstDay) - 1
        let leadingDays: [Int?] = Array(repeating: nil, count: leadingEmptyCount)
        let numberedDays: [Int?] = dayRange.map { Optional($0) }
        return leadingDays + numberedDays
    }

    private var calendarColumns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 3), count: 7)
    }
}

private struct CountdownTypography: ViewModifier {
    let size: CGFloat
    let color: Color

    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: .black, design: .rounded))
            .fontWidth(.condensed)
            .monospacedDigit()
            .minimumScaleFactor(0.55)
            .lineLimit(1)
            .foregroundStyle(color)
    }
}

private struct WeekRhythmItem: Identifiable {
    let id: Int
    let label: String
    let isToday: Bool
    let isWorkday: Bool
}
