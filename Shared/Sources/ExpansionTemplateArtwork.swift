import SwiftUI

struct ExpansionTemplateBackground: View {
    let template: WidgetTemplateKind

    var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var colors: [Color] {
        switch template.expansionMetadata?.palette ?? 0 {
        case 0: [Color("SoftCream"), Color("SeaGlass").opacity(0.42)]
        case 1: [Color("PlumInk"), Color("GlowSurfaceAlt")]
        case 2: [Color("SkyGlow"), Color("AuroraLavender").opacity(0.78)]
        case 3: [Color("GlowCanvas"), Color("PlumInk")]
        case 4: [Color("ButterGlow"), Color("RoseGlow").opacity(0.72)]
        default: [Color("AuroraLavender"), Color("AuroraCoral").opacity(0.74)]
        }
    }
}

struct ExpansionTemplateArtwork: View {
    let template: WidgetTemplateKind
    let size: WidgetArtworkSize

    private var metadata: ExpansionTemplateMetadata {
        template.expansionMetadata ?? ExpansionTemplateMetadata(
            title: template.title,
            subtitle: template.subtitle,
            category: template.category,
            symbolName: template.symbolName,
            layout: .poster,
            palette: 0
        )
    }

    var body: some View {
        Group {
            switch metadata.layout {
            case .orbit: orbitLayout
            case .bento: bentoLayout
            case .timeline: timelineLayout
            case .poster: posterLayout
            case .gauge: gaugeLayout
            case .list: listLayout
            }
        }
        .foregroundStyle(primaryText)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(metadata.title)，\(primaryValue)")
    }

    private var orbitLayout: some View {
        Group {
            if size == .small {
                VStack(spacing: 9) {
                    orbit(diameter: 92)
                    Text(metadata.title)
                        .font(.caption.weight(.bold))
                }
            } else {
                HStack(spacing: 20) {
                    orbit(diameter: 112)
                    VStack(alignment: .leading, spacing: 7) {
                        Label(metadata.title, systemImage: metadata.symbolName)
                            .font(.headline)
                        Text(primaryValue)
                            .font(.title2.weight(.bold))
                            .monospacedDigit()
                        Text(metadata.subtitle)
                            .font(.caption)
                            .foregroundStyle(secondaryText)
                            .lineLimit(2)
                    }
                    Spacer(minLength: 0)
                }
            }
        }
        .padding(size == .small ? 14 : 18)
    }

    private var bentoLayout: some View {
        VStack(alignment: .leading, spacing: size == .large ? 14 : 10) {
            HStack {
                Label(metadata.title, systemImage: metadata.symbolName)
                    .font(.headline)
                Spacer()
                Text("TODAY")
                    .font(.caption2.weight(.black))
                    .tracking(1)
                    .foregroundStyle(secondaryText)
            }

            HStack(spacing: 9) {
                metricCard(value: primaryValue, label: metricLabels[0], tint: accents[0])
                metricCard(value: secondaryValues[0], label: metricLabels[1], tint: accents[1])
                if size == .large {
                    metricCard(value: secondaryValues[1], label: metricLabels[2], tint: accents[2])
                }
            }

            if size == .large {
                Text(metadata.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(secondaryText)
            }
        }
        .padding(size == .large ? 20 : 16)
    }

    private var timelineLayout: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(metadata.title, systemImage: metadata.symbolName)
                    .font(.headline)
                Spacer()
                Text(primaryValue)
                    .font(.subheadline.weight(.bold))
                    .monospacedDigit()
            }

