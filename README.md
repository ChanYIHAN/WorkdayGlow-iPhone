# 奕刻 · Ekhart Widgets

[![Build Ekhart unsigned IPA](https://github.com/ChanYIHAN/WorkdayGlow-iPhone/actions/workflows/build-unsigned-ipa.yml/badge.svg)](https://github.com/ChanYIHAN/WorkdayGlow-iPhone/actions/workflows/build-unsigned-ipa.yml)
[![Build Ekhart Android APK](https://github.com/ChanYIHAN/WorkdayGlow-iPhone/actions/workflows/build-android.yml/badge.svg)](https://github.com/ChanYIHAN/WorkdayGlow-iPhone/actions/workflows/build-android.yml)
![iOS 17+](https://img.shields.io/badge/iOS-17%2B-111111?logo=apple)
![Android 9+](https://img.shields.io/badge/Android-9%2B-3DDC84?logo=android&logoColor=white)
![HarmonyOS](https://img.shields.io/badge/HarmonyOS-ArkTS-EA3323)
![Templates](https://img.shields.io/badge/Widget%20Templates-100-6C63FF)

一个本地优先、跨 iOS、Android 与 HarmonyOS 的设计型桌面组件项目。组件库围绕健康、天气、倒计时、时间、工具、相册、音乐、汇率、黄金、港美股和日程等场景，共提供 **100 款中文视觉模板**。

项目不包含自建服务器、账号系统、广告、统计 SDK 或付费能力。三端共享同一套内容目录与设计语言，同时保留各自平台的原生交互、字体、动态配色、圆角和桌面组件规范。

> **让每一刻，恰好可见。** 当前主版本：iOS `0.7.1`、Android/HarmonyOS `0.1.1`。iOS 与 Android 使用 GitHub Actions 构建；HarmonyOS 已提供 ArkTS 源码工程，首次 HAP 编译需要 DevEco Studio 和 HarmonyOS SDK。

## 项目状态

| 平台 | 主应用 | 桌面组件 | 数据能力 | 构建状态 |
| --- | --- | --- | --- | --- |
| iOS 17+ | SwiftUI 五栏应用、搜索与 100 款画廊 | 20 个 WidgetKit 入口，覆盖小/中/大与部分锁屏尺寸 | HealthKit、Open-Meteo、ECB、Alpha Vantage、本地数据与手动备用 | 可生成未签名 IPA |
| Android 9+ | Jetpack Compose、Material 3、动态配色与 100 款画廊 | 1 个可调整尺寸的 Glance“今日活力”组件 | Health Connect 权限与依赖框架已预留；当前组件使用展示数据 | 可生成 Debug APK |
| HarmonyOS | ArkUI 五栏应用、搜索与 100 款画廊 | 1 个多尺寸“今日活力”Form Kit 服务卡片 | 当前使用展示数据，等待真机 API 接入 | 源码完成，待 DevEco Studio 验证 |

这里的“100 款”指三端统一的视觉模板目录，不代表系统组件选择器中会出现 100 个独立入口。iOS 将相近设计合并到 20 个 WidgetKit 入口，并通过“编辑小组件”切换具体样式；Android 与 HarmonyOS 当前各实现了一个原生桌面卡片，后续会逐步扩展原生入口与实时数据。

## 100 款组件目录

| 分类 | 数量 | 代表设计 |
| --- | ---: | --- |
| 健康 | 13 | 健康便当、睡眠丝带、血氧脉冲、心率区间、睡眠阶段、饮水花园 |
| 天气 | 8 | 天气画布、逐时天气、降雨雷达、空气质量、一周天气、晨昏预报 |
| 恋爱 | 5 | 恋爱天数、纪念日轨道、双人相框、情书便签、下次约会 |
| 时间 | 8 | 编辑部时钟、世界时间、翻页时钟、文字时钟、专注时钟、时区长条 |
| 工具 | 8 | 灵动控制台、快捷开关、电量面板、二维码入口、快捷便签、应用启动台 |
| 相册 | 7 | 拍立得记忆、胶片时刻、照片叠层、宽幅记忆、手帐拼贴 |
| 音乐 | 7 | 黑胶唱片、玻璃播放器、声波胶囊、专辑陈列架、歌词摘录 |
| 行情与财务 | 15 | 汇率矩阵、旅行换算、黄金现货、港美双市场、市场热力图、预算圆环 |
| 日程 | 10 | 玻璃日程、一周计划、习惯打卡、番茄专注、月度总览、项目里程碑 |
| 日常 | 7 | 每日一句、月相观测、日光节律、今日肯定、感恩提问 |
| 下班倒计时 | 5 | 光轨倒计时、极简倒计时、今晚提案、假期倒计时、周末倒计时 |
| 收入 | 4 | 收入便当、发薪月历、本月收入进度、加班收益估算 |
| 节奏 | 3 | 本周节奏、进度轨道、年度进度 |
| **合计** | **100** | 六类响应式构图：Orbit、Bento、Timeline、Poster、Gauge、List |

## 设计特点

- 苹果风的空间层次、玻璃材质、柔和渐变和大面积留白，不逐像素复制任何第三方产品。
- Android 使用 Material 3 语义色、动态配色、48dp 触控区域和 Glance 原生组件能力。
- HarmonyOS 使用 ArkUI/ArkTS 与 Form Kit，并遵循服务卡片的尺寸和刷新限制。
- 小、中、大尺寸采用不同信息密度，而不是简单缩放同一张卡片。
- 支持浅色与深色语义配色；核心状态同时使用文字、图标与颜色表达。
- 100 项长列表采用原生惰性布局，保持搜索、筛选和滚动性能。

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
- 灵感合集：在同一个组件入口中切换新增的 55 款设计。

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

- 已完成 100 款本地模板目录、搜索、筛选、预览与原生桌面卡片基础工程。
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
├─ Shared/Sources               iOS 共享模型、计算逻辑与 100 款视觉目录
├─ Shared/Resources             iOS 颜色、资源与隐私清单
├─ android                      Kotlin、Compose、Material 3 与 Glance 工程
├─ harmony                      ArkTS、ArkUI、Stage 模型与 Form Kit 工程
├─ design-system/workdayglow    三端设计系统与平台覆盖规则
├─ Configuration               iOS Bundle ID 与构建配置
├─ Scripts                     Xcode 工程生成和 IPA 打包脚本
└─ .github/workflows            iOS IPA 与 Android APK 云端构建
```

## 持续集成

仓库包含两个可手动触发的 GitHub Actions 工作流：

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
