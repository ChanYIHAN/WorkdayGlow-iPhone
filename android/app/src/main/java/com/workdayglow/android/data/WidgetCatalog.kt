package com.workdayglow.android.data

enum class WidgetCategory(val title: String) {
    Featured("精选"), Countdown("下班"), Income("收入"), Rhythm("节奏"),
    Health("健康"), Weather("天气"), Love("恋爱"), Time("时间"),
    Tools("工具"), Photos("相册"), Music("音乐"), Finance("行情"),
    Planner("日程"), Daily("日常")
}

enum class WidgetLayout { Orbit, Bento, Timeline, Poster, Gauge, List }

data class WidgetTemplate(
    val id: String,
    val title: String,
    val subtitle: String,
    val category: WidgetCategory,
    val layout: WidgetLayout,
    val palette: Int
)

object WidgetCatalog {
    private val layouts = WidgetLayout.entries

    val templates: List<WidgetTemplate> = buildList {
        addGroup(WidgetCategory.Countdown, "离重要时刻更近一点", "光轨倒计时", "极简倒计时", "今晚提案", "假期倒计时", "周末倒计时")
        addGroup(WidgetCategory.Income, "本地估算，不构成财务建议", "收入便当", "发薪月历", "本月收入进度", "加班收益估算")
        addGroup(WidgetCategory.Rhythm, "看见时间正在怎样流动", "本周节奏", "进度轨道", "年度进度")
        addGroup(WidgetCategory.Health, "温和呈现，不制造健康焦虑", "健康便当", "睡眠丝带", "血氧脉冲", "步数轨道", "活力便当", "恢复弧线", "饮水花园", "压力平衡", "站立节奏", "正念分钟", "周期关怀", "心率区间", "睡眠阶段")
        addGroup(WidgetCategory.Weather, "出门前一眼读懂", "天气画布", "逐时天气", "极简天气", "空气质量", "降雨雷达", "晨昏预报", "一周天气", "花粉关怀")
        addGroup(WidgetCategory.Love, "记录我们一起度过的普通日子", "恋爱天数", "纪念日轨道", "双人相框", "情书便签", "下次约会")
        addGroup(WidgetCategory.Time, "每一种时间都有自己的性格", "编辑部时钟", "世界时间", "日历时钟", "翻页时钟", "文字时钟", "专注时钟", "事件倒计时", "时区长条")
        addGroup(WidgetCategory.Tools, "常用入口，少滑几层菜单", "灵动控制台", "快捷开关", "专注控制舱", "电量面板", "存储仪表", "二维码入口", "快捷便签", "应用启动台")
        addGroup(WidgetCategory.Photos, "把桌面变成私人画廊", "拍立得记忆", "胶片时刻", "三格相册", "照片叠层", "那年今日", "宽幅记忆", "手帐拼贴")
        addGroup(WidgetCategory.Music, "让一首歌成为今天的封面", "黑胶唱片", "玻璃播放器", "声波胶囊", "专辑陈列架", "歌词摘录", "极简在听", "歌单封面")
        addGroup(WidgetCategory.Finance, "延迟参考数据，不制造交易焦虑", "极简汇率", "汇率矩阵", "旅行换算", "黄金现货", "金价曲线", "金银双卡", "单股行情", "自选股便当", "港美双市场", "数字资产双卡", "组合脉搏", "市场热力图", "预算圆环", "储蓄目标", "支出快照")
        addGroup(WidgetCategory.Planner, "把重要的事放在最容易看见的位置", "玻璃日程", "一周计划", "专注此刻", "习惯打卡", "番茄专注", "优先级看板", "会议倒计时", "月度总览", "学习计划", "项目里程碑")
        addGroup(WidgetCategory.Daily, "每天一点新鲜感", "每日一句", "月相观测", "日光节律", "今日肯定", "感恩提问", "星座日签", "节日倒计时")
    }.also { check(it.size == 100) { "Widget catalog must contain exactly 100 templates" } }

    private fun MutableList<WidgetTemplate>.addGroup(
        category: WidgetCategory,
        subtitle: String,
        vararg titles: String
    ) {
        titles.forEach { title ->
            val index = size
            add(
                WidgetTemplate(
                    id = "${category.name.lowercase()}-$index",
                    title = title,
                    subtitle = subtitle,
                    category = category,
                    layout = layouts[index % layouts.size],
                    palette = index % 6
                )
            )
        }
    }
}
