import SwiftUI

struct FinanceTemplateBackground: View {
    let template: WidgetTemplateKind

    var body: some View {
        switch template {
        case .currencyMinimal:
            LinearGradient(
                colors: [Color("SoftCream"), Color("SkyGlow").opacity(0.22)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .currencyMatrix:
            LinearGradient(
                colors: [Color("GlowCanvas"), Color("PlumInk")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .travelConverter:
            LinearGradient(
                colors: [Color("ButterGlow").opacity(0.8), Color("SoftCream")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .goldSpot:
            LinearGradient(
                colors: [Color("GlowCanvas"), Color("PlumInk"), Color("ButterGlow").opacity(0.45)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .goldTrend:
            LinearGradient(
                colors: [Color("SoftCream"), Color("ButterGlow").opacity(0.28)],
                startPoint: .top,
                endPoint: .bottomTrailing
            )
        case .metalsDuo:
            LinearGradient(
                colors: [Color("PlumInk"), Color("GlowSurfaceAlt")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .stockQuote:
            LinearGradient(
                colors: [Color("GlowCanvas"), Color("SkyGlow").opacity(0.66)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .watchlistBento:
            LinearGradient(
                colors: [Color("GalleryCanvas"), Color("AuroraLavender").opacity(0.22)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .dualMarket:
            LinearGradient(
                colors: [Color("PlumInk"), Color("AuroraLavender").opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            Color("GalleryCanvas")
        }
    }
}

struct FinanceTemplateArtwork: View {
    let template: WidgetTemplateKind
    let size: WidgetArtworkSize
    let currency: CurrencyWidgetData
    let gold: GoldWidgetData
    let stocks: StockWidgetData

    init(
        template: WidgetTemplateKind,
        size: WidgetArtworkSize,
        currency: CurrencyWidgetData = .preview,
        gold: GoldWidgetData = .preview,
        stocks: StockWidgetData = .preview
    ) {
        self.template = template
        self.size = size
        self.currency = currency
        self.gold = gold
        self.stocks = stocks
    }

    var body: some View {
        Group {
            switch template {
            case .currencyMinimal:
                currency.isAvailable ? AnyView(currencyMinimal) : AnyView(unavailable(currency.message))
            case .currencyMatrix:
                currency.isAvailable ? AnyView(currencyMatrix) : AnyView(unavailable(currency.message))
            case .travelConverter:
                currency.isAvailable ? AnyView(travelConverter) : AnyView(unavailable(currency.message))
            case .goldSpot:
                gold.isAvailable ? AnyView(goldSpot) : AnyView(unavailable(gold.message))
            case .goldTrend:
                gold.isAvailable ? AnyView(goldTrend) : AnyView(unavailable(gold.message))
            case .metalsDuo:
                gold.isAvailable ? AnyView(metalsDuo) : AnyView(unavailable(gold.message))
            case .stockQuote:
                stocks.isAvailable ? AnyView(stockQuote) : AnyView(unavailable(stocks.message))
            case .watchlistBento:
                stocks.isAvailable ? AnyView(watchlistBento) : AnyView(unavailable(stocks.message))
            case .dualMarket:
                stocks.isAvailable ? AnyView(dualMarket) : AnyView(unavailable(stocks.message))
            default:
                EmptyView()
            }
        }
        .accessibilityElement(children: .contain)
    }

    private var currencyMinimal: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                Label("参考汇率", systemImage: "dollarsign.arrow.circlepath")
                    .font(.caption)
                    .fontWeight(.bold)
                Spacer()
                Text("ECB")
                    .font(.system(size: 8, weight: .black))
                    .tracking(1.2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("1 \(currency.baseCode)")
                .font(.caption)
                .foregroundStyle(.secondary)
            HStack(alignment: .firstTextBaseline, spacing: 5) {
                Text(rateText(currency.rate))
                    .font(.system(size: size == .small ? 42 : 54, weight: .black, design: .rounded))
                    .fontWidth(.condensed)
                    .monospacedDigit()
                    .minimumScaleFactor(0.55)
                    .lineLimit(1)
                Text(currency.quoteCode)
                    .font(.headline)
            }

            HStack {
                changeLabel(currency.changePercentage)
                Spacer()
                Text(currency.rateDate)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(size == .small ? 15 : 18)
        .foregroundStyle(Color("PlumInk"))
    }

    private var currencyMatrix: some View {
        VStack(alignment: .leading, spacing: 11) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("汇率矩阵")
                        .font(.headline)
                        .fontWeight(.black)
                    Text("1 \(currency.baseCode) 可兑换")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.45))
                }
                Spacer()
                Text("ECB · \(currency.rateDate)")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(.white.opacity(0.36))
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(currency.matrix.prefix(4)) { item in
                    VStack(alignment: .leading, spacing: 3) {
                        Text(item.code)
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white.opacity(0.42))
                        Text(rateText(item.value))
                            .font(.headline)
                            .fontWeight(.black)
                            .monospacedDigit()
                            .minimumScaleFactor(0.7)
                            .lineLimit(1)
                        miniChange(item.changePercentage)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(9)
                    .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 14))
                }
            }
        }
        .padding(17)
        .foregroundStyle(.white)
    }

    private var travelConverter: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack {
                Image(systemName: "airplane.departure")
                    .foregroundStyle(Color("AuroraCoral"))
                Text("旅行换算")
                    .font(.caption)
                    .fontWeight(.bold)
                Spacer()
            }

            Spacer()

            Text("\(amountText(currency.amount)) \(currency.baseCode)")
                .font(.caption)
                .foregroundStyle(Color("PlumInk").opacity(0.5))

            HStack(alignment: .firstTextBaseline, spacing: 5) {
                Text(amountText(currency.amount * currency.rate))
                    .font(.system(size: size == .small ? 36 : 50, weight: .black, design: .rounded))
                    .fontWidth(.condensed)
                    .monospacedDigit()
                    .minimumScaleFactor(0.55)
                    .lineLimit(1)
                Text(currency.quoteCode)
                    .font(.headline)
            }

            HStack {
                Text("参考 \(rateText(currency.rate))")
                Spacer()
                Text("ECB \(currency.rateDate)")
            }
            .font(.caption2)
            .foregroundStyle(Color("PlumInk").opacity(0.46))
        }
        .padding(size == .small ? 15 : 18)
        .foregroundStyle(Color("PlumInk"))
    }

    private var goldSpot: some View {
        HStack(spacing: size == .small ? 0 : 18) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "seal.fill")
                        .foregroundStyle(Color("ButterGlow"))
                    Text("XAU · 黄金")
                        .font(.caption)
                        .fontWeight(.bold)
                }

                Spacer()

                Text("$\(priceText(gold.goldPrice))")
                    .font(.system(size: size == .small ? 33 : 46, weight: .black, design: .rounded))
                    .fontWidth(.condensed)
                    .monospacedDigit()
                    .minimumScaleFactor(0.55)
                    .lineLimit(1)
                Text("美元 / 盎司")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.45))
                changeLabel(gold.changePercentage, onDark: true)
            }

            if size != .small {
                Spacer()
                VStack(spacing: 6) {
                    ZStack {
                        Circle()
                            .fill(Color("ButterGlow").opacity(0.16))
                        Circle()
                            .stroke(Color("ButterGlow"), lineWidth: 2)
                            .padding(10)
                        Text("Au")
                            .font(.title2)
                            .fontWeight(.black)
                            .foregroundStyle(Color("ButterGlow"))
                    }
                    .frame(width: 76, height: 76)

                    Text("≈ ¥\(priceText(gold.cnyPerGramEstimate))/克")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("ButterGlow"))
                }
            }
        }
        .padding(size == .small ? 15 : 18)
        .foregroundStyle(.white)
    }

    private var goldTrend: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("黄金近期走势")
                        .font(.headline)
                        .fontWeight(.black)
                    Text("Alpha Vantage · 参考行情")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                changeLabel(gold.changePercentage)
            }

