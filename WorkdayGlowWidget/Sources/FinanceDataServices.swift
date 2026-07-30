import Foundation

enum FinanceDataCache {
    static func load<Value: Decodable>(_ type: Value.Type, key: String) -> Value? {
        guard let data = UserDefaults.standard.data(forKey: cacheKey(key)) else {
            return nil
        }
        return try? JSONDecoder().decode(type, from: data)
    }

    static func save<Value: Encodable>(_ value: Value, key: String) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        UserDefaults.standard.set(data, forKey: cacheKey(key))
    }

    private static func cacheKey(_ key: String) -> String {
        "finance.cache.\(key.lowercased())"
    }
}

final class ECBExchangeRateService {
    func fetch(
        base: ExchangeCurrency,
        quote: ExchangeCurrency,
        amount: Double
    ) async throws -> CurrencyWidgetData {
        let requestedCodes = Set([
            base.rawValue,
            quote.rawValue,
            ExchangeCurrency.CNY.rawValue,
            ExchangeCurrency.HKD.rawValue,
            ExchangeCurrency.JPY.rawValue,
            ExchangeCurrency.EUR.rawValue
        ])
        let apiCodes = requestedCodes.filter { $0 != ExchangeCurrency.EUR.rawValue }.sorted()
        let codePath = apiCodes.joined(separator: "+")

        guard var components = URLComponents(
            string: "https://data-api.ecb.europa.eu/service/data/EXR/D.\(codePath).EUR.SP00.A"
        ) else {
            throw FinanceServiceError.invalidURL
        }
        components.queryItems = [
            URLQueryItem(name: "lastNObservations", value: "8"),
            URLQueryItem(name: "format", value: "csvdata")
        ]
        guard let url = components.url else {
            throw FinanceServiceError.invalidURL
        }

        let data = try await request(url)
        guard let csv = String(data: data, encoding: .utf8) else {
            throw FinanceServiceError.invalidResponse
        }
        let series = try parseECBSeries(csv)
        let pairHistory = rateHistory(
            base: base.rawValue,
            quote: quote.rawValue,
            series: series
        )
        guard let latest = pairHistory.last else {
            throw FinanceServiceError.noData
        }
        let previous = pairHistory.dropLast().last?.value
        let change = percentageChange(current: latest.value, previous: previous)
        let matrixCodes = ["CNY", "HKD", "JPY", "EUR"]
        let matrix = matrixCodes.compactMap { code -> CurrencyRateItem? in
            let history = rateHistory(base: base.rawValue, quote: code, series: series)
            guard let current = history.last?.value else { return nil }
            return CurrencyRateItem(
                code: code,
                value: current,
                changePercentage: percentageChange(
                    current: current,
                    previous: history.dropLast().last?.value
                )
            )
        }

        return CurrencyWidgetData(
            isAvailable: true,
            baseCode: base.rawValue,
            quoteCode: quote.rawValue,
            amount: amount,
            rate: latest.value,
            changePercentage: change,
            matrix: matrix,
            trend: pairHistory.suffix(7).map(\.value),
            rateDate: formattedDate(latest.date),
            message: nil
        )
    }

    private func parseECBSeries(_ csv: String) throws -> [String: [DatedValue]] {
        let lines = csv.split(whereSeparator: { $0.isNewline }).map(String.init)
        guard let headerLine = lines.first else {
            throw FinanceServiceError.invalidResponse
        }
        let headers = parseCSVRow(headerLine)
        guard
            let currencyIndex = headers.firstIndex(of: "CURRENCY"),
            let dateIndex = headers.firstIndex(of: "TIME_PERIOD"),
            let valueIndex = headers.firstIndex(of: "OBS_VALUE")
        else {
            throw FinanceServiceError.invalidResponse
        }

        var result: [String: [DatedValue]] = [:]
        for line in lines.dropFirst() {
            let fields = parseCSVRow(line)
            guard
                fields.indices.contains(currencyIndex),
                fields.indices.contains(dateIndex),
                fields.indices.contains(valueIndex),
                let value = Double(fields[valueIndex])
            else {
                continue
            }
            result[fields[currencyIndex], default: []].append(
                DatedValue(date: fields[dateIndex], value: value)
            )
        }
        for code in Array(result.keys) {
            result[code]?.sort { $0.date < $1.date }
        }
        guard !result.isEmpty else {
            throw FinanceServiceError.noData
        }
        return result
    }

