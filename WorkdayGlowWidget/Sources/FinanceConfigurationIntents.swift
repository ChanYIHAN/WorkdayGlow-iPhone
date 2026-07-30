import AppIntents
import Foundation

enum ExchangeCurrency: String, AppEnum {
    case CNY
    case USD
    case HKD
    case EUR
    case JPY
    case GBP
    case AUD
    case CAD
    case CHF
    case SGD

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "货币"
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .CNY: "人民币 CNY",
        .USD: "美元 USD",
        .HKD: "港币 HKD",
        .EUR: "欧元 EUR",
        .JPY: "日元 JPY",
        .GBP: "英镑 GBP",
        .AUD: "澳元 AUD",
        .CAD: "加元 CAD",
        .CHF: "瑞士法郎 CHF",
        .SGD: "新加坡元 SGD"
    ]
}

enum CurrencyWidgetStyle: String, AppEnum {
    case minimal
    case matrix
    case travel

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "汇率样式"
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .minimal: "极简汇率",
        .matrix: "汇率矩阵",
        .travel: "旅行换算"
    ]

    var template: WidgetTemplateKind {
        switch self {
        case .minimal: .currencyMinimal
        case .matrix: .currencyMatrix
        case .travel: .travelConverter
        }
    }
}

struct CurrencyWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "设置汇率换算"
    static var description = IntentDescription(
        "选择基准货币、目标货币与显示样式。数据来自 ECB 每日参考汇率。"
    )

    @Parameter(title: "样式", default: .minimal)
    var style: CurrencyWidgetStyle

    @Parameter(title: "基准货币", default: .USD)
    var baseCurrency: ExchangeCurrency

    @Parameter(title: "目标货币", default: .CNY)
    var quoteCurrency: ExchangeCurrency

    @Parameter(title: "换算金额", default: 100, inclusiveRange: (1, 1_000_000))
    var amount: Double
}

enum GoldWidgetStyle: String, AppEnum {
    case spot
    case trend
    case duo

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "黄金样式"
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .spot: "黄金现货",
        .trend: "金价曲线",
        .duo: "金银双卡"
    ]

    var template: WidgetTemplateKind {
        switch self {
        case .spot: .goldSpot
        case .trend: .goldTrend
        case .duo: .metalsDuo
        }
    }
}

struct GoldWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "设置黄金价格"
    static var description = IntentDescription(
        "填写你自己的 Alpha Vantage 免费 API Key。Key 由 iOS 保存在这个组件的配置中。"
    )

    @Parameter(title: "样式", default: .spot)
    var style: GoldWidgetStyle

    @Parameter(title: "Alpha Vantage API Key", default: "")
    var apiKey: String
}

enum StockWidgetStyle: String, AppEnum {
    case quote
    case watchlist
    case dual

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "股票样式"
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .quote: "单股行情",
        .watchlist: "自选股便当",
        .dual: "港美双市场"
    ]

    var template: WidgetTemplateKind {
        switch self {
        case .quote: .stockQuote
        case .watchlist: .watchlistBento
        case .dual: .dualMarket
        }
    }
}

struct StockWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "设置港美股行情"
    static var description = IntentDescription(
        "免费模式显示 Alpha Vantage 最新日线收盘数据，不是实时交易行情。"
    )

    @Parameter(title: "样式", default: .watchlist)
    var style: StockWidgetStyle

    @Parameter(title: "Alpha Vantage API Key", default: "")
    var apiKey: String

    @Parameter(title: "股票一代码", default: "AAPL")
    var firstSymbol: String

    @Parameter(title: "股票一名称", default: "Apple")
    var firstName: String

    @Parameter(title: "股票二代码", default: "NVDA")
    var secondSymbol: String

    @Parameter(title: "股票二名称", default: "NVIDIA")
    var secondName: String

    @Parameter(title: "股票三代码", default: "0700.HKG")
    var thirdSymbol: String

    @Parameter(title: "股票三名称", default: "腾讯控股")
    var thirdName: String
}