            HStack(alignment: .firstTextBaseline, spacing: 5) {
                Text("$\(priceText(gold.goldPrice))")
                    .font(.title)
                    .fontWeight(.black)
                    .fontDesign(.rounded)
                    .monospacedDigit()
                Text("/ oz")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            FinanceSparkline(
                values: gold.history,
                color: Color("ButterGlow"),
                fill: Color("ButterGlow").opacity(0.16)
            )
            .frame(height: size == .large ? 150 : 62)

            HStack {
                Text("近期")
                Spacer()
                Text(gold.updatedLabel)
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
        .padding(17)
        .foregroundStyle(Color("PlumInk"))
    }

    private var metalsDuo: some View {
        HStack(spacing: 10) {
            metalCard(
                name: "黄金",
                symbol: "Au",
                price: gold.goldPrice,
                tint: Color("ButterGlow")
            )
            metalCard(
                name: "白银",
                symbol: "Ag",
                price: gold.silverPrice,
                tint: Color("SkyGlow")
            )
        }
        .padding(14)
        .foregroundStyle(.white)
    }

    private var stockQuote: some View {
        Group {
            if let quote = stocks.quotes.first {
                VStack(alignment: .leading, spacing: 7) {
                    HStack {
                        VStack(alignment: .leading, spacing: 1) {
                            Text(quote.symbol)
                                .font(.headline)
                                .fontWeight(.black)
                            Text(quote.displayName)
                                .font(.caption2)
                                .foregroundStyle(.white.opacity(0.44))
                                .lineLimit(1)
                        }
                        Spacer()
                        Image(systemName: quote.change >= 0 ? "arrow.up.right" : "arrow.down.right")
                            .font(.headline)
                            .foregroundStyle(marketColor(quote.change))
                    }

                    Spacer()

                    Text("\(currencySymbol(quote.currency))\(priceText(quote.price))")
                        .font(.system(size: size == .small ? 38 : 50, weight: .black, design: .rounded))
                        .fontWidth(.condensed)
                        .monospacedDigit()
                        .minimumScaleFactor(0.55)
                        .lineLimit(1)

                    HStack {
                        Text(signedPercentage(quote.changePercentage))
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(marketColor(quote.change))
                        Spacer()
                        Text(quote.latestTradingDay)
                            .font(.system(size: 8))
                            .foregroundStyle(.white.opacity(0.36))
                    }

                    FinanceSparkline(
                        values: quote.history,
                        color: marketColor(quote.change),
                        fill: marketColor(quote.change).opacity(0.12)
                    )
                    .frame(height: size == .small ? 28 : 42)
                }
            }
        }
        .padding(size == .small ? 15 : 18)
        .foregroundStyle(.white)
    }

    private var watchlistBento: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack {
                Text("自选股")
                    .font(.headline)
                    .fontWeight(.black)
                Spacer()
                Text("最新收盘 · 仅供参考")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(.secondary)
            }

            ForEach(stocks.quotes.prefix(3)) { quote in
                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 1) {
                        Text(quote.symbol)
                            .font(.caption)
                            .fontWeight(.black)
                        Text(quote.displayName)
                            .font(.system(size: 8))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    .frame(width: 72, alignment: .leading)

                    FinanceSparkline(
                        values: quote.history,
                        color: marketColor(quote.change),
                        fill: marketColor(quote.change).opacity(0.08)
                    )
                    .frame(height: 26)

                    VStack(alignment: .trailing, spacing: 1) {
                        Text("\(currencySymbol(quote.currency))\(priceText(quote.price))")
                            .font(.caption)
                            .fontWeight(.bold)
                            .monospacedDigit()
                        Text(signedPercentage(quote.changePercentage))
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(marketColor(quote.change))
                    }
                    .frame(width: 72, alignment: .trailing)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, size == .large ? 12 : 7)
                .background(Color.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(15)
        .foregroundStyle(Color("PlumInk"))
    }

    private var dualMarket: some View {
        HStack(spacing: 10) {
            ForEach(Array(stocks.quotes.prefix(2))) { quote in
                VStack(alignment: .leading, spacing: 7) {
                    HStack {
                        Text(quote.currency == "HKD" ? "港股" : "美股")
                            .font(.system(size: 8, weight: .black))
                            .tracking(1)
                            .foregroundStyle(.white.opacity(0.36))
                        Spacer()
                        Circle()
                            .fill(marketColor(quote.change))
                            .frame(width: 7, height: 7)
                    }
                    Text(quote.symbol)
                        .font(.headline)
                        .fontWeight(.black)
                    Text(quote.displayName)
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.45))
                        .lineLimit(1)

                    Spacer()

                    Text("\(currencySymbol(quote.currency))\(priceText(quote.price))")
                        .font(size == .large ? .title : .title3)
                        .fontWeight(.black)
                        .monospacedDigit()
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                    Text(signedPercentage(quote.changePercentage))
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(marketColor(quote.change))

                    FinanceSparkline(
                        values: quote.history,
                        color: marketColor(quote.change),
                        fill: marketColor(quote.change).opacity(0.1)
                    )
                    .frame(height: size == .large ? 85 : 35)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(13)
                .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 18))
            }
        }
        .padding(14)
        .foregroundStyle(.white)
    }

    private func metalCard(name: String, symbol: String, price: Double?, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                Text(symbol)
                    .font(.headline)
                    .fontWeight(.black)
                    .foregroundStyle(tint)
                Spacer()
                Image(systemName: "seal.fill")
                    .foregroundStyle(tint.opacity(0.72))
            }
            Spacer()
            Text(name)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.44))
            Text("$\(priceText(price))")
                .font(.title3)
                .fontWeight(.black)
                .monospacedDigit()
                .minimumScaleFactor(0.6)
                .lineLimit(1)
            Text("USD / 盎司")
                .font(.system(size: 8))
                .foregroundStyle(.white.opacity(0.36))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(13)
        .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 18))
    }

    private func unavailable(_ message: String?) -> some View {
        VStack(spacing: 9) {
            Image(systemName: "chart.line.downtrend.xyaxis")
                .font(.title2)
                .foregroundStyle(Color("AuroraCoral"))
            Text("行情暂时不可用")
                .font(.headline)
            Text(message ?? "请检查组件配置和网络")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .foregroundStyle(Color("PlumInk"))
    }

    private func changeLabel(_ value: Double?, onDark: Bool = false) -> some View {
        let change = value ?? 0
        return Label(
            signedPercentage(change),
            systemImage: change >= 0 ? "arrow.up.right" : "arrow.down.right"
        )
        .font(.caption2)
        .fontWeight(.bold)
        .foregroundStyle(onDark ? marketColor(change) : marketColor(change))
    }

    private func miniChange(_ value: Double?) -> some View {
        Text(signedPercentage(value ?? 0))
            .font(.system(size: 8, weight: .bold))
            .foregroundStyle(marketColor(value ?? 0))
    }

    private func marketColor(_ value: Double) -> Color {
        value >= 0 ? Color("AuroraCoral") : Color("SeaGlass")
    }

    private func rateText(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(value >= 100 ? 2 : 4)))
    }

    private func amountText(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(value.rounded() == value ? 0 : 2)))
    }

    private func priceText(_ value: Double?) -> String {
        guard let value else { return "—" }
        return value.formatted(.number.precision(.fractionLength(2)))
    }

    private func signedPercentage(_ value: Double) -> String {
        let sign = value >= 0 ? "+" : ""
        return "\(sign)\(value.formatted(.number.precision(.fractionLength(2))))%"
    }

    private func currencySymbol(_ currency: String) -> String {
        switch currency.uppercased() {
        case "HKD": "HK$"
        case "CNY": "¥"
        case "EUR": "€"
        case "GBP": "£"
        default: "$"
        }
    }
}

