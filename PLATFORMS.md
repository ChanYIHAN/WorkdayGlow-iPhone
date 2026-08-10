# 三端工程说明

## 共享产品目录

iOS、Android 与 HarmonyOS 使用同一套 100 款中文模板名称与分类。视觉语义保持一致，但交互、系统圆角、字体、动态色彩和桌面组件能力遵循各平台原生规范，不追求逐像素复制。

## iOS

- 路径：`WorkdayGlow`、`WorkdayGlowWidget`、`Shared`
- 技术：SwiftUI、WidgetKit、App Intents、HealthKit
- 100 款模板全部进入 App 画廊；新增 55 款通过“灵感合集”Widget 入口选择。
- GitHub Actions：`Build unsigned IPA`

## Android

- 路径：`android`
- 技术：Kotlin、Jetpack Compose、Material 3、Jetpack Glance、Health Connect 依赖
- 当前实现：原生五栏导航、100 款可搜索/分类的模板画廊、六类响应式预览、深色模式、动态配色、一个可调整尺寸的 Glance“今日活力”桌面组件。
- GitHub Actions：`Build Android APK`
- 本地构建：在 Android Studio 打开 `android`，或执行 `gradle :app:assembleDebug`。

Glance 最终会转换成系统 RemoteViews，因此不能直接复用普通 Compose 组件；桌面组件视觉会遵守 Android 启动器提供的圆角、尺寸和刷新限制。

## HarmonyOS

- 路径：`harmony`
- 技术：ArkTS、ArkUI、Stage 模型、Form Kit
- 当前实现：100 款同名目录、原生搜索与分类画廊、五栏导航，以及“今日活力”ArkTS 卡片和刷新/跳转能力。
- 构建：使用 DevEco Studio 打开 `harmony`，等待 IDE 同步配套 SDK，然后运行：

```text
hvigorw --mode project -p product=default -p buildMode=debug assembleApp
```

HarmonyOS SDK、模拟器与签名材料由 DevEco Studio/华为开发者账号提供，公开 GitHub runner 默认不包含这套工具链，因此仓库暂不自动生成 HAP。首次在 DevEco Studio 打开时，IDE 可能会按安装版本升级 Hvigor 插件号或工程配置，这是官方工具链的正常迁移过程。
