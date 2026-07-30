import Foundation

enum WidgetTemplateCategory: String, CaseIterable, Identifiable, Sendable {
    case featured
    case countdown
    case income
    case rhythm
    case health
    case weather
    case love
    case time
    case tools
    case photos
    case music
    case finance

    var id: String { rawValue }

    var title: String {
        switch self {
        case .featured: "精选"
        case .countdown: "下班"
        case .income: "收入"
        case .rhythm: "节奏"
        case .health: "健康"
        case .weather: "天气"
        case .love: "恋爱"
        case .time: "时间"
        case .tools: "工具"
        case .photos: "相册"
        case .music: "音乐"
        case .finance: "行情"
        }
    }

    var symbolName: String {
        switch self {
        case .featured: "sparkles"
        case .countdown: "hourglass"
        case .income: "banknote.fill"
        case .rhythm: "calendar"
        case .health: "heart.fill"
        case .weather: "cloud.sun.fill"
        case .love: "heart.circle.fill"
        case .time: "clock.fill"
        case .tools: "switch.2"
        case .photos: "photo.on.rectangle.angled"
        case .music: "music.note"
        case .finance: "chart.line.uptrend.xyaxis"
        }
    }
}

enum WidgetArtworkSize: String, CaseIterable, Identifiable, Sendable {
    case small
    case medium
    case large

    var id: String { rawValue }

    var title: String {
        switch self {
        case .small: "小号"
        case .medium: "中号"
        case .large: "大号"
        }
    }
}

enum WidgetTemplateKind: String, CaseIterable, Identifiable, Hashable, Sendable {
    case workdayRail
    case minimalCountdown
    case incomeBento
    case weekRhythm
    case progressOrbit
    case paydayCalendar
    case afterworkPlan
    case healthBento
    case sleepRibbon
    case oxygenPulse
    case weatherNow
    case weatherHourly
    case weatherMinimal
    case loveDays
    case loveOrbit
    case editorialClock
    case worldClock
    case calendarClock
    case controlDeck
    case shortcutStack
    case focusConsole
    case photoPolaroid
    case photoFilmstrip
    case photoMosaic
    case musicVinyl
    case musicGlass
    case musicWave
    case currencyMinimal
    case currencyMatrix
    case travelConverter
    case goldSpot
    case goldTrend
    case metalsDuo
    case stockQuote
    case watchlistBento
    case dualMarket

    var id: String { rawValue }

    var title: String {
        switch self {
        case .workdayRail: "光轨倒计时"
        case .minimalCountdown: "极简倒计时"
        case .incomeBento: "收入便当"
        case .weekRhythm: "本周节奏"
        case .progressOrbit: "进度轨道"
        case .paydayCalendar: "发薪月历"
        case .afterworkPlan: "今晚提案"
        case .healthBento: "健康便当"
        case .sleepRibbon: "睡眠丝带"
        case .oxygenPulse: "血氧脉冲"
        case .weatherNow: "天气画布"
        case .weatherHourly: "逐时天气"
        case .weatherMinimal: "极简天气"
        case .loveDays: "恋爱天数"
        case .loveOrbit: "纪念日轨道"
        case .editorialClock: "编辑部时钟"
        case .worldClock: "世界时间"
        case .calendarClock: "日历时钟"
        case .controlDeck: "灵动控制台"
        case .shortcutStack: "快捷开关"
        case .focusConsole: "专注控制舱"
        case .photoPolaroid: "拍立得记忆"
        case .photoFilmstrip: "胶片时刻"
        case .photoMosaic: "三格相册"
        case .musicVinyl: "黑胶唱片"
        case .musicGlass: "玻璃播放器"
        case .musicWave: "声波胶囊"
        case .currencyMinimal: "极简汇率"
        case .currencyMatrix: "汇率矩阵"
        case .travelConverter: "旅行换算"
        case .goldSpot: "黄金现货"
        case .goldTrend: "金价曲线"
        case .metalsDuo: "金银双卡"
        case .stockQuote: "单股行情"
        case .watchlistBento: "自选股便当"
        case .dualMarket: "港美双市场"
        }
    }