private struct FinanceSparkline: View {
    let values: [Double]
    let color: Color
    let fill: Color

    var body: some View {
        GeometryReader { proxy in
            let points = normalizedPoints(in: proxy.size)

            ZStack {
                if points.count > 1 {
                    Path { path in
                        path.move(to: CGPoint(x: points[0].x, y: proxy.size.height))
                        for point in points {
                            path.addLine(to: point)
                        }
                        path.addLine(to: CGPoint(x: points[points.count - 1].x, y: proxy.size.height))
                        path.closeSubpath()
                    }
                    .fill(fill)

                    Path { path in
                        path.move(to: points[0])
                        for point in points.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                    .stroke(color, style: StrokeStyle(lineWidth: 2.2, lineCap: .round, lineJoin: .round))
                } else {
                    Capsule()
                        .fill(color.opacity(0.25))
                        .frame(height: 2)
                }
            }
        }
    }

    private func normalizedPoints(in size: CGSize) -> [CGPoint] {
        guard values.count > 1, let minimum = values.min(), let maximum = values.max() else {
            return []
        }
        let range = max(maximum - minimum, 0.000_001)
        return values.enumerated().map { index, value in
            let x = size.width * CGFloat(index) / CGFloat(values.count - 1)
            let normalized = (value - minimum) / range
            let y = size.height * (1 - CGFloat(normalized) * 0.82) - size.height * 0.09
            return CGPoint(x: x, y: y)
        }
    }
}
