import SwiftUI

extension Color {
    init(atelierHex: String) {
        let value = UInt64(atelierHex.dropFirst(), radix: 16) ?? 0
        self.init(.sRGB, red: Double((value >> 16) & 255) / 255, green: Double((value >> 8) & 255) / 255, blue: Double(value & 255) / 255, opacity: 1)
    }
}

struct ExpansionTemplateBackground: View {
    let template: WidgetTemplateKind
    var body: some View {
        let palette = template.design.palette
        ZStack {
            LinearGradient(colors: [Color(atelierHex: palette[0]), Color(atelierHex: palette[1])], startPoint: .topLeading, endPoint: .bottomTrailing)
            RadialGradient(colors: [.white.opacity(0.16), .clear], center: .topLeading, startRadius: 0, endRadius: 280)
        }
    }
}

struct ExpansionTemplateArtwork: View {
    let template: WidgetTemplateKind
    let size: WidgetArtworkSize
    private var design: TemplateDesign { template.design }
    private var ink: Color { Color(atelierHex: design.palette[2]) }
    private var accent: Color { Color(atelierHex: design.palette[3]) }
    private var muted: Color { Color(atelierHex: design.palette[4]) }
    private var compact: Bool { size == .small }

    var body: some View {
        VStack(alignment: .leading, spacing: compact ? 8 : 11) {
            HStack(spacing: 6) {
                Image(systemName: template.symbolName).font(.system(size: 10, weight: .medium)).foregroundStyle(accent)
                Text(design.eyebrow).font(.system(size: compact ? 8 : 9, weight: .semibold)).tracking(1.4).lineLimit(1)
                Spacer(minLength: 0)
            }.foregroundStyle(muted)
            composition.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            HStack {
                Text(template.title).font(.system(size: compact ? 10 : 11, weight: .semibold)).lineLimit(1)
                Spacer(minLength: 4)
                if !compact { Text("EKHART").font(.system(size: 8, weight: .medium)).tracking(1.2).foregroundStyle(muted) }
            }
        }
        .padding(compact ? 16 : size == .large ? 24 : 19)
        .foregroundStyle(ink)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(template.title)，\(design.value)，示例内容")
    }

    @ViewBuilder private var composition: some View {
        switch design.layout {
        case .orbit, .dial: circular
        case .bento: bento
        case .timeline, .waveform: chart
        case .poster, .editorial: editorial
        case .gauge: gauge
        case .list: list
        case .ticket: ticket
        case .constellation: constellation
        case .mosaic: mosaic
        }
    }

    private func headline(_ text: String, serif: Bool = false) -> some View {
        Text(text).font(.system(size: compact ? 24 : size == .large ? 38 : 30, weight: serif ? .regular : .semibold, design: serif ? .serif : .rounded))
            .minimumScaleFactor(0.72).lineLimit(2).fixedSize(horizontal: false, vertical: true)
    }

    private var editorial: some View {
        VStack(alignment: .leading, spacing: 10) {
            Rectangle().fill(accent.opacity(0.7)).frame(width: 28, height: 1)
            headline(design.value, serif: design.layout == .editorial)
            Text(design.caption).font(.system(size: compact ? 10 : 11)).foregroundStyle(muted).lineLimit(2)
        }
    }

    private var circular: some View {
        Group {
            if compact {
                ZStack {
                    rings(diameter: 86)
                    Text(design.value).font(.system(size: 15, weight: .semibold, design: .rounded)).multilineTextAlignment(.center).lineLimit(2).padding(22)
                }.frame(maxWidth: .infinity)
            } else {
                HStack(spacing: 20) {
                    rings(diameter: size == .large ? 132 : 84)
                    VStack(alignment: .leading, spacing: 8) {
                        headline(design.value)
                        Text(design.metrics[0].label + " · " + design.metrics[0].value).font(.caption).foregroundStyle(muted)
                    }
                }
            }
        }
    }

    private func rings(diameter: CGFloat) -> some View {
        ZStack {
            if design.layout == .dial {
                ForEach(0..<36) { index in
                    Rectangle().fill(index % 3 == 0 ? accent : ink.opacity(0.2)).frame(width: 1, height: index % 3 == 0 ? 8 : 4)
                        .offset(y: -diameter / 2 + 6).rotationEffect(.degrees(Double(index) * 10))
                }
                Circle().fill(accent).frame(width: 7, height: 7)
                Rectangle().fill(accent).frame(width: 2, height: diameter * 0.27).offset(y: -diameter * 0.135).rotationEffect(.degrees(42))
            } else {
                Circle().stroke(ink.opacity(0.09), lineWidth: 7)
                Circle().trim(from: 0, to: design.progress).stroke(accent, style: StrokeStyle(lineWidth: 7, lineCap: .round)).rotationEffect(.degrees(-90))
                Circle().inset(by: 14).trim(from: 0, to: design.secondaryProgress).stroke(accent.opacity(0.38), style: StrokeStyle(lineWidth: 4, lineCap: .round)).rotationEffect(.degrees(-90))
                if !compact { Text("\(Int(design.progress * 100))%").font(.system(size: 16, weight: .medium, design: .rounded)) }
            }
        }.frame(width: diameter, height: diameter)
    }