    private func rateHistory(
        base: String,
        quote: String,
        series: [String: [DatedValue]]
    ) -> [DatedValue] {
        let baseValues = valuesByDate(code: base, series: series)
        let quoteValues = valuesByDate(code: quote, series: series)
        let dates: [String]
        if base == "EUR" {
            dates = quoteValues.keys.sorted()
        } else if quote == "EUR" {
            dates = baseValues.keys.sorted()
        } else {
            dates = Set(baseValues.keys).intersection(quoteValues.keys).sorted()
        }

        return dates.compactMap { date in
            let basePerEuro: Double? = base == "EUR" ? 1.0 : baseValues[date]
            let quotePerEuro: Double? = quote == "EUR" ? 1.0 : quoteValues[date]
            guard
                let basePerEuro,
                let quotePerEuro,
                basePerEuro != 0
            else {
                return nil
            }
            return DatedValue(date: date, value: quotePerEuro / basePerEuro)
        }
    }

    private func valuesByDate(
        code: String,
        series: [String: [DatedValue]]
    ) -> [String: Double] {
        Dictionary(uniqueKeysWithValues: (series[code] ?? []).map { ($0.date, $0.value) })
    }

    private func parseCSVRow(_ row: String) -> [String] {
        var fields: [String] = []
        var current = ""
        var insideQuotes = false
        var index = row.startIndex

        while index < row.endIndex {
            let character = row[index]
            if character == "\"" {
                let next = row.index(after: index)
                if insideQuotes, next < row.endIndex, row[next] == "\"" {
                    current.append("\"")
                    index = next
                } else {
                    insideQuotes.toggle()
                }
            } else if character == ",", !insideQuotes {
                fields.append(current)
                current = ""
            } else {
                current.append(character)
            }
            index = row.index(after: index)
        }
        fields.append(current)
        return fields
    }

    private func formattedDate(_ rawDate: String) -> String {
        let input = DateFormatter()
        input.locale = Locale(identifier: "en_US_POSIX")
        input.dateFormat = "yyyy-MM-dd"
        guard let date = input.date(from: rawDate) else { return rawDate }

        let output = DateFormatter()
        output.locale = Locale(identifier: "zh_CN")
        output.dateFormat = "MM月dd日"
        return output.string(from: date)
    }
}

final class AlphaVantageFinanceService {
    private let session: URLSession

