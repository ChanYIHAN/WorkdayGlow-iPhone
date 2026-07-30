import Foundation

struct CurrencyRateItem: Identifiable, Codable, Sendable {
    let code: String
    let value: Double
    let changePercentage: Double?

    var id: String { code }
}

struct CurrencyWidgetData: Codable, Sendable {
    let isAvailable: Bool
    let baseCode: String
    let quoteCode: String
    let amount: Double
    let rate: Double
    let changePercentage: Double?
    let matrix: [CurrencyRateItem]
    let trend: [Double]
    let rateDate: String
    let message: String?

    static let preview = CurrencyWidgetData(
        isAvailable: true,
        baseCode: "USD",
        quoteCode: "CNY",
        amount: 100,
        rate: 7.1836,
        changePercentage: 0.18,
        matrix: [
            CurrencyRateItem(code: "CNY", value: 7.1836, changePercentage: 0.18),
            CurrencyRateItem(code: "HKD", value: 7.8124, changePercentage: 0.04),
            CurrencyRateItem(code: "JPY", value: 151.42, changePercentage: -0.32),
            CurrencyRateItem(code: "EUR", value: 0.8628, changePercentage: -0.11)
        ],
        trend: [7.12, 7.15, 7.14, 7.17, 7.16, 7.19, 7.1836],
        rateDate: "07月30日",
        message: nil
    )

    static func unavailable(
        baseCode: String,
        quoteCode: String,
        amount: Double,
        message: String
    ) -> CurrencyWidgetData {
        CurrencyWidgetData(
            isAvailable: false,
            baseCode: baseCode,
            quoteCode: quoteCode,
            amount: amount,
            rate: 0,
            changePercentage: nil,
            matrix: [],
            trend: [],
            rateDate: "暂无数据",
            message: message
        )
    }
}

struct GoldWidgetData: Codable, Sendable {
    let isAvailable: Bool
    let goldPrice: Double?
    let silverPrice: Double?
    let cnyPerGramEstimate: Double?
    let changePercentage: Double?
    let history: [Double]
    let updatedLabel: String
    let message: String?

    static let preview = GoldWidgetData(
        isAvailable: true,
        goldPrice: 3_348.72,
        silverPrice: 38.41,
        cnyPerGramEstimate: 773.46,
        changePercentage: 0.62,
        history: [3_286, 3_301, 3_294, 3_322, 3_315, 3_337, 3_348.72],
        updatedLabel: "18:00 更新",
        message: nil
    )

    static func unavailable(_ message: String) -> GoldWidgetData {
        GoldWidgetData(
            isAvailable: false,
            goldPrice: nil,
            silverPrice: nil,
            cnyPerGramEstimate: nil,
            changePercentage: nil,
            history: [],
            updatedLabel: "暂无数据",
            message: message
        )
    }
}

struct StockQuoteData: Identifiable, Codable, Sendable {
    let symbol: String
    let displayName: String
    let currency: String
    let price: Double
    let change: Double
    let changePercentage: Double
    let history: [Double]
    let latestTradingDay: String
    let isAvailable: Bool

    var id: String { symbol }
}

struct StockWidgetData: Codable, Sendable {
    let quotes: [StockQuoteData]
    let message: String?

    var isAvailable: Bool {
        quotes.contains(where: { $0.isAvailable })
    }

    static let preview = StockWidgetData(
        quotes: [
            StockQuoteData(
                symbol: "AAPL",
                displayName: "Apple",
                currency: "USD",
                price: 211.18,
                change: 2.84,
                changePercentage: 1.36,
                history: [202, 205, 203, 207, 209, 208, 211.18],
                latestTradingDay: "07月30日收盘",
                isAvailable: true
            ),
            StockQuoteData(
                symbol: "NVDA",
                displayName: "NVIDIA",
                currency: "USD",
                price: 181.62,
                change: -1.44,
                changePercentage: -0.79,
                history: [177, 180, 184, 182, 185, 183, 181.62],
                latestTradingDay: "07月30日收盘",
                isAvailable: true
            ),
            StockQuoteData(
                symbol: "0700.HKG",
                displayName: "腾讯控股",
                currency: "HKD",
                price: 558.50,
                change: 4.50,
                changePercentage: 0.81,
                history: [542, 548, 551, 547, 554, 556, 558.5],
                latestTradingDay: "07月30日收盘",
                isAvailable: true
            )
        ],
        message: nil
    )

    static func unavailable(_ message: String) -> StockWidgetData {
        StockWidgetData(quotes: [], message: message)
    }
}
