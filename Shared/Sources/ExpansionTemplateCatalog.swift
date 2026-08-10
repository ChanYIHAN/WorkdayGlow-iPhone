import Foundation

enum ExpansionTemplateLayout: String, Sendable {
    case orbit
    case bento
    case timeline
    case poster
    case gauge
    case list

    var supportedSizes: [WidgetArtworkSize] {
        switch self {
        case .bento, .timeline, .list:
            [.medium, .large]
        case .orbit, .poster, .gauge:
            [.small, .medium]
        }
    }

    var preferredSize: WidgetArtworkSize {
        switch self {
        case .orbit, .poster, .gauge: .small
        case .bento, .timeline, .list: .medium
        }
    }
}

struct ExpansionTemplateMetadata: Sendable {
    let title: String
    let subtitle: String
    let category: WidgetTemplateCategory
    let symbolName: String
    let layout: ExpansionTemplateLayout
    let palette: Int
}

extension WidgetTemplateKind {
    var expansionMetadata: ExpansionTemplateMetadata? {
        switch self {
        case .hydrationBloom:
            item("饮水花园", "用花瓣进度提醒今天温柔补水", .health, "drop.fill", .orbit, 0)
        case .stressBalance:
            item("压力平衡", "把压力与放松时刻放在同一条轴上", .health, "brain.head.profile", .gauge, 1)
        case .standRhythm:
            item("站立节奏", "记录今天起身活动的小时分布", .health, "figure.stand", .timeline, 2)
        case .mindfulMinutes:
            item("正念分钟", "给呼吸、冥想与安静留出位置", .health, "brain", .poster, 3)
        case .cycleWellness:
            item("周期关怀", "低刺激的周期与状态提示", .health, "circle.hexagonpath.fill", .list, 4)
        case .heartZones:
            item("心率区间", "用分层色带理解最近运动强度", .health, "heart.circle.fill", .bento, 5)
        case .sleepStages:
            item("睡眠阶段", "深睡、核心睡眠与清醒时间一眼看懂", .health, "bed.double.circle.fill", .timeline, 1)
        case .airQuality:
            item("空气质量", "AQI、湿度与风向组成出门提示", .weather, "aqi.medium", .bento, 2)
        case .rainRadar:
            item("降雨雷达", "未来两小时降雨概率与强度", .weather, "cloud.rain.fill", .gauge, 0)
        case .sunriseForecast:
            item("晨昏预报", "日出、黄金时刻与日落倒计时", .weather, "sunrise.fill", .timeline, 4)
        case .weeklyWeather:
            item("一周天气", "七日高低温与天气趋势", .weather, "calendar", .list, 2)
        case .pollenCare:
            item("花粉关怀", "过敏季节的轻量出门建议", .weather, "leaf.fill", .poster, 0)
        case .couplePhoto:
            item("双人相框", "一张照片和我们走过的天数", .love, "person.2.fill", .poster, 5)
        case .loveLetters:
            item("情书便签", "把想说的话留在每天都能看到的地方", .love, "envelope.fill", .list, 4)
        case .nextDate:
            item("下次约会", "为下一次见面保留期待", .love, "calendar.badge.clock", .gauge, 5)
        case .flipClock:
            item("翻页时钟", "复古数字与现代留白的组合", .time, "clock.fill", .poster, 1)
        case .wordClock:
            item("文字时钟", "用一句话描述此刻时间", .time, "textformat", .poster, 3)
        case .focusClock:
            item("专注时钟", "时间、目标与剩余分钟同屏", .time, "timer", .orbit, 2)
        case .countdownEvent:
            item("事件倒计时", "为生日、考试或旅行准备一张卡", .time, "calendar.badge.clock", .gauge, 4)
        case .timezoneStrip:
            item("时区长条", "横向比较四座城市的工作时段", .time, "globe", .timeline, 1)
        case .batteryPanel:
            item("电量面板", "设备电量与充电提示的设计化展示", .tools, "battery.75percent", .gauge, 0)
        case .storageMeter:
            item("存储仪表", "以环形刻度展示手动填写的空间状态", .tools, "externaldrive.fill", .orbit, 2)
        case .qrLauncher:
            item("二维码入口", "把常用二维码与标题放到桌面", .tools, "qrcode", .poster, 1)
        case .quickNotes:
            item("快捷便签", "三条随手记，保持清楚而不拥挤", .tools, "note.text", .list, 4)
        case .appLauncher:
            item("应用启动台", "四个常用入口组成玻璃控制面板", .tools, "square.grid.2x2.fill", .bento, 3)
        case .photoStack:
            item("照片叠层", "像桌上相片一样自然错落", .photos, "photo.stack.fill", .poster, 5)
        case .memoryDate:
            item("那年今日", "让拍摄日期成为照片的一部分", .photos, "calendar.badge.clock", .timeline, 4)
        case .panoramicPhoto:
            item("宽幅记忆", "让风景铺满中号与大号组件", .photos, "rectangle.wide", .poster, 2)
        case .scrapbook:
            item("手帐拼贴", "照片、日期与短句的轻复古组合", .photos, "rectangle.3.group.fill", .bento, 5)
        case .albumShelf:
            item("专辑陈列架", "三张常听专辑排成一列", .music, "rectangle.stack.fill", .list, 1)
        case .lyricsCard:
            item("歌词摘录", "收藏一句打动你的歌词", .music, "quote.bubble.fill", .poster, 3)
        case .nowPlayingMinimal:
            item("极简在听", "封面、标题与入口，保持克制", .music, "play.fill", .gauge, 0)
        case .playlistCover:
            item("歌单封面", "为今日歌单做一张情绪海报", .music, "music.note.list", .poster, 4)
        case .cryptoPair:
            item("数字资产双卡", "两项手动资产价格与涨跌对照", .finance, "bitcoinsign.circle.fill", .bento, 1)
        case .portfolioPulse:
            item("组合脉搏", "用环形比例回顾资产分布", .finance, "chart.pie.fill", .orbit, 2)
        case .marketHeatmap:
            item("市场热力图", "九宫格呈现板块强弱", .finance, "square.grid.3x3.fill", .bento, 5)
        case .budgetRing:
            item("预算圆环", "本月预算、已花与可用金额", .finance, "chart.donut.fill", .orbit, 0)
        case .savingsGoal:
            item("储蓄目标", "让长期目标每天前进一点", .finance, "target", .gauge, 4)
        case .expenseSnapshot:
            item("支出快照", "今天、本周与本月支出摘要", .finance, "creditcard.fill", .list, 1)
        case .habitTracker:
            item("习惯打卡", "七天连续记录与今日完成度", .planner, "checkmark.circle.fill", .timeline, 0)
        case .pomodoroBoard:
            item("番茄专注", "专注轮次、休息与当日目标", .planner, "timer", .orbit, 5)
        case .taskPriority:
            item("优先级看板", "把重要、紧急与稍后分开", .planner, "flag.fill", .bento, 4)
        case .meetingCountdown:
            item("会议倒计时", "下一场会议与准备事项", .planner, "person.3.fill", .gauge, 2)
        case .monthOverview:
            item("月度总览", "重要日期和本月目标同屏", .planner, "calendar", .timeline, 1)
        case .studyPlan:
            item("学习计划", "课程、复习与连续学习天数", .planner, "book.fill", .list, 3)
        case .projectMilestone:
            item("项目里程碑", "距离下一节点还有多少工作", .planner, "point.topleft.down.curvedto.point.bottomright.up", .gauge, 0)
        case .affirmation:
            item("今日肯定", "每天一句积极但不过度的提醒", .daily, "sparkles", .poster, 4)
        case .gratitudePrompt:
            item("感恩提问", "用一个问题留住今天的好", .daily, "heart.text.square.fill", .list, 5)
        case .zodiacDay:
            item("星座日签", "轻娱乐的今日关键词与幸运时段", .daily, "sparkles", .bento, 3)
        case .festivalCountdown:
            item("节日倒计时", "记录下一个值得期待的节日", .daily, "gift.fill", .gauge, 4)
        case .vacationCountdown:
            item("假期倒计时", "距离出发还有几次好好睡觉", .countdown, "airplane", .poster, 2)
        case .weekendCountdown:
            item("周末倒计时", "工作日也能看见周末正在靠近", .countdown, "cup.and.saucer.fill", .gauge, 0)
        case .salaryProgress:
            item("本月收入进度", "按工作日估算本月已完成收入", .income, "banknote.fill", .orbit, 1)
        case .overtimeEarnings:
            item("加班收益估算", "手动记录额外工时与收入", .income, "clock.badge.checkmark.fill", .bento, 5)
        case .yearProgress:
            item("年度进度", "今年走过多少，也还剩多少", .rhythm, "circle.dotted", .gauge, 3)
        default:
            nil
        }
    }

    private func item(
        _ title: String,
        _ subtitle: String,
        _ category: WidgetTemplateCategory,
        _ symbolName: String,
        _ layout: ExpansionTemplateLayout,
        _ palette: Int
    ) -> ExpansionTemplateMetadata {
        ExpansionTemplateMetadata(
            title: title,
            subtitle: subtitle,
            category: category,
            symbolName: symbolName,
            layout: layout,
            palette: palette
        )
    }
}
