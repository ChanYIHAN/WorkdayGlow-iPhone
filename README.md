# 奕刻 · Ekhart Widgets

[![Build Ekhart unsigned IPA](https://github.com/ChanYIHAN/WorkdayGlow-iPhone/actions/workflows/build-unsigned-ipa.yml/badge.svg)](https://github.com/ChanYIHAN/WorkdayGlow-iPhone/actions/workflows/build-unsigned-ipa.yml)
[![Build Ekhart Android APK](https://github.com/ChanYIHAN/WorkdayGlow-iPhone/actions/workflows/build-android.yml/badge.svg)](https://github.com/ChanYIHAN/WorkdayGlow-iPhone/actions/workflows/build-android.yml)
![iOS 17+](https://img.shields.io/badge/iOS-17%2B-111111?logo=apple)
![Android 9+](https://img.shields.io/badge/Android-9%2B-3DDC84?logo=android&logoColor=white)
![HarmonyOS](https://img.shields.io/badge/HarmonyOS-ArkTS-EA3323)
![Templates](https://img.shields.io/badge/Widget%20Templates-200-6C63FF)

一个本地优先、跨 iOS、Android 与 HarmonyOS 的设计型桌面组件项目。组件库围绕健康、天气、倒计时、时间、工具、相册、音乐、汇率、黄金、港美股和日程等场景，共提供 **200 款中文视觉模板**。

项目不包含自建服务器、账号系统、广告、统计 SDK 或付费能力。三端共享同一套内容目录与设计语言，同时保留各自平台的原生交互、字体、动态配色、圆角和桌面组件规范。

> **让每一刻，恰好可见。** 当前主版本：iOS `0.9.0`、Android/HarmonyOS `0.3.0`。iOS 与 Android 使用 GitHub Actions 构建；HarmonyOS 已提供 ArkTS 源码工程，首次 HAP 编译需要 DevEco Studio 和 HarmonyOS SDK。

## 0.9 / 0.3 · 200 款设计目录

- 新增 50 款，覆盖全部 14 个类别，原有 150 个标识保留，已有配置可继续使用。
- 每款有独立内容记录；黄金显示金价、词根显示构词内容、饮水进度与容量对应，清理泛用的「72% / 良好」占位。
- 构图由六种扩展至十二种，新增票签、细刻度、点阵、线形、窗格与编辑部排版。六套低饱和色板统一字号、层次、边线与留白。原有 iOS 专项视图保留实时数据绑定，并调整标题字重与预览边框。
- iOS 26 原生 Liquid Glass、旧系统 Material 降级；Android 玻璃视觉、HarmonyOS ArkUI 模糊保留不透明模式和动效开关。桌面组件遵循系统刷新限制。
- 学习主题增至 22 款，内置 40 词与原创例句，支持翻面、个人词库和本地间隔复习；iOS/Android 支持设备朗读。

[完整 200 款目录与构图](docs/CATALOG.md) · [设计说明](design-system/workdayglow/ATELIER-200.md) · [离线设计校样](design-system/workdayglow/preview.html)

### 开始背单词

iOS 在组件库筛选“学习”，进入任一详情后点击“开始背单词”；Android/鸿蒙进入“学习”标签页。翻面揭晓词义后，选择“记住了”或“再想一想”。

导入格式为每行 `英文 | 中文 | 例句（可选）`，也支持制表符。每次最多读取前 500 行，无效行忽略，相同英文更新内容并重置该词进度。

```text
curious | 好奇的 | Stay curious about the world.
resilient | 有韧性的 | A resilient team learns from setbacks.
```

雅思、四六级、词根、短语等名称是学习主题，**不附带完整考试词库**，可以导入对应内容。

### 桌面词卡的范围

- iOS：“词汇学习”入口可选择 22 种主题；英文留空时按本地日历切换入门词，也可配置英文、词义与例句。支持桌面翻面和“已记住”标记。为保留免费侧载兼容性，不启用 App Group，桌面词卡配置和标记在扩展内保存，**与应用内词库/间隔复习独立**。
- Android：Glance 词卡读取应用词库并优先显示到期词；桌面翻面、记住与应用共享本地进度。导入或复习后刷新词卡，系统可能延迟桌面更新。
- HarmonyOS：Form Kit 词卡按日轮换入门词，点击进入学习页；尚未同步个人词库和复习进度。

研究方法与三端材质差异见 [玻璃设计说明](design-system/workdayglow/LIQUID-GLASS.md)。研究参考 [Koco 官方介绍](https://apps.apple.com/us/app/koco-widgets-app-launcher/id6702013570)，未复制其资产或源码。

### 内容与逻辑验证

```bash
node Scripts/sync-content.mjs
node --test Tests/content.test.mjs
```

Swift 复习/导入/目录测试在 macOS CI 执行；Android 执行 `gradle :app:testDebugUnitTest :app:assembleDebug`。HarmonyOS 尚需 DevEco Studio 与实际设备验收，源码检查不代表 HAP 编译通过。

## 项目状态

| 平台 | 主应用 | 桌面组件 | 数据能力 | 构建状态 |
| --- | --- | --- | --- | --- |
| iOS 17+ | SwiftUI 五栏应用、搜索与 200 款画廊 | 21 个 WidgetKit 入口，覆盖小/中/大与部分锁屏尺寸 | HealthKit、Open-Meteo、ECB、Alpha Vantage、本地数据与手动备用 | 可生成未签名 IPA |
| Android 9+ | Jetpack Compose、Material 3、动态配色与 200 款画廊 | 今日活力 + 可翻面的 Glance 词汇学习组件 | Health Connect 权限与依赖框架已预留；当前组件使用展示数据 | 可生成 Debug APK |
| HarmonyOS | ArkUI 五栏应用、搜索与 200 款画廊 | 今日活力 + 每日单词 Form Kit 服务卡片 | 当前使用展示数据，等待真机 API 接入 | 源码完成，待 DevEco Studio 验证 |

这里的“200 款”指三端统一的视觉模板目录，不代表系统组件选择器中会出现 200 个独立入口。iOS 将相近设计合并到 21 个 WidgetKit 入口，并通过“编辑小组件”切换具体样式；Android 与 HarmonyOS 当前各实现了两个原生桌面卡片，后续会逐步扩展原生入口与实时数据。

## 200 款组件目录

| 类别 | 数量 | 设计方向 |
| --- | ---: | --- |
| 下班与倒计时 | 8 | 票签 / 地平线 / 留白大字 |
| 收入与发薪 | 7 | 账本 / 分格 / 发薪票 |
| 周期与进度 | 6 | 点阵 / 双环 / 季节表盘 |
| 健康与休息 | 26 | 舒缓薄荷 / 数据分格 / 呼吸圆环 |
| 天气与环境 | 12 | 雾蓝窗景 / 降雨线形 / 风向圆盘 |
| 情侣与纪念 | 9 | 柔玫瑰 / 邮戳 / 相伴点阵 |
| 时间与时区 | 14 | 细刻度 / 衬线时刻 / 时区票签 |
| 快捷工具 | 12 | 入口分格 / 电量圆盘 / 便签票 |
| 相册与回忆 | 13 | 胶片窗格 / 接触印样 / 明信片 |
| 音乐与声音 | 12 | 黑胶圆盘 / 声波 / 专辑窗格 |
| 财务与行情 | 20 | 纸感账本 / 行情线 / 换汇票 |
| 日程与效率 | 24 | 时间轴 / 行程单 / 习惯点阵 |
| 日常与灵感 | 15 | 晨间短笺 / 月相 / 茶歇小票 |
| 学习与单词 | 22 | 衬线词卡 / 翻面 / 阅读摘记 |
| **合计** | **200** | **14 类 / 12 种构图 / 6 套色板** |

<details>
<summary>下班与倒计时 · 8 款</summary>

光轨倒计时、极简倒计时、今晚提案、假期倒计时、周末倒计时、下班车票、傍晚地平线、假日窗口。

</details>

<details>
<summary>收入与发薪 · 7 款</summary>

收入便当、发薪月历、本月收入进度、加班收益估算、收入账页、发薪凭笺、时薪刻度。

</details>

<details>
<summary>周期与进度 · 6 款</summary>

本周节奏、进度轨道、年度进度、四季罗盘、一周点阵、月份丝带。

</details>

<details>
<summary>健康与休息 · 26 款</summary>

健康便当、睡眠丝带、血氧脉冲、步数轨道、活力便当、恢复弧线、饮水花园、压力平衡、站立节奏、正念分钟、周期关怀、心率区间、睡眠阶段、呼吸节拍、护眼休息、伸展间歇、散步邀请、心情记录、晚安仪式、饮水时段、数字日落、恢复花园、步行足迹、月下睡眠、脉搏丝带、活动小票。

</details>

<details>
<summary>天气与环境 · 12 款</summary>

天气画布、逐时天气、极简天气、空气质量、降雨雷达、晨昏预报、一周天气、花粉关怀、天空之窗、风向罗盘、雨量丝带、出门天气签。

</details>

<details>
<summary>情侣与纪念 · 9 款</summary>

恋爱天数、纪念日轨道、双人相框、情书便签、下次约会、相伴星图、纪念日票根、小小约定、心动邮戳。

</details>

<details>
<summary>时间与时区 · 14 款</summary>

编辑部时钟、世界时间、日历时钟、翻页时钟、文字时钟、专注时钟、事件倒计时、时区长条、航班便签、时差对照、静谧表盘、时区登机牌、一天弧线、分钟排印。

</details>

<details>
<summary>快捷工具 · 12 款</summary>

灵动控制台、快捷开关、专注控制舱、电量面板、存储仪表、二维码入口、快捷便签、应用启动台、快捷花盘、连接便当、电池刻度盘、便签小票。

</details>

<details>
<summary>相册与回忆 · 13 款</summary>

拍立得记忆、胶片时刻、三格相册、照片叠层、那年今日、宽幅记忆、手帐拼贴、旅途一页、记忆胶囊、记忆窗格、相片索引、记忆明信片、照片扉页。

</details>

<details>
<summary>音乐与声音 · 12 款</summary>

黑胶唱片、玻璃播放器、声波胶囊、专辑陈列架、歌词摘录、极简在听、歌单封面、今日配乐、唱片封套、旋律丝带、歌单票签、唱片拼贴。

</details>

<details>
<summary>财务与行情 · 20 款</summary>

极简汇率、汇率矩阵、旅行换算、黄金现货、金价曲线、金银双卡、单股行情、自选股便当、港美双市场、数字资产双卡、组合脉搏、市场热力图、预算圆环、储蓄目标、支出快照、旅途预算、预算账笺、换汇票据、行情折线、储蓄星图。

</details>

<details>
<summary>日程与效率 · 24 款</summary>

玻璃日程、一周计划、专注此刻、习惯打卡、番茄专注、优先级看板、会议倒计时、月度总览、学习计划、项目里程碑、旅行清单、通勤计划、周末路线、今日三件事、深度工作、周末复盘、阅读目标、灵感收件箱、截止时间轴、居家整理、技能旅程、今日行程签、专注表盘、习惯星群。

</details>

<details>
<summary>日常与灵感 · 15 款</summary>

每日一句、月相观测、日光节律、今日肯定、感恩提问、星座日签、节日倒计时、城市愿望、诗意日签、咖啡时刻、桌面伙伴、今日色彩、晨间来信、月夜星图、茶歇小笺。

</details>

<details>
<summary>学习与单词 · 22 款</summary>

每日单词、单词翻面、到期复习、词汇进度、学习连续日、词根拆解、例句卡片、近义辨析、短语积累、拼写挑战、听读练习、旅行英语、职场英语、雅思词汇、四六级词汇、易忘词夹、每日词汇目标、阅读摘录、考试冲刺、语言护照、词汇随身签、阅读扉页。

</details>

每一款的稳定标识、构图与实现范围见 [目录明细](docs/CATALOG.md)。200 指视觉模板，系统入口数量及实时数据范围见上方「项目状态」；票签中的航班、路线等内容为示例。

## 设计特点

- 苹果风的空间层次、玻璃材质、柔和渐变和大面积留白，不逐像素复制任何第三方产品。
- Android 使用通透渐变、反射边缘、阴影与 Material 3 语义色、动态配色、48dp 触控区域和 Glance 原生组件能力。
- HarmonyOS 使用背景模糊、玻璃卡片与轻量属性动画，基于 ArkUI/ArkTS 与 Form Kit，并遵循服务卡片的尺寸和刷新限制。
- 小、中、大尺寸采用不同信息密度，而不是简单缩放同一张卡片。
- 支持浅色与深色语义配色；核心状态同时使用文字、图标与颜色表达。
- iOS 与 Android 画廊使用原生惰性布局；鸿蒙按搜索与分类过滤渲染，长目录的真机滚动性能仍待验证。

设计令牌和平台差异说明位于 [`design-system/workdayglow`](design-system/workdayglow)。

## 快速安装

### iPhone：GitHub Actions + Sideloadly

1. 打开仓库的 [Actions](https://github.com/ChanYIHAN/WorkdayGlow-iPhone/actions) 页面。
2. 选择 **Build Ekhart unsigned IPA**，点击 **Run workflow**。
3. 构建完成后，在运行记录底部下载 `EkhartWidgets-unsigned-ipa`。
4. 解压得到 `EkhartWidgets-unsigned.ipa`。
5. 从 [Sideloadly 官网](https://sideloadly.io) 安装软件，将 IPA 拖入并使用自己的 Apple ID 签名。
6. 不要启用 `Remove app extensions / PlugIns`，否则 Widget 扩展会被移除。
7. 安装后先启动一次“奕刻”，再回到桌面添加“奕刻”组件。

免费 Apple ID 的 Personal Team 描述文件通常只有 7 天有效期。Sideloadly 自动刷新仍要求电脑定期运行，并能通过 USB 或同一局域网发现 iPhone。若 HealthKit 能力在免费重签过程中被移除，可把健康组件的数据来源改为“手动填写”。

### Android：下载并安装 APK

1. 打开 [Actions](https://github.com/ChanYIHAN/WorkdayGlow-iPhone/actions)，选择 **Build Ekhart Android APK**。
2. 点击 **Run workflow**，构建完成后下载 `EkhartWidgets-Android-debug`。
3. 解压得到 `app-debug.apk`，传到 Android 手机。
4. 按系统提示允许当前文件管理器“安装未知应用”，然后安装 APK。
5. 长按桌面空白处，在系统组件列表中添加“奕刻 · 今日活力”。

Debug APK 适合个人测试，不是 Google Play 正式发布包。覆盖安装时应保持相同的 application ID 和签名。

### HarmonyOS：DevEco Studio 构建

1. 安装 [DevEco Studio](https://developer.huawei.com/consumer/cn/deveco-studio/)。
2. 在 DevEco Studio 中打开仓库的 `harmony` 目录。
3. 按 IDE 提示安装匹配的 HarmonyOS SDK 并同步 Hvigor。
4. 配置模拟器、真机和签名后运行 `entry` 模块。
5. 也可以在配置完成的终端中执行：

```text
hvigorw --mode project -p product=default -p buildMode=debug assembleApp
```

公开 GitHub runner 默认不包含 DevEco Studio、HarmonyOS SDK 与个人签名材料，因此仓库暂不自动生成 HAP。

## 添加和配置 iOS 小组件

1. 先打开一次“奕刻”。
2. 回到主屏幕，长按空白处并添加小组件。
3. 搜索“奕刻”，选择模板与尺寸。
4. 添加后长按组件，选择“编辑小组件”。
5. 根据组件填写城市、纪念日、日程、币种、股票代码、图片或快捷指令名称。

主要配置方式：

- 健康：先在主应用“设置”中申请 Apple 健康授权，也可以选择手动数据。
- 天气：手动填写城市名称，不申请持续定位权限。
- 工具：填写 Apple“快捷指令”中对应操作的名称。
- 相册：先把照片存入“文件”，再从组件编辑界面选择 1–3 张图片。
- 音乐：填写歌名、歌手、Apple Music 分享链接和可选封面。
- 汇率：选择基准币种、目标币种与金额，无需 API Key。
- 黄金与港美股：填写 Alpha Vantage API Key 和品种/股票代码。
- 灵感合集：在同一个组件入口中切换133 款展示设计；另有 22 款词汇主题入口。

## 数据来源与能力边界

### iOS

- 健康数据通过用户授权后从 HealthKit 只读查询，不上传健康记录。
- 天气使用 Open-Meteo；只发送用户填写的城市名称，不申请定位权限。
- 汇率使用欧洲中央银行公开的每日参考汇率。
- 黄金和港美股使用 Alpha Vantage 的延迟参考值或最新收盘数据；免费接口有调用频率限制。
- 快捷工具通过 Apple“快捷指令”执行。普通 App 无法直接读取或切换所有系统连接状态。
- 音乐组件是内容入口，不读取系统实时播放状态，也不模拟实时播放器控制。
- 相册图片、纪念日、工作设置、日程和手动数据保存在设备或 Widget 配置中。

### Android 与 HarmonyOS

- 已完成 200 款本地模板目录、搜索、筛选、预览与原生桌面卡片基础工程。
- Android 已声明 Health Connect 依赖和权限入口，但尚未完成用户授权、数据读取与桌面组件刷新链路。
- 天气、健康、行情、相册和音乐目前为展示数据；接入正式 API 前不应视为实时结果。

行情内容仅用于界面展示与个人参考，不构成投资建议。完整隐私说明见 [PRIVACY.md](PRIVACY.md)。

## 本地开发

### iOS

需要 macOS、当前稳定版 Xcode 与 XcodeGen：

```bash
brew install xcodegen
zsh Scripts/generate_project.command
```

生成未签名 IPA：

```bash
zsh Scripts/build_unsigned_ipa.command
```

iOS 最低版本为 iOS 17。HealthKit 等受签名能力保护的功能，建议使用 Xcode 和自己的 Personal Team 在真机验证。

### Android

使用 Android Studio 打开 `android` 目录，等待 Gradle 同步后运行 `app`。命令行构建与 CI 相同：

```bash
cd android
gradle :app:assembleDebug
```

当前配置为 Java 17、Gradle 8.11.1、compileSdk 36、targetSdk 35、minSdk 28。

### HarmonyOS

使用 DevEco Studio 打开 `harmony`。不同版本 IDE 可能会升级 Hvigor 插件或工程配置，请以本机安装的 HarmonyOS SDK 建议为准。

更多平台差异、构建方式和实现范围见 [PLATFORMS.md](PLATFORMS.md)。

## 项目结构

```text
.
├─ WorkdayGlow/Sources          iOS SwiftUI 主应用
├─ WorkdayGlowWidget/Sources    WidgetKit、App Intents 与桌面组件
├─ Shared/Sources               iOS 共享模型、计算逻辑与 200 款视觉目录
├─ Shared/Resources             iOS 颜色、资源与隐私清单
├─ android                      Kotlin、Compose、Material 3 与 Glance 工程
├─ harmony                      ArkTS、ArkUI、Stage 模型与 Form Kit 工程
├─ design-system/workdayglow    三端设计系统与平台覆盖规则
├─ Configuration               iOS Bundle ID 与构建配置
├─ Scripts                     Xcode 工程生成和 IPA 打包脚本
└─ .github/workflows            iOS IPA 与 Android APK 云端构建
```

## 持续集成

仓库包含 iOS、Android 构建与共享内容验证工作流；代码推送和 PR 自动执行，也可手动触发：

- [`Build Ekhart unsigned IPA`](.github/workflows/build-unsigned-ipa.yml)：在 macOS runner 上生成 Xcode 工程、关闭代码签名并打包 IPA。
- [`Build Ekhart Android APK`](.github/workflows/build-android.yml)：在 Ubuntu runner 上使用 Java 17 和 Gradle 8.11.1 生成 Debug APK。

构建产物保存在对应运行记录底部的 **Artifacts** 区域，不会提交进 Git 仓库。

## 隐私与安全

- 不包含广告、账号系统、统计 SDK 或自建数据服务。
- 不要把 Apple ID、验证码、恢复密钥、Alpha Vantage API Key 或签名文件提交到 GitHub。
- Sideloadly 与其他侧载工具不是 Apple 官方分发渠道，只应从官方网站下载。
- 如果只用于个人安装，可以为侧载单独准备 Apple ID，降低主要账号风险。
- 第三方行情与天气服务受各自的使用条款、限流和可用性约束。

## 下一阶段

- 将 Android 的 Health Connect 授权、心率、睡眠、步数和血氧读取接入桌面组件。
- 为 Android 增加天气、倒计时、相册、音乐和行情类 Glance 组件入口。
- 在 DevEco Studio 中完成 HarmonyOS HAP 构建验证与真机服务卡片测试。
- 为 Android 与 HarmonyOS 接入天气、汇率和行情缓存层。
- 补充三端实际设备截图、自动化 UI 测试与正式发布签名流程。

---

奕刻（Ekhart Widgets）目前以个人侧载、设计验证和跨平台组件研究为目标。欢迎通过 Issue 记录兼容性问题、数据源限制和新组件建议。