    var subtitle: String {
        switch self {
        case .workdayRail: "下班、收入与发薪日，一眼看全"
        case .minimalCountdown: "克制的留白，只保留最重要的时间"
        case .incomeBento: "把今日收入与发薪进度装进便当格"
        case .weekRhythm: "看见一周走到了哪里，也看见周末"
        case .progressOrbit: "用双环展示工作与本月的完成度"
        case .paydayCalendar: "发薪日高亮，月底不再靠心算"
        case .afterworkPlan: "给今天一个轻松、有趣的收尾"
        case .healthBento: "心率、睡眠与血氧的柔和数据面板"
        case .sleepRibbon: "把昨夜睡眠画成安静流动的丝带"
        case .oxygenPulse: "突出最近一次血氧与心率记录"
        case .weatherNow: "像一张天空海报一样展示当前天气"
        case .weatherHourly: "未来六小时的温度与降雨概率"
        case .weatherMinimal: "克制、清晰，只留下出门所需信息"
        case .loveDays: "记录我们在一起的每一个普通日子"
        case .loveOrbit: "距离下一个周年纪念日还有多远"
        case .editorialClock: "杂志感大字时间与当天日期"
        case .worldClock: "同时关注三座城市的此刻"
        case .calendarClock: "时间、星期与月历合在一张卡片里"
        case .controlDeck: "四个系统快捷指令入口，像控制中心一样利落"
        case .shortcutStack: "把常用连接开关收进一张轻盈的小卡片"
        case .focusConsole: "快速进入飞行、专注与离线时刻"
        case .photoPolaroid: "一张照片、一句小字，留住今天的心情"
        case .photoFilmstrip: "用胶片边框收藏一段值得反复看的画面"
        case .photoMosaic: "三格错落排版，让桌面变成私人画廊"
        case .musicVinyl: "黑胶唱片与专辑信息组成的复古音乐卡"
        case .musicGlass: "通透渐变、专辑封面与播放入口"
        case .musicWave: "把歌名与声波做成克制的小号组件"
        case .currencyMinimal: "一个汇率、一眼读懂，使用 ECB 每日参考数据"
        case .currencyMatrix: "常用币种并排呈现，跨境消费更从容"
        case .travelConverter: "输入金额，把旅行预算直接换算到桌面"
        case .goldSpot: "国际黄金价格与人民币每克估值"
        case .goldTrend: "用柔和曲线查看近期黄金方向"
        case .metalsDuo: "黄金与白银价格放在同一张资产卡片"
        case .stockQuote: "突出一只港股或美股的最新收盘表现"
        case .watchlistBento: "三只自选股的收盘价格与涨跌幅"
        case .dualMarket: "港股与美股各选一只，跨市场对照"
        }
    }

    var category: WidgetTemplateCategory {
        switch self {
        case .workdayRail, .minimalCountdown, .afterworkPlan:
            .countdown
        case .incomeBento, .paydayCalendar:
            .income
        case .weekRhythm, .progressOrbit:
            .rhythm
        case .healthBento, .sleepRibbon, .oxygenPulse:
            .health
        case .weatherNow, .weatherHourly, .weatherMinimal:
            .weather
        case .loveDays, .loveOrbit:
            .love
        case .editorialClock, .worldClock, .calendarClock:
            .time
        case .controlDeck, .shortcutStack, .focusConsole:
            .tools
        case .photoPolaroid, .photoFilmstrip, .photoMosaic:
            .photos
        case .musicVinyl, .musicGlass, .musicWave:
            .music
        case .currencyMinimal, .currencyMatrix, .travelConverter,
             .goldSpot, .goldTrend, .metalsDuo,
             .stockQuote, .watchlistBento, .dualMarket:
            .finance
        }
    }