    private var bento: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 6) {
                headline(design.value)
                Text(design.metrics[0].label).font(.caption2).foregroundStyle(muted)
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading).padding(12).background(.white.opacity(0.16), in: RoundedRectangle(cornerRadius: 15))
            if !compact {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(1..<3) { index in
                        VStack(alignment: .leading, spacing: 3) {
                            Text(design.metrics[index].value).font(.system(size: 14, weight: .semibold)).lineLimit(1)
                            Text(design.metrics[index].label).font(.system(size: 9)).foregroundStyle(muted)
                        }
                    }
                }.frame(maxWidth: .infinity, alignment: .leading).padding(12)
            }
        }
    }

    private var chart: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(design.value).font(.system(size: compact ? 20 : 25, weight: .medium, design: .rounded)).lineLimit(1).minimumScaleFactor(0.7)
            Canvas { context, canvas in
                if design.layout == .timeline || template.category == .music {
                    let count = design.series.count
                    for (index, value) in design.series.enumerated() {
                        let width = canvas.width / CGFloat(count)
                        let rect = CGRect(x: CGFloat(index) * width + 2, y: canvas.height * (1 - value), width: width * 0.6, height: canvas.height * value)
                        context.fill(Path(roundedRect: rect, cornerRadius: 3), with: .color(index == count - 1 ? accent : accent.opacity(0.38)))
                    }
                } else {
                    var path = Path()
                    for (index, value) in design.series.enumerated() {
                        let point = CGPoint(x: canvas.width * Double(index) / Double(design.series.count - 1), y: canvas.height * (1 - value))
                        if index == 0 { path.move(to: point) } else { path.addLine(to: point) }
                    }
                    context.stroke(path, with: .color(accent), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                }
            }.frame(height: size == .large ? 94 : 37).accessibilityHidden(true)
            Text(design.metrics[0].label + " · " + design.metrics[0].value).font(.system(size: 9)).foregroundStyle(muted)
        }
    }

    private var gauge: some View {
        VStack(alignment: .leading, spacing: 11) {
            headline(design.value)
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule().fill(ink.opacity(0.09))
                    Capsule().fill(accent).frame(width: proxy.size.width * design.progress)
                }
            }.frame(height: 5)
            Text(design.metrics[0].label + " " + design.metrics[0].value).font(.system(size: 10)).foregroundStyle(muted)
        }
    }

    private var list: some View {
        VStack(alignment: .leading, spacing: compact ? 6 : 9) {
            ForEach(0..<(compact ? 2 : 3)) { index in
                HStack {
                    Text(String(format: "%02d", index + 1)).font(.system(size: 8)).foregroundStyle(accent)
                    Text(design.rows[index].label).font(.system(size: compact ? 11 : 12)).lineLimit(1)
                    Spacer(minLength: 6)
                    Text(design.rows[index].value).font(.system(size: compact ? 10 : 11, weight: .medium)).lineLimit(1).foregroundStyle(muted)
                }
                if index < (compact ? 1 : 2) { Rectangle().fill(ink.opacity(0.1)).frame(height: 0.5) }
            }
        }
    }

    private var ticket: some View {
        VStack(alignment: .leading, spacing: 10) {
            headline(design.value)
            Line().stroke(ink.opacity(0.22), style: StrokeStyle(lineWidth: 0.7, dash: [2, 4])).frame(height: 1)
            HStack {
                ForEach(0..<(compact ? 2 : 3)) { index in
                    VStack(alignment: .leading, spacing: 3) {
                        Text(design.metrics[index].label).font(.system(size: 8)).foregroundStyle(muted)
                        Text(design.metrics[index].value).font(.system(size: 11, weight: .medium)).lineLimit(1)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    private var constellation: some View {
        VStack(alignment: .leading, spacing: 11) {
            Text(design.value).font(.system(size: compact ? 20 : 25, weight: .medium)).lineLimit(1)
            HStack(spacing: 8) {
                ForEach(0..<7) { column in
                    VStack(spacing: 7) {
                        ForEach(0..<3) { row in
                            Circle().fill(Double(column * 3 + row) / 21 < design.progress ? accent : ink.opacity(0.1)).frame(width: compact ? 6 : 8, height: compact ? 6 : 8)
                        }
                    }.frame(maxWidth: .infinity)
                }
            }
        }
    }

    private var mosaic: some View {
        HStack(spacing: 7) {
            window(index: 0).frame(maxWidth: .infinity)
            if !compact {
                VStack(spacing: 7) { window(index: 1); window(index: 2) }.frame(width: 70)
            }
        }.frame(height: size == .large ? 160 : compact ? 75 : 82)
        .overlay(alignment: .bottomLeading) {
            Text(design.value).font(.system(size: 13, weight: .medium, design: .serif)).foregroundStyle(ink).padding(9)
        }
    }

    private func window(index: Int) -> some View {
        ZStack {
            accent.opacity(index == 0 ? 0.14 : 0.08)
            Circle().fill(accent.opacity(0.25)).frame(width: index == 0 ? 45 : 22, height: index == 0 ? 45 : 22).offset(x: 12, y: -12)
            RoundedRectangle(cornerRadius: 35).fill(accent.opacity(0.16)).rotationEffect(.degrees(-22)).offset(y: 40)
        }.clipShape(RoundedRectangle(cornerRadius: 12)).overlay(RoundedRectangle(cornerRadius: 12).stroke(.white.opacity(0.35), lineWidth: 0.7))
    }
}

private struct Line: Shape {
    func path(in rect: CGRect) -> Path { Path { $0.move(to: .zero); $0.addLine(to: CGPoint(x: rect.width, y: 0)) } }
}
