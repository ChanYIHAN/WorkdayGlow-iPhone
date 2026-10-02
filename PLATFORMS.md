# 奕刻 · Ekhart Widgets 三端工程说明

## 共享产品目录

iOS、Android 与 HarmonyOS 使用同一套 150 款中文模板名称与分类。视觉语义保持一致，但交互、系统圆角、字体、动态色彩和桌面组件能力遵循各平台原生规范，不追求逐像素复制。

## iOS

- 路径：`WorkdayGlow`、`WorkdayGlowWidget`、`Shared`
- 技术：SwiftUI、WidgetKit、App Intents、HealthKit
- 150 款模板进入 App 画廊；85 款展示设计通过“灵感合集”选择，20 款学习主题通过“词汇学习”选择。
- 应用内词库与间隔复习本地保存；词卡独立配置，保持无 App Group 的免费侧载兼容性。
- GitHub Actions：`Build Ekhart unsigned IPA`

## Android

- 路径：`android`
- 技术：Kotlin、Jetpack Compose、Material 3、Jetpack Glance、Health Connect 依赖
- 当前实现：原生五栏导航、150 款可搜索/分类的模板画廊、六类预览、深色模式、动态配色、玻璃视觉卡片，以及今日活力和词汇学习两个 Glance 入口。
- 词汇学习提供设备朗读、翻面、自定义词库与间隔复习；桌面词卡共享应用进度。
- GitHub Actions：`Build Ekhart Android APK`
- 本地构建：在 Android Studio 打开 `android`，或执行 `gradle :app:assembleDebug`。

Glance 最终会转换成系统 RemoteViews，因此不能直接复用普通 Compose 组件；桌面组件视觉会遵守 Android 启动器提供的圆角、尺寸和刷新限制。

## HarmonyOS

- 路径：`harmony`
- 技术：ArkTS、ArkUI、Stage 模型、Form Kit
- 当前实现：150 款同名目录、搜索与分类、玻璃卡片、六类预览、五栏导航，以及今日活力/每日单词两个 Form Kit 入口。
- 应用内支持文字翻面、自定义词库和间隔复习；服务卡片按日显示内置词，未同步应用词库。ArkTS 代码仍需 DevEco Studio 验证。
- 构建：使用 DevEco Studio 打开 `harmony`，等待 IDE 同步配套 SDK，然后运行：

```text
hvigorw --mode project -p product=default -p buildMode=debug assembleApp
```

HarmonyOS SDK、模拟器与签名材料由 DevEco Studio/华为开发者账号提供，公开 GitHub runner 默认不包含这套工具链，因此仓库暂不自动生成 HAP。首次在 DevEco Studio 打开时，IDE 可能会按安装版本升级 Hvigor 插件号或工程配置，这是官方工具链的正常迁移过程。