    var symbolName: String {
        switch self {
        case .workdayRail: "sparkles.rectangle.stack.fill"
        case .minimalCountdown: "textformat.size"
        case .incomeBento: "square.grid.2x2.fill"
        case .weekRhythm: "calendar.badge.clock"
        case .progressOrbit: "circle.hexagongrid.fill"
        case .paydayCalendar: "calendar.badge.checkmark"
        case .afterworkPlan: "sofa.fill"
        case .healthBento: "heart.text.square.fill"
        case .sleepRibbon: "bed.double.fill"
        case .oxygenPulse: "lungs.fill"
        case .weatherNow: "cloud.sun.fill"
        case .weatherHourly: "clock.badge.fill"
        case .weatherMinimal: "cloud.fill"
        case .loveDays: "heart.fill"
        case .loveOrbit: "heart.circle.fill"
        case .editorialClock: "textformat.size"
        case .worldClock: "globe.asia.australia.fill"
        case .calendarClock: "calendar"
        case .controlDeck: "switch.2"
        case .shortcutStack: "square.grid.2x2.fill"
        case .focusConsole: "moon.stars.fill"
        case .photoPolaroid: "photo.fill"
        case .photoFilmstrip: "film.stack.fill"
        case .photoMosaic: "rectangle.3.group.fill"
        case .musicVinyl: "record.circle"
        case .musicGlass: "play.circle.fill"
        case .musicWave: "waveform"
        case .currencyMinimal: "dollarsign.arrow.circlepath"
        case .currencyMatrix: "square.grid.2x2.fill"
        case .travelConverter: "airplane.departure"
        case .goldSpot: "circle.hexagongrid.fill"
        case .goldTrend: "chart.line.uptrend.xyaxis"
        case .metalsDuo: "seal.fill"
        case .stockQuote: "chart.line.uptrend.xyaxis"
        case .watchlistBento: "list.bullet.rectangle.fill"
        case .dualMarket: "globe.asia.australia.fill"
        }
    }

    var supportedSizes: [WidgetArtworkSize] {
        switch self {
        case .workdayRail:
            [.small, .medium, .large]
        case .minimalCountdown, .progressOrbit, .afterworkPlan:
            [.small, .medium]
        case .incomeBento, .weekRhythm, .paydayCalendar:
            [.medium, .large]
        case .healthBento, .weatherNow, .weatherHourly, .loveDays, .worldClock:
            [.medium]
        case .sleepRibbon, .oxygenPulse, .weatherMinimal, .loveOrbit,
             .editorialClock, .calendarClock, .shortcutStack, .focusConsole,
             .photoPolaroid, .musicVinyl, .musicWave:
            [.small, .medium]
        case .controlDeck, .musicGlass:
            [.medium]
        case .photoFilmstrip, .photoMosaic:
            [.medium, .large]
        case .currencyMinimal, .travelConverter, .goldSpot, .stockQuote:
            [.small, .medium]
        case .currencyMatrix, .metalsDuo:
            [.medium]
        case .goldTrend, .watchlistBento, .dualMarket:
            [.medium, .large]
        }
    }

    var preferredPreviewSize: WidgetArtworkSize {
        switch self {
        case .progressOrbit, .afterworkPlan, .oxygenPulse, .weatherMinimal,
             .loveOrbit, .editorialClock, .calendarClock, .shortcutStack,
             .focusConsole, .photoPolaroid, .musicVinyl, .musicWave:
            .small
        case .currencyMinimal, .travelConverter, .goldSpot, .stockQuote:
            .small
        default:
            .medium
        }
    }

    var widgetDisplayName: String {
        switch category {
        case .health: "健康状态"
        case .weather: "天气预报"
        case .love: "恋爱纪念日"
        case .time: "时间画报"
        case .tools: "快捷工具"
        case .photos: "相册记忆"
        case .music: "音乐播放器"
        case .finance:
            switch self {
            case .currencyMinimal, .currencyMatrix, .travelConverter:
                "汇率换算"
            case .goldSpot, .goldTrend, .metalsDuo:
                "黄金价格"
            default:
                "港美股行情"
            }
        default: title
        }
    }

    var configurationStyleName: String? {
        switch category {
        case .health, .weather, .love, .time, .tools, .photos, .music, .finance:
            title
        default:
            nil
        }
    }

    var usesHealthData: Bool {
        category == .health
    }

    var usesWeatherData: Bool {
        category == .weather
    }

    var usesShortcutBridge: Bool {
        category == .tools
    }

    var usesPhotoFile: Bool {
        category == .photos
    }

    var usesMusicLink: Bool {
        category == .music
    }

    var usesExchangeRates: Bool {
        switch self {
        case .currencyMinimal, .currencyMatrix, .travelConverter:
            true
        default:
            false
        }
    }

    var usesGoldMarketData: Bool {
        switch self {
        case .goldSpot, .goldTrend, .metalsDuo:
            true
        default:
            false
        }
    }

    var usesStockMarketData: Bool {
        switch self {
        case .stockQuote, .watchlistBento, .dualMarket:
            true
        default:
            false
        }
    }

    static func templates(for category: WidgetTemplateCategory) -> [WidgetTemplateKind] {
        if category == .featured {
            return allCases
        }
        return allCases.filter { $0.category == category }
    }
}
