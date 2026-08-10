import SwiftUI

struct LifestyleTemplateBackground: View {
    let template: WidgetTemplateKind

    var body: some View {
        switch template {
        case .healthBento:
            LinearGradient(
                colors: [Color("SoftCream"), Color("GalleryCanvas")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .sleepRibbon:
            LinearGradient(
                colors: [Color("GlowCanvas"), Color("AuroraLavender").opacity(0.58)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .oxygenPulse:
            LinearGradient(
                colors: [Color("PlumInk"), Color("SkyGlow").opacity(0.72)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .stepOrbit:
            LinearGradient(
                colors: [Color("SoftCream"), Color("SeaGlass").opacity(0.34)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .activeBento:
            LinearGradient(
                colors: [Color("PlumInk"), Color("GlowSurfaceAlt")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .recoveryArc:
            LinearGradient(
                colors: [Color("AuroraLavender").opacity(0.72), Color("SkyGlow").opacity(0.72)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .weatherNow:
            LinearGradient(
                colors: [Color("SkyGlow"), Color("SeaGlass")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .weatherHourly:
            LinearGradient(
                colors: [Color("PlumInk"), Color("GlowSurfaceAlt")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .weatherMinimal:
            LinearGradient(
                colors: [Color("GalleryCanvas"), Color("SkyGlow").opacity(0.22)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .loveDays:
            LinearGradient(
                colors: [Color("SoftCream"), Color("RoseGlow").opacity(0.42)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .loveOrbit:
            LinearGradient(
                colors: [Color("PlumInk"), Color("RoseGlow").opacity(0.65)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .editorialClock:
            LinearGradient(
                colors: [Color("SoftCream"), Color("ButterGlow").opacity(0.16)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .worldClock:
            LinearGradient(
                colors: [Color("GlowCanvas"), Color("PlumInk")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .calendarClock:
            LinearGradient(
                colors: [Color("GalleryCanvas"), Color("AuroraLavender").opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            Color("GalleryCanvas")
        }
    }
}

struct LifestyleTemplateArtwork: View {
    let template: WidgetTemplateKind
    let size: WidgetArtworkSize
    let date: Date
    let health: HealthMetrics
    let weather: WeatherMetrics
    let love: LoveWidgetData
    let clock: ClockWidgetData

    init(
        template: WidgetTemplateKind,
        size: WidgetArtworkSize,
        date: Date = .now,
        health: HealthMetrics = .preview,
        weather: WeatherMetrics = .preview,
        love: LoveWidgetData = .preview,
        clock: ClockWidgetData = .preview
    ) {
        self.template = template
        self.size = size
        self.date = date
        self.health = health
        self.weather = weather
        self.love = love
        self.clock = clock
    }

    var body: some View {
        Group {
            switch template {
            case .healthBento:
                healthBento
            case .sleepRibbon:
                sleepRibbon
            case .oxygenPulse:
                oxygenPulse
            case .stepOrbit:
                stepOrbit
            case .activeBento:
                activeBento
            case .recoveryArc:
                recoveryArc
            case .weatherNow:
                weather.isAvailable
                    ? (size == .small ? AnyView(weatherMinimal) : AnyView(weatherNow))
                    : AnyView(weatherUnavailable)
            case .weatherHourly:
                weather.isAvailable
                    ? (size == .small ? AnyView(weatherMinimal) : AnyView(weatherHourly))
                    : AnyView(weatherUnavailable)
            case .weatherMinimal:
                weather.isAvailable ? AnyView(weatherMinimal) : AnyView(weatherUnavailable)
            case .loveDays:
                size == .small ? AnyView(loveDaysCompact) : AnyView(loveDays)
            case .loveOrbit:
                loveOrbit
            case .editorialClock:
                editorialClock
            case .worldClock:
                size == .small ? AnyView(worldClockCompact) : AnyView(worldClock)
            case .calendarClock:
                calendarClock
            default:
                EmptyView()
            }
        }
        .accessibilityElement(children: .contain)
    }

    private var healthBento: some View {
        Group {
            if size == .small {
                VStack(alignment: .leading, spacing: 10) {
                    Label("今日健康", systemImage: "heart.fill")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("AuroraCoral"))

                    healthMetric(
                        symbol: "waveform.path.ecg",
                        value: heartRateText,
                        label: "心率",
                        tint: Color("AuroraCoral")
                    )

                    HStack {
                        Text("睡眠 \(sleepText)")
                        Spacer()
                        Text("血氧 \(oxygenText)")
                    }
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("PlumInk").opacity(0.6))
                }
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("早上好")
                                .font(.headline)
                            Text("身体正在告诉你的三件事")
                                .font(.caption2)
                                .foregroundStyle(Color("PlumInk").opacity(0.46))
                        }

                        Spacer()

                        Image(systemName: "heart.text.square.fill")
                            .font(.title2)
                            .foregroundStyle(Color("AuroraCoral"))
                    }

                    HStack(spacing: 8) {
                        healthMetric(
                            symbol: "waveform.path.ecg",
                            value: heartRateText,
                            label: "最近心率",
                            tint: Color("AuroraCoral")
                        )
                        healthMetric(
                            symbol: "bed.double.fill",
                            value: sleepText,
                            label: "昨夜睡眠",
                            tint: Color("AuroraLavender")
                        )
                        healthMetric(
                            symbol: "lungs.fill",
                            value: oxygenText,
                            label: "最近血氧",
                            tint: Color("SkyGlow")
                        )
                    }
                }
            }
        }
        .padding(size == .small ? 15 : 17)
        .foregroundStyle(Color("PlumInk"))
    }

    private var sleepRibbon: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Label("昨夜睡眠", systemImage: "moon.stars.fill")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("AuroraLavender"))

                Text(sleepText)
                    .font(size == .small ? .title : .largeTitle)
                    .fontWeight(.black)
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)

                Text(sleepQuality)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.5))

                if size != .small {
                    Text("睡眠数据来自 Apple 健康")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.34))
                }
            }

            Spacer(minLength: 0)

            VStack(alignment: .trailing, spacing: 7) {
                ForEach(Array([0.88, 0.66, 0.82, 0.52].enumerated()), id: \.offset) { index, width in
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color("AuroraLavender").opacity(0.35 + Double(index) * 0.12),
                                    Color("SkyGlow").opacity(0.72)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: (size == .small ? 58 : 116) * width, height: size == .small ? 11 : 15)
                }
            }
        }
        .padding(size == .small ? 15 : 18)
    }

    private var oxygenPulse: some View {
        Group {
            if size == .small {
                VStack(spacing: 9) {
                    oxygenRing(diameter: 96)
                    Text("最近一次血氧")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white.opacity(0.55))
                }
            } else {
                HStack(spacing: 18) {
                    oxygenRing(diameter: 112)

                    VStack(alignment: .leading, spacing: 10) {
                        Label("血氧脉冲", systemImage: "lungs.fill")
                            .font(.headline)

                        compactHealthRow(
                            symbol: "waveform.path.ecg",
                            label: "心率",
                            value: heartRateText,
                            tint: Color("AuroraCoral")
                        )
                        compactHealthRow(
                            symbol: "bed.double.fill",
                            label: "睡眠",
                            value: sleepText,
                            tint: Color("AuroraLavender")
                        )
                    }

                    Spacer(minLength: 0)
                }
            }
        }
        .padding(size == .small ? 14 : 18)
        .foregroundStyle(.white)
    }

    private var stepOrbit: some View {
        HStack(spacing: size == .small ? 10 : 18) {
            ZStack {
                Circle()
                    .stroke(Color("PlumInk").opacity(0.08), lineWidth: 12)
                Circle()
                    .trim(from: 0, to: stepProgress)
                    .stroke(
                        AngularGradient(
                            colors: [Color("SeaGlass"), Color("SkyGlow"), Color("AuroraLavender")],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 1) {
                    Image(systemName: "figure.walk")
                        .font(.caption)
                        .foregroundStyle(Color("SeaGlass"))
                    Text(compactSteps)
                        .font(.title3.weight(.black))
                        .monospacedDigit()
                }
            }
            .frame(width: size == .small ? 104 : 112, height: size == .small ? 104 : 112)

            if size != .small {
                VStack(alignment: .leading, spacing: 10) {
                    Text("今日步数")
                        .font(.headline)
                    Text("目标 10,000 步")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Label(distanceText, systemImage: "point.topleft.down.to.point.bottomright.curvepath")
                    Label(energyText, systemImage: "flame.fill")
                }
                .font(.caption.weight(.semibold))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: size == .small ? .center : .leading)
        .padding(size == .small ? 14 : 18)
        .foregroundStyle(Color("PlumInk"))
    }

    private var activeBento: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("活力概览")
                        .font(.headline)
                    Text("今天的身体已经完成这些")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.48))
                }
                Spacer()
                Image(systemName: "figure.run.circle.fill")
                    .font(.title2)
                    .foregroundStyle(Color("SeaGlass"))
            }

            HStack(spacing: 8) {
                activityMetric(symbol: "figure.walk", value: stepsText, label: "步数", tint: Color("SeaGlass"))
                activityMetric(symbol: "location.fill", value: distanceText, label: "距离", tint: Color("SkyGlow"))
                activityMetric(symbol: "flame.fill", value: energyText, label: "活动", tint: Color("AuroraCoral"))
            }

            if size == .large {
                HStack(alignment: .bottom, spacing: 7) {
                    ForEach([0.28, 0.46, 0.39, 0.65, 0.58, 0.82, stepProgress], id: \.self) { value in
                        Capsule()
                            .fill(Color("SeaGlass").opacity(0.35 + value * 0.55))
                            .frame(maxWidth: .infinity)
                            .frame(height: 24 + 60 * value)
                    }
                }
                .frame(maxHeight: 92)
                .accessibilityHidden(true)
            }
        }
        .padding(size == .large ? 20 : 17)
        .foregroundStyle(.white)
    }

    private var recoveryArc: some View {
        VStack(alignment: .leading, spacing: size == .small ? 10 : 13) {
            HStack {
                Label("今日平衡", systemImage: "heart.text.clipboard.fill")
                    .font(.caption.weight(.bold))
                Spacer()
                Text("仅作生活参考")
                    .font(.caption2)
                    .foregroundStyle(Color("PlumInk").opacity(0.42))
            }

            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .trim(from: 0.12, to: 0.88)
                        .stroke(Color.white.opacity(0.28), style: StrokeStyle(lineWidth: 11, lineCap: .round))
                        .rotationEffect(.degrees(90))
                    Circle()
                        .trim(from: 0.12, to: 0.12 + 0.76 * recoveryProgress)
                        .stroke(Color("PlumInk"), style: StrokeStyle(lineWidth: 11, lineCap: .round))
                        .rotationEffect(.degrees(90))
                    Text("\(Int((recoveryProgress * 100).rounded()))")
                        .font(.title2.weight(.black))
                        .monospacedDigit()
                }
                .frame(width: size == .small ? 92 : 108, height: size == .small ? 92 : 108)

                if size != .small {
                    VStack(alignment: .leading, spacing: 9) {
                        Label("睡眠 \(sleepText)", systemImage: "moon.stars.fill")
                        Label("步数 \(stepsText)", systemImage: "figure.walk")
                        Label("心率 \(heartRateText)", systemImage: "waveform.path.ecg")
                    }
                    .font(.caption.weight(.semibold))
                }
            }
        }
        .padding(size == .small ? 14 : 18)
        .foregroundStyle(Color("PlumInk"))
    }

    private var weatherNow: some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 5) {
                Label(weather.locationName, systemImage: "location.fill")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("PlumInk").opacity(0.55))

                Text("\(Int(weather.temperature.rounded()))°")
                    .font(.system(size: 58, weight: .black, design: .rounded))
                    .fontWidth(.condensed)
                    .foregroundStyle(.white)
                    .shadow(color: Color("PlumInk").opacity(0.12), radius: 12, y: 8)

                Text(weather.weatherCode.weatherDescription)
                    .font(.headline)
                    .foregroundStyle(Color("PlumInk"))
            }

            Spacer(minLength: 0)

            VStack(alignment: .trailing, spacing: 12) {
                Image(systemName: weather.weatherCode.weatherSymbolName)
                    .font(.system(size: 48))
                    .symbolRenderingMode(.multicolor)

                HStack(spacing: 10) {
                    weatherChip(symbol: "humidity.fill", value: "\(weather.humidity)%")
                    weatherChip(symbol: "wind", value: "\(Int(weather.windSpeed.rounded())) km/h")
                }

                Text("H \(Int(weather.highTemperature.rounded()))°  L \(Int(weather.lowTemperature.rounded()))°")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("PlumInk").opacity(0.58))
            }
        }
        .padding(18)
    }

    private var weatherHourly: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("未来六小时")
                        .font(.headline)
                    Text("\(weather.locationName) · \(weather.weatherCode.weatherDescription)")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.42))
                }

                Spacer()

                Text("\(Int(weather.temperature.rounded()))°")
                    .font(.title)
                    .fontWeight(.bold)
                    .monospacedDigit()
            }

            HStack(spacing: 5) {
                ForEach(weather.hourly.prefix(6)) { hour in
                    VStack(spacing: 5) {
                        Text(hour.label)
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.42))
                        Image(systemName: hour.weatherCode.weatherSymbolName)
                            .font(.caption)
                            .symbolRenderingMode(.multicolor)
                        Text("\(Int(hour.temperature.rounded()))°")
                            .font(.caption)
                            .fontWeight(.bold)
                        Text("\(hour.precipitationProbability)%")
                            .font(.caption2)
                            .foregroundStyle(Color("SkyGlow"))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(17)
        .foregroundStyle(.white)
    }

    private var weatherMinimal: some View {
        Group {
            if size == .small {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: weather.weatherCode.weatherSymbolName)
                            .font(.title2)
                            .symbolRenderingMode(.multicolor)
                        Spacer()
                        Text(weather.locationName)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text("\(Int(weather.temperature.rounded()))°")
                        .font(.system(size: 54, weight: .black, design: .rounded))
                        .fontWidth(.condensed)

                    Text(weather.weatherCode.weatherDescription)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                }
            } else {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(weather.locationName)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("\(Int(weather.temperature.rounded()))°")
                            .font(.system(size: 58, weight: .black, design: .rounded))
                            .fontWidth(.condensed)
                        Text("体感 \(Int(weather.apparentTemperature.rounded()))°")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 8) {
                        Image(systemName: weather.weatherCode.weatherSymbolName)
                            .font(.system(size: 48))
                            .symbolRenderingMode(.multicolor)
                        Text(weather.weatherCode.weatherDescription)
                            .font(.headline)
                        Text("日落 \(weather.sunset)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(size == .small ? 16 : 18)
        .foregroundStyle(Color("PlumInk"))
    }

    private var weatherUnavailable: some View {
        VStack(spacing: 10) {
            Image(systemName: "cloud.slash.fill")
                .font(.title)
                .foregroundStyle(Color("SkyGlow"))
            Text("天气暂时无法更新")
                .font(.headline)
            Text("请检查城市名称与网络")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .foregroundStyle(Color("PlumInk"))
    }

    private var loveDays: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.46))
                Image(systemName: "heart.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(Color("RoseGlow"))
            }
            .frame(width: 94, height: 94)

            VStack(alignment: .leading, spacing: 4) {
                Text(love.title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("PlumInk").opacity(0.5))

                HStack(alignment: .firstTextBaseline, spacing: 5) {
                    Text("\(daysTogether)")
                        .font(.system(size: 45, weight: .black, design: .rounded))
                        .fontWidth(.condensed)
                        .monospacedDigit()
                    Text("天")
                        .font(.headline)
                }

                Text("\(love.leftName)  ·  \(love.rightName)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("PlumInk").opacity(0.56))
            }

            Spacer(minLength: 0)
        }
        .padding(18)
        .foregroundStyle(Color("PlumInk"))
    }

    private var loveDaysCompact: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundStyle(Color("RoseGlow"))
                Spacer()
                Text("\(love.leftName) · \(love.rightName)")
                    .font(.caption2)
                    .foregroundStyle(Color("PlumInk").opacity(0.5))
            }

            Spacer()

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(daysTogether)")
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .fontWidth(.condensed)
                    .monospacedDigit()
                Text("天")
                    .font(.headline)
            }

            Text(love.title)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(Color("PlumInk").opacity(0.54))
        }
        .padding(16)
        .foregroundStyle(Color("PlumInk"))
    }

    private var loveOrbit: some View {
        Group {
            if size == .small {
                VStack(spacing: 8) {
                    anniversaryRing(diameter: 102)
                    Text("距离下个周年")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.5))
                }
            } else {
                HStack(spacing: 18) {
                    anniversaryRing(diameter: 112)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("下一个周年纪念")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.48))
                        Text("\(daysUntilAnniversary) 天")
                            .font(.title)
                            .fontWeight(.black)
                            .fontDesign(.rounded)
                        Text("已经一起走过 \(daysTogether) 天")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.58))
                    }

                    Spacer(minLength: 0)
                }
            }
        }
        .padding(size == .small ? 14 : 18)
        .foregroundStyle(.white)
    }

    private var editorialClock: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(date.formatted(.dateTime.weekday(.wide)))
                    .font(.caption)
                    .fontWeight(.black)
                    .tracking(1.4)
                Spacer()
                Text(date.formatted(.dateTime.month().day()))
                    .font(.caption)
                    .foregroundStyle(Color("PlumInk").opacity(0.45))
            }

            Spacer(minLength: 0)

            Text(date, style: .time)
                .font(.system(size: size == .small ? 45 : 64, weight: .black, design: .rounded))
                .fontWidth(.condensed)
                .monospacedDigit()
                .minimumScaleFactor(0.55)
                .lineLimit(1)

            Text("MAKE TIME YOURS")
                .font(.caption2)
                .fontWeight(.black)
                .tracking(2)
                .foregroundStyle(Color("RoseGlow"))
        }
        .padding(size == .small ? 16 : 18)
        .foregroundStyle(Color("PlumInk"))
    }

    private var worldClock: some View {
        HStack(spacing: 0) {
            ForEach(Array(clock.cities.prefix(3).enumerated()), id: \.element.id) { index, city in
                VStack(alignment: .leading, spacing: 7) {
                    Text(city.name)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white.opacity(0.48))
                    Text(timeText(for: city.timeZoneIdentifier))
                        .font(.title3)
                        .fontWeight(.bold)
                        .monospacedDigit()
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                    Text(dayRelation(for: city.timeZoneIdentifier))
                        .font(.caption2)
                        .foregroundStyle(index == 0 ? Color("SeaGlass") : Color("AuroraLavender"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if index < min(clock.cities.count, 3) - 1 {
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 1, height: 62)
                        .padding(.horizontal, 10)
                }
            }
        }
        .padding(18)
        .foregroundStyle(.white)
    }

    private var worldClockCompact: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("世界时间", systemImage: "globe.asia.australia.fill")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(Color("SeaGlass"))

            Spacer()

            if let city = clock.cities.first {
                Text(city.name)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.45))
                Text(timeText(for: city.timeZoneIdentifier))
                    .font(.system(size: 38, weight: .black, design: .rounded))
                    .fontWidth(.condensed)
                    .monospacedDigit()
                Text(dayRelation(for: city.timeZoneIdentifier))
                    .font(.caption2)
                    .foregroundStyle(Color("AuroraLavender"))
            }
        }
        .padding(16)
        .foregroundStyle(.white)
    }

    private var calendarClock: some View {
        VStack(alignment: .leading, spacing: size == .small ? 8 : 12) {
            HStack(alignment: .firstTextBaseline) {
                Text(date.formatted(.dateTime.day()))
                    .font(.system(size: size == .small ? 48 : 56, weight: .black, design: .rounded))
                    .fontWidth(.condensed)
                VStack(alignment: .leading, spacing: 0) {
                    Text(date.formatted(.dateTime.month(.wide)))
                        .font(.headline)
                    Text(date.formatted(.dateTime.weekday(.wide)))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(date, style: .time)
                    .font(.headline)
                    .fontWeight(.bold)
                    .monospacedDigit()
            }

            HStack(spacing: 5) {
                ForEach(calendarWeek) { item in
                    VStack(spacing: 4) {
                        Text(item.weekday)
                            .font(.caption2)
                        Text("\(item.day)")
                            .font(.caption)
                            .fontWeight(item.isToday ? .black : .regular)
                            .frame(width: 25, height: 25)
                            .background(item.isToday ? Color("PlumInk") : Color.clear, in: Circle())
                            .foregroundStyle(item.isToday ? Color.white : Color("PlumInk"))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(size == .small ? 15 : 18)
        .foregroundStyle(Color("PlumInk"))
    }

    private func healthMetric(symbol: String, value: String, label: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Image(systemName: symbol)
                .font(.headline)
                .foregroundStyle(tint)
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .monospacedDigit()
                .minimumScaleFactor(0.65)
                .lineLimit(1)
            Text(label)
                .font(.caption2)
                .foregroundStyle(Color("PlumInk").opacity(0.42))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color.white.opacity(0.64), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
    }

    private func compactHealthRow(symbol: String, label: String, value: String, tint: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: symbol)
                .foregroundStyle(tint)
                .frame(width: 20)
            Text(label)
                .foregroundStyle(.white.opacity(0.48))
            Spacer()
            Text(value)
                .fontWeight(.bold)
                .monospacedDigit()
        }
        .font(.caption)
    }

    private func activityMetric(symbol: String, value: String, label: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: symbol)
                .foregroundStyle(tint)
            Text(value)
                .font(.headline.weight(.bold))
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.65)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.45))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(11)
        .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 17, style: .continuous))
    }

    private func oxygenRing(diameter: CGFloat) -> some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: 12)
            Circle()
                .trim(from: 0, to: max(health.oxygenSaturation ?? 0, 0.02))
                .stroke(
                    Color("SkyGlow"),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            VStack(spacing: 0) {
                Text(oxygenText.replacingOccurrences(of: "%", with: ""))
                    .font(.title)
                    .fontWeight(.black)
                    .monospacedDigit()
                Text("%")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.45))
            }
        }
        .frame(width: diameter, height: diameter)
    }

    private func weatherChip(symbol: String, value: String) -> some View {
        Label(value, systemImage: symbol)
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundStyle(Color("PlumInk").opacity(0.64))
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(Color.white.opacity(0.35), in: Capsule())
    }

    private func anniversaryRing(diameter: CGFloat) -> some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: 11)
            Circle()
                .trim(from: 0, to: max(anniversaryProgress, 0.02))
                .stroke(
                    Color("RoseGlow"),
                    style: StrokeStyle(lineWidth: 11, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            VStack(spacing: 2) {
                Image(systemName: "heart.fill")
                    .font(.caption)
                    .foregroundStyle(Color("RoseGlow"))
                Text("\(daysUntilAnniversary)")
                    .font(.title2)
                    .fontWeight(.black)
                    .monospacedDigit()
            }
        }
        .frame(width: diameter, height: diameter)
    }

    private var heartRateText: String {
        guard let heartRate = health.heartRate else { return "— bpm" }
        return "\(Int(heartRate.rounded())) bpm"
    }

    private var sleepText: String {
        guard let hours = health.sleepHours else { return "— 小时" }
        return "\(hours.formatted(.number.precision(.fractionLength(1)))) 小时"
    }

    private var oxygenText: String {
        guard let oxygen = health.oxygenSaturation else { return "—%" }
        return "\(Int((oxygen * 100).rounded()))%"
    }

    private var stepsText: String {
        guard let steps = health.stepCount else { return "—" }
        return Int(steps.rounded()).formatted()
    }

    private var compactSteps: String {
        guard let steps = health.stepCount else { return "—" }
        if steps >= 1_000 {
            return "\((steps / 1_000).formatted(.number.precision(.fractionLength(1))))k"
        }
        return "\(Int(steps.rounded()))"
    }

    private var distanceText: String {
        guard let distance = health.walkingDistanceKilometers else { return "— km" }
        return "\(distance.formatted(.number.precision(.fractionLength(1)))) km"
    }

    private var energyText: String {
        guard let energy = health.activeEnergy else { return "— kcal" }
        return "\(Int(energy.rounded())) kcal"
    }

    private var stepProgress: Double {
        min(max((health.stepCount ?? 0) / 10_000, 0.02), 1)
    }

    private var recoveryProgress: Double {
        let sleep = min(max((health.sleepHours ?? 0) / 8, 0), 1)
        let movement = min(max((health.stepCount ?? 0) / 10_000, 0), 1)
        return max(0.05, sleep * 0.62 + movement * 0.38)
    }

    private var sleepQuality: String {
        guard let hours = health.sleepHours else { return "打开 App 授权健康数据" }
        return switch hours {
        case 7...: "睡得不错，今天保持节奏"
        case 6..<7: "睡眠略短，记得适当休息"
        default: "今天尽量早点休息"
        }
    }

    private var daysTogether: Int {
        max(Calendar.autoupdatingCurrent.dateComponents([.day], from: love.startDate, to: date).day ?? 0, 0)
    }

    private var nextAnniversaryDate: Date {
        let calendar = Calendar.autoupdatingCurrent
        let startComponents = calendar.dateComponents([.month, .day], from: love.startDate)
        let currentYear = calendar.component(.year, from: date)
        var components = DateComponents()
        components.year = currentYear
        components.month = startComponents.month
        components.day = startComponents.day
        let candidate = calendar.date(from: components) ?? date
        if candidate >= calendar.startOfDay(for: date) {
            return candidate
        }
        return calendar.date(byAdding: .year, value: 1, to: candidate) ?? candidate
    }

    private var daysUntilAnniversary: Int {
        max(
            Calendar.autoupdatingCurrent.dateComponents(
                [.day],
                from: Calendar.autoupdatingCurrent.startOfDay(for: date),
                to: nextAnniversaryDate
            ).day ?? 0,
            0
        )
    }

    private var anniversaryProgress: Double {
        1 - min(max(Double(daysUntilAnniversary) / 365, 0), 1)
    }

    private func timeText(for identifier: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(identifier: identifier)
        return formatter.string(from: date)
    }

    private func dayRelation(for identifier: String) -> String {
        guard let timeZone = TimeZone(identifier: identifier) else { return "当地时间" }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        let localDay = calendar.ordinality(of: .day, in: .era, for: date) ?? 0

        var currentCalendar = Calendar(identifier: .gregorian)
        currentCalendar.timeZone = .autoupdatingCurrent
        let currentDay = currentCalendar.ordinality(of: .day, in: .era, for: date) ?? 0

        return switch localDay - currentDay {
        case let difference where difference > 0: "明天"
        case let difference where difference < 0: "昨天"
        default: "今天"
        }
    }

    private var calendarWeek: [CalendarDayItem] {
        let calendar = Calendar.autoupdatingCurrent
        let start = calendar.dateInterval(of: .weekOfYear, for: date)?.start
            ?? calendar.startOfDay(for: date)
        let labels = ["日", "一", "二", "三", "四", "五", "六"]

        return (0..<7).compactMap { offset in
            guard let dayDate = calendar.date(byAdding: .day, value: offset, to: start) else {
                return nil
            }
            let weekday = calendar.component(.weekday, from: dayDate)
            return CalendarDayItem(
                id: offset,
                weekday: labels[weekday - 1],
                day: calendar.component(.day, from: dayDate),
                isToday: calendar.isDate(dayDate, inSameDayAs: date)
            )
        }
    }
}

private struct CalendarDayItem: Identifiable {
    let id: Int
    let weekday: String
    let day: Int
    let isToday: Bool
}
