# 奕刻 150 · 玻璃与轻动效

## 研究与取舍

研究依据是 [Koco Widgets 的官方 App Store 功能介绍与版本说明](https://apps.apple.com/us/app/koco-widgets-app-launcher/id6702013570)。其中值得吸收的模式是：按场景发现、Bento 信息层次、通透材质、有限的颜色主题与小尺寸可读性。这次以这些模式改善奕刻，图形、词库例句和排版代码均为项目自己的实现。

没有访问 Koco 的付费界面或源码，也没有验证其“真实透明”、直接启动第三方应用或动态岛能力。这些宣传能力不作为奕刻已实现的功能。

## 材质

| 平台 | 应用内实现 | 降级 |
| --- | --- | --- |
| iOS | iOS 26 / Swift 6.2 SDK 使用 `glassEffect`，交互卡使用 `.interactive()`；系统 TabView 随系统版本更新 | iOS 17–25 使用 Material、反射边缘和阴影；减少透明度使用实色 |
| Android | Compose 原生渐变反光、半透明语义色、圆角与描边；背景分层色彩透过卡片 | 可在设置开启不透明背景；不对文字应用 blur |
| HarmonyOS | ArkUI 原生背景模糊、半透明底色、反光描边与阴影 | 可在设置开启不透明背景；服务卡片使用静态渐变 |

Android 的实现是玻璃视觉近似，不具有 Apple 系统的实时折射。桌面小组件均服从系统渲染与刷新规则，不宣称能够实时折射主屏幕壁纸。

## 动效

- 翻面采用短暂淡入与尺度变化，交互后才播放，避免整个长列表持续刷新。
- iOS 按压弹簧、尺寸切换与词义揭晓遵循减少动态效果设置。
- Android 标签页与词卡淡入遵循 Compose 动画时长缩放，并提供应用内动效开关。
- HarmonyOS 词义揭晓、类别切换、标签页切换使用 220ms 属性动画，并提供动效开关。
- 桌面词卡使用状态更新与系统时间线。持续动画仅用于应用内，不设置毫秒级刷新任务。

## 词库与数量

150 是视觉主题目录数量，不是 150 个完全独立的数据服务。新增 20 个学习主题共享一个真实的本地间隔复习功能；主题标题不代表自带完整雅思、四六级等考试词库。

新增 50 项元数据、40 个入门词及原创例句在 `content/` 维护，通过 `Scripts/sync-content.mjs` 生成三端源文件。原有 Android/HarmonyOS 100 项 ID 保持不变，新增项使用稳定的英文 ID。

## 验证范围

内容测试验证数量、唯一性、三端名称一致、iOS 安装入口和生成代码同步。Swift/Kotlin 测试验证间隔复习、忘记后的重置、重复导入与无效行处理。iOS/Android 使用云端原生编译；HarmonyOS 需 DevEco Studio 编译及真机验收，不以文本检查替代原生验收。

参考：[Apple glassEffect](https://developer.apple.com/documentation/swiftui/view/glasseffect(_:in:))、[Apple 减少透明度](https://developer.apple.com/documentation/swiftui/environmentvalues/accessibilityReduceTransparency)、[Compose 动画](https://developer.android.com/develop/ui/compose/animation/composables-modifiers)、[ArkUI 模糊](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-blur-effect)。