            HStack(alignment: .bottom, spacing: 7) {
                ForEach(Array(barValues.enumerated()), id: \.offset) { index, value in
                    VStack(spacing: 5) {
                        Capsule()
                            .fill(index == 4 ? accents[0] : accents[index % accents.count].opacity(0.52))
                            .frame(maxWidth: .infinity)
                            .frame(height: CGFloat(value) * (size == .large ? 78 : 48))
                        Text(weekLabels[index])
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundStyle(secondaryText)
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            if size == .large {
                Text(metadata.subtitle)
                    .font(.caption)
                    .foregroundStyle(secondaryText)
            }
        }
        .padding(size == .large ? 20 : 16)
    }

    private var posterLayout: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: metadata.symbolName)
                    .font(.title2)
                    .foregroundStyle(accents[0])
                Spacer()
                Text(metadata.category.title)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(secondaryText)
            }

            Spacer(minLength: 0)

            Text(primaryValue)
                .font(.system(size: size == .small ? 38 : 48, weight: .black, design: .rounded))
                .minimumScaleFactor(0.55)
                .lineLimit(1)
                .monospacedDigit()
            Text(metadata.title)
                .font(.headline)
            Text(metadata.subtitle)
                .font(.caption2)
                .foregroundStyle(secondaryText)
                .lineLimit(size == .small ? 2 : 1)
        }
        .padding(size == .small ? 15 : 18)
    }

    private var gaugeLayout: some View {
        VStack(alignment: .leading, spacing: size == .small ? 11 : 14) {
            HStack {
                Label(metadata.title, systemImage: metadata.symbolName)
                    .font(.caption.weight(.bold))
                Spacer()
                Text("72%")
                    .font(.caption.weight(.black))
                    .monospacedDigit()
            }

            Text(primaryValue)
                .font(size == .small ? .title2 : .largeTitle)
                .fontWeight(.black)
                .fontDesign(.rounded)
                .minimumScaleFactor(0.6)
                .lineLimit(1)

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule().fill(primaryText.opacity(0.12))
                    Capsule()
                        .fill(LinearGradient(colors: [accents[0], accents[1]], startPoint: .leading, endPoint: .trailing))
                        .frame(width: proxy.size.width * 0.72)
                }
            }
            .frame(height: 10)

            if size != .small {
                HStack {
                    Text(secondaryValues[0])
                    Spacer()
                    Text(secondaryValues[1])
                }
                .font(.caption.weight(.semibold))
                .foregroundStyle(secondaryText)
            }
        }
        .padding(size == .small ? 15 : 18)
    }

    private var listLayout: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label(metadata.title, systemImage: metadata.symbolName)
                    .font(.headline)
                Spacer()
                Text(primaryValue)
                    .font(.subheadline.weight(.bold))
            }

            ForEach(Array(sampleRows.enumerated()), id: \.offset) { index, row in
                HStack(spacing: 10) {
                    Circle()
                        .fill(accents[index % accents.count])
                        .frame(width: 8, height: 8)
                    Text(row.0)
                        .font(.subheadline)
                        .lineLimit(1)
                    Spacer()
                    Text(row.1)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(secondaryText)
                }
                .padding(.horizontal, 11)
                .frame(minHeight: size == .large ? 43 : 34)
                .background(primaryText.opacity(isDarkPalette ? 0.07 : 0.08), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
        .padding(size == .large ? 20 : 16)
    }

    private func orbit(diameter: CGFloat) -> some View {
        ZStack {
            Circle().stroke(primaryText.opacity(0.1), lineWidth: 12)
            Circle()
                .trim(from: 0, to: 0.72)
                .stroke(accents[0], style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Circle()
                .inset(by: 18)
                .trim(from: 0, to: 0.48)
                .stroke(accents[1], style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
            VStack(spacing: 0) {
                Text("72")
                    .font(.title2.weight(.black))
                    .monospacedDigit()
                Text("%")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(secondaryText)
            }
        }
        .frame(width: diameter, height: diameter)
    }

    private func metricCard(value: String, label: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Circle().fill(tint).frame(width: 9, height: 9)
            Text(value)
                .font(.headline)
                .monospacedDigit()
                .minimumScaleFactor(0.65)
                .lineLimit(1)
            Text(label)
                .font(.caption2)
                .foregroundStyle(secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(11)
        .background(primaryText.opacity(isDarkPalette ? 0.08 : 0.1), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
    }

    private var isDarkPalette: Bool {
        [1, 3].contains(metadata.palette)
    }

    private var primaryText: Color {
        isDarkPalette ? .white : Color("PlumInk")
    }

    private var secondaryText: Color {
        primaryText.opacity(isDarkPalette ? 0.58 : 0.56)
    }

    private var accents: [Color] {
        switch metadata.palette {
        case 0: [Color("SeaGlass"), Color("SkyGlow"), Color("AuroraLavender")]
        case 1: [Color("AuroraCoral"), Color("SeaGlass"), Color("AuroraLavender")]
        case 2: [Color("PlumInk"), Color("AuroraLavender"), Color("SeaGlass")]
        case 3: [Color("SkyGlow"), Color("AuroraLavender"), Color("RoseGlow")]
        case 4: [Color("AuroraCoral"), Color("PlumInk"), Color("SeaGlass")]
        default: [Color("ButterGlow"), Color("SeaGlass"), Color("SkyGlow")]
        }
    }

    private var primaryValue: String {
        if let value = template.sampleValue { return value }
        return switch metadata.category {
        case .health: "7,480"
        case .weather: "23°"
        case .love: "520 天"
        case .time: "09:41"
        case .tools: "72%"
        case .photos: "AUG 10"
        case .music: "03:28"
        case .finance: "+2.36%"
        case .planner: "3 / 5"
        case .daily: "今日"
        case .countdown: "18 天"
        case .income: "¥386"
        case .rhythm: "61%"
        default: "72%"
        }
    }

    private var secondaryValues: [String] {
        switch metadata.category {
        case .health: ["7.2 h", "98%"]
        case .weather: ["湿度 56%", "微风 NE"]
        case .love: ["下次见面 3 天", "周年 42 天"]
        case .time: ["上海", "伦敦 01:41"]
        case .tools: ["已使用 84 GB", "剩余 44 GB"]
        case .photos: ["3 张照片", "两年前"]
        case .music: ["正在播放", "喜欢的歌单"]
        case .finance: ["¥12,680", "本月 +6.4%"]
        case .planner: ["下一项 14:00", "专注 45 MIN"]
        case .daily: ["适合整理", "幸运时段 16:00"]
        case .countdown: ["周五出发", "已准备 72%"]
        case .income: ["本月 61%", "距发薪 12 天"]
        case .rhythm: ["第 32 周", "还剩 142 天"]
        default: ["今日", "本周"]
        }
    }

    private var metricLabels: [String] {
        switch metadata.category {
        case .health: ["今日", "睡眠", "血氧"]
        case .finance: ["涨跌", "资产", "本月"]
        case .planner: ["完成", "下一项", "专注"]
        default: ["当前", "今日", "本周"]
        }
    }

    private var sampleRows: [(String, String)] {
        switch metadata.category {
        case .planner:
            [("方案确认", "09:30"), ("散步与晒太阳", "14:00"), ("晚间阅读", "19:30")]
        case .weather:
            [("今天", "23° / 16°"), ("明天", "25° / 17°"), ("周三", "22° / 15°")]
        case .finance:
            [("科技", "+2.4%"), ("消费", "+0.8%"), ("能源", "-0.3%")]
        default:
            [("第一项", secondaryValues[0]), ("第二项", secondaryValues[1]), ("今日状态", "良好")]
        }
    }

    private let barValues: [Double] = [0.38, 0.62, 0.48, 0.82, 1, 0.66, 0.52]
    private let weekLabels = ["一", "二", "三", "四", "五", "六", "日"]
}