    init() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 30
        session = URLSession(configuration: configuration)
    }

    func fetchGold(style: GoldWidgetStyle, apiKey rawKey: String) async throws -> GoldWidgetData {
        let apiKey = try normalizedAPIKey(rawKey)

        switch style {
        case .spot:
            let gold = try await fetchMetalSpot(symbol: "GOLD", apiKey: apiKey)
            let cnyEstimate = await estimatedCNYPerGram(goldPrice: gold.price)
            return GoldWidgetData(
                isAvailable: true,
                goldPrice: gold.price,
                silverPrice: nil,
                cnyPerGramEstimate: cnyEstimate,
                changePercentage: gold.changePercentage,
                history: [],
                updatedLabel: gold.updatedLabel,
                message: nil
            )
        case .trend:
            let history = try await fetchMetalHistory(symbol: "GOLD", apiKey: apiKey)
            guard let latest = history.values.last else {
                throw FinanceServiceError.noData
            }
            return GoldWidgetData(
                isAvailable: true,
                goldPrice: latest,
                silverPrice: nil,
                cnyPerGramEstimate: await estimatedCNYPerGram(goldPrice: latest),
                changePercentage: percentageChange(
                    current: latest,
                    previous: history.values.dropLast().last
                ),
                history: Array(history.values.suffix(14)),
                updatedLabel: history.updatedLabel,
                message: nil
            )
        case .duo:
            let goldQuote = try await fetchMetalSpot(symbol: "GOLD", apiKey: apiKey)
            let silverQuote = try await fetchMetalSpot(symbol: "SILVER", apiKey: apiKey)
            return GoldWidgetData(
                isAvailable: true,
                goldPrice: goldQuote.price,
                silverPrice: silverQuote.price,
                cnyPerGramEstimate: await estimatedCNYPerGram(goldPrice: goldQuote.price),
                changePercentage: goldQuote.changePercentage,
                history: [],
                updatedLabel: goldQuote.updatedLabel,
                message: nil
            )
        }
    }

    func fetchStocks(
        symbols: [(symbol: String, name: String)],
        apiKey rawKey: String
    ) async throws -> StockWidgetData {
        let apiKey = try normalizedAPIKey(rawKey)
        let requests = symbols.map {
            (
                symbol: normalizedSymbol($0.symbol),
                name: normalizedName($0.name, fallback: normalizedSymbol($0.symbol))
            )
        }

        var quotes: [StockQuoteData] = []
        for request in requests {
            if let quote = try? await fetchStockDaily(
                symbol: request.symbol,
                displayName: request.name,
                apiKey: apiKey
            ) {
                quotes.append(quote)
            }
        }

        guard !quotes.isEmpty else {
            throw FinanceServiceError.noData
        }
        return StockWidgetData(
            quotes: quotes,
            message: quotes.count == requests.count ? nil : "部分股票代码暂时没有数据"
        )
    }

    private func fetchMetalSpot(symbol: String, apiKey: String) async throws -> MetalSpot {
        let object = try await alphaVantageJSON(
            function: "GOLD_SILVER_SPOT",
            parameters: [URLQueryItem(name: "symbol", value: symbol)],
            apiKey: apiKey
        )
        guard let price = findNumber(in: object, preferredKeys: ["price", "spot price", "value"]) else {
            throw FinanceServiceError.noData
        }
        let change = findNumber(
            in: object,
            preferredKeys: ["change percentage", "change percent", "change_percent", "percent change"]
        )
        let timestamp = findString(
            in: object,
            preferredKeys: ["timestamp", "date", "updated", "last refreshed"]
        )
        return MetalSpot(
            price: price,
            changePercentage: change,
            updatedLabel: compactTimestamp(timestamp)
        )
    }

    private func fetchMetalHistory(symbol: String, apiKey: String) async throws -> MetalHistory {
        let object = try await alphaVantageJSON(
            function: "GOLD_SILVER_HISTORY",
            parameters: [
                URLQueryItem(name: "symbol", value: symbol),
                URLQueryItem(name: "interval", value: "daily")
            ],
            apiKey: apiKey
        )
        let datedValues = extractDatedValues(from: object)
        guard !datedValues.isEmpty else {
            throw FinanceServiceError.noData
        }
        let sorted = datedValues.sorted { $0.date < $1.date }
        return MetalHistory(
            values: sorted.map(\.value),
            updatedLabel: compactTimestamp(sorted.last?.date)
        )
    }

    private func fetchStockDaily(
        symbol: String,
        displayName: String,
        apiKey: String
    ) async throws -> StockQuoteData {
        let object = try await alphaVantageJSON(
            function: "TIME_SERIES_DAILY",
            parameters: [
                URLQueryItem(name: "symbol", value: symbol),
                URLQueryItem(name: "outputsize", value: "compact")
            ],
            apiKey: apiKey
        )
        guard
            let timeSeries = object.first(where: {
                $0.key.localizedCaseInsensitiveContains("time series")
            })?.value as? [String: Any]
        else {
            throw FinanceServiceError.noData
        }

        let values = timeSeries.compactMap { date, rawValue -> DatedValue? in
            guard
                let daily = rawValue as? [String: Any],
                let close = number(in: daily, keys: ["4. close", "close"])
            else {
                return nil
            }
            return DatedValue(date: date, value: close)
        }
        .sorted { $0.date < $1.date }

        guard let latest = values.last else {
            throw FinanceServiceError.noData
        }
        let previous = values.dropLast().last?.value ?? latest.value
        let change = latest.value - previous
        let percentage = previous == 0 ? 0 : change / previous * 100

        return StockQuoteData(
            symbol: symbol,
            displayName: displayName,
            currency: inferredCurrency(symbol),
            price: latest.value,
            change: change,
            changePercentage: percentage,
            history: Array(values.suffix(14).map(\.value)),
            latestTradingDay: "\(compactTimestamp(latest.date))收盘",
            isAvailable: true
        )
    }

    private func alphaVantageJSON(
        function: String,
        parameters: [URLQueryItem],
        apiKey: String
    ) async throws -> [String: Any] {
        var components = URLComponents(string: "https://www.alphavantage.co/query")
        components?.queryItems = [
            URLQueryItem(name: "function", value: function)
        ] + parameters + [
            URLQueryItem(name: "apikey", value: apiKey)
        ]
        guard let url = components?.url else {
            throw FinanceServiceError.invalidURL
        }

        let (data, response) = try await session.data(from: url)
        try validate(response)
        guard let object = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw FinanceServiceError.invalidResponse
        }
        if let message = errorMessage(in: object) {
            throw FinanceServiceError.provider(message)
        }
        return object
    }

    private func estimatedCNYPerGram(goldPrice: Double) async -> Double? {
        guard
            let exchange = try? await ECBExchangeRateService().fetch(
                base: .USD,
                quote: .CNY,
                amount: 1
            )
        else {
            return nil
        }
        return goldPrice * exchange.rate / 31.103_476_8
    }

    private func extractDatedValues(from object: [String: Any]) -> [DatedValue] {
        if let data = object["data"] as? [[String: Any]] {
            return data.compactMap { row in
                guard
                    let date = string(in: row, keys: ["date", "timestamp", "time"]),
                    let value = number(in: row, keys: ["value", "price", "close"])
                else {
                    return nil
                }
                return DatedValue(date: date, value: value)
            }
        }

        for rawValue in object.values {
            guard let dictionary = rawValue as? [String: Any] else { continue }
            let values = dictionary.compactMap { date, entry -> DatedValue? in
                if let row = entry as? [String: Any],
                   let value = number(in: row, keys: ["value", "price", "4. close", "close"]) {
                    return DatedValue(date: date, value: value)
                }
                if let value = numericValue(entry) {
                    return DatedValue(date: date, value: value)
                }
                return nil
            }
            if !values.isEmpty {
                return values
            }
        }
        return []
    }

    private func findNumber(in object: Any, preferredKeys: [String]) -> Double? {
        if let dictionary = object as? [String: Any] {
            for preferredKey in preferredKeys {
                if let match = dictionary.first(where: {
                    normalizedKey($0.key) == normalizedKey(preferredKey)
                }), let value = numericValue(match.value) {
                    return value
                }
            }
            for preferredKey in preferredKeys {
                if let match = dictionary.first(where: {
                    normalizedKey($0.key).contains(normalizedKey(preferredKey))
                }), let value = numericValue(match.value) {
                    return value
                }
            }
            for value in dictionary.values {
                if let result = findNumber(in: value, preferredKeys: preferredKeys) {
                    return result
                }
            }
        } else if let array = object as? [Any] {
            for value in array {
                if let result = findNumber(in: value, preferredKeys: preferredKeys) {
                    return result
                }
            }
        }
        return nil
    }

    private func findString(in object: Any, preferredKeys: [String]) -> String? {
        if let dictionary = object as? [String: Any] {
            for preferredKey in preferredKeys {
                if let match = dictionary.first(where: {
                    normalizedKey($0.key).contains(normalizedKey(preferredKey))
                }), let value = match.value as? String {
                    return value
                }
            }
            for value in dictionary.values {
                if let result = findString(in: value, preferredKeys: preferredKeys) {
                    return result
                }
            }
        } else if let array = object as? [Any] {
            for value in array {
                if let result = findString(in: value, preferredKeys: preferredKeys) {
                    return result
                }
            }
        }
        return nil
    }

    private func errorMessage(in object: [String: Any]) -> String? {
        for key in ["Error Message", "Information", "Note"] {
            if let message = object[key] as? String {
                if message.localizedCaseInsensitiveContains("rate limit") ||
                    message.localizedCaseInsensitiveContains("frequency") {
                    return "免费 API 调用次数已达到限制，请稍后再试"
                }
                return message
            }
        }
        return nil
    }

    private func normalizedAPIKey(_ rawKey: String) throws -> String {
        let key = rawKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !key.isEmpty else {
            throw FinanceServiceError.missingAPIKey
        }
        return key
    }

    private func normalizedSymbol(_ rawSymbol: String) -> String {
        let value = rawSymbol.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        return value.isEmpty ? "AAPL" : value
    }

    private func normalizedName(_ rawName: String, fallback: String) -> String {
        let value = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
        return value.isEmpty ? fallback : value
    }

    private func inferredCurrency(_ symbol: String) -> String {
        let upper = symbol.uppercased()
        if upper.hasSuffix(".HKG") || upper.hasSuffix(".HK") {
            return "HKD"
        }
        if upper.hasSuffix(".LON") {
            return "GBP"
        }
        return "USD"
    }

    private func compactTimestamp(_ rawValue: String?) -> String {
        guard let rawValue, !rawValue.isEmpty else {
            return Date.now.formatted(.dateTime.hour().minute()) + " 更新"
        }
        let datePart = String(rawValue.prefix(10))
        let input = DateFormatter()
        input.locale = Locale(identifier: "en_US_POSIX")
        input.dateFormat = "yyyy-MM-dd"
        guard let date = input.date(from: datePart) else {
            return String(rawValue.prefix(16))
        }
        let output = DateFormatter()
        output.locale = Locale(identifier: "zh_CN")
        output.dateFormat = "MM月dd日"
        return output.string(from: date)
    }

    private func number(in dictionary: [String: Any], keys: [String]) -> Double? {
        for key in keys {
            if let match = dictionary.first(where: {
                normalizedKey($0.key) == normalizedKey(key)
            }), let value = numericValue(match.value) {
                return value
            }
        }
        return nil
    }

    private func string(in dictionary: [String: Any], keys: [String]) -> String? {
        for key in keys {
            if let match = dictionary.first(where: {
                normalizedKey($0.key) == normalizedKey(key)
            }), let value = match.value as? String {
                return value
            }
        }
        return nil
    }

    private func numericValue(_ rawValue: Any) -> Double? {
        if let value = rawValue as? Double {
            return value
        }
        if let value = rawValue as? NSNumber {
            return value.doubleValue
        }
        if let value = rawValue as? String {
            let cleaned = value
                .replacingOccurrences(of: "%", with: "")
                .replacingOccurrences(of: ",", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            return Double(cleaned)
        }
        return nil
    }

    private func normalizedKey(_ key: String) -> String {
        key.lowercased()
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "-", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func validate(_ response: URLResponse) throws {
        guard
            let httpResponse = response as? HTTPURLResponse,
            200..<300 ~= httpResponse.statusCode
        else {
            throw FinanceServiceError.invalidResponse
        }
    }
}

struct DatedValue {
    let date: String
    let value: Double
}

private struct MetalSpot {
    let price: Double
    let changePercentage: Double?
    let updatedLabel: String
}

private struct MetalHistory {
    let values: [Double]
    let updatedLabel: String
}

enum FinanceServiceError: LocalizedError {
    case invalidURL
    case invalidResponse
    case noData
    case missingAPIKey
    case provider(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "行情地址无效"
        case .invalidResponse:
            "行情服务返回了无法识别的数据"
        case .noData:
            "没有找到对应行情，请检查代码或稍后再试"
        case .missingAPIKey:
            "请长按组件，在编辑页填写 Alpha Vantage API Key"
        case .provider(let message):
            message
        }
    }
}

private func request(_ url: URL) async throws -> Data {
    var request = URLRequest(url: url)
    request.timeoutInterval = 25
    request.cachePolicy = .reloadIgnoringLocalCacheData
    let (data, response) = try await URLSession.shared.data(for: request)
    guard
        let httpResponse = response as? HTTPURLResponse,
        200..<300 ~= httpResponse.statusCode
    else {
        throw FinanceServiceError.invalidResponse
    }
    return data
}

private func percentageChange(current: Double, previous: Double?) -> Double? {
    guard let previous, previous != 0 else { return nil }
    return (current / previous - 1) * 100
}
