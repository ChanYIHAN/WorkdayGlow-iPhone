import AppIntents
import Foundation

enum UtilityWidgetStyle: String, AppEnum {
    case deck
    case stack
    case focus

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "工具样式"
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .deck: "灵动控制台",
        .stack: "快捷开关",
        .focus: "专注控制舱"
    ]

    var template: WidgetTemplateKind {
        switch self {
        case .deck: .controlDeck
        case .stack: .shortcutStack
        case .focus: .focusConsole
        }
    }
}

struct UtilityWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "设置快捷工具"
    static var description = IntentDescription(
        "填写系统快捷指令名称。点击组件按钮时，下班光轨会把它交给“快捷指令”App 运行。"
    )

    @Parameter(title: "样式", default: .deck)
    var style: UtilityWidgetStyle

    @Parameter(title: "Wi-Fi 快捷指令", default: "切换 Wi-Fi")
    var wifiShortcutName: String

    @Parameter(title: "蓝牙快捷指令", default: "切换蓝牙")
    var bluetoothShortcutName: String

    @Parameter(title: "蜂窝数据快捷指令", default: "切换蜂窝数据")
    var cellularShortcutName: String

    @Parameter(title: "飞行模式快捷指令", default: "切换飞行模式")
    var airplaneShortcutName: String
}

enum PhotoWidgetStyle: String, AppEnum {
    case polaroid
    case filmstrip
    case mosaic

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "相册样式"
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .polaroid: "拍立得记忆",
        .filmstrip: "胶片时刻",
        .mosaic: "三格相册"
    ]

    var template: WidgetTemplateKind {
        switch self {
        case .polaroid: .photoPolaroid
        case .filmstrip: .photoFilmstrip
        case .mosaic: .photoMosaic
        }
    }
}

struct PhotoWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "设置相册记忆"
    static var description = IntentDescription(
        "从“文件”中选择照片。可以先在系统相册中把喜欢的照片存储到“文件”。"
    )

    @Parameter(title: "样式", default: .polaroid)
    var style: PhotoWidgetStyle

    @Parameter(title: "照片一", supportedTypeIdentifiers: ["public.image"])
    var firstPhoto: IntentFile?

    @Parameter(title: "照片二", supportedTypeIdentifiers: ["public.image"])
    var secondPhoto: IntentFile?

    @Parameter(title: "照片三", supportedTypeIdentifiers: ["public.image"])
    var thirdPhoto: IntentFile?

    @Parameter(title: "照片文字", default: "把喜欢的瞬间留在桌面")
    var caption: String
}

enum MusicWidgetStyle: String, AppEnum {
    case vinyl
    case glass
    case wave

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "音乐样式"
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .vinyl: "黑胶唱片",
        .glass: "玻璃播放器",
        .wave: "声波胶囊"
    ]

    var template: WidgetTemplateKind {
        switch self {
        case .vinyl: .musicVinyl
        case .glass: .musicGlass
        case .wave: .musicWave
        }
    }
}

struct MusicWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "设置音乐播放器"
    static var description = IntentDescription(
        "填写歌名、歌手和 Apple Music 分享链接；点击组件会打开对应内容。"
    )

    @Parameter(title: "样式", default: .vinyl)
    var style: MusicWidgetStyle

    @Parameter(title: "歌名或歌单名", default: "Midnight Drive")
    var titleText: String

    @Parameter(title: "歌手或描述", default: "YOUR DAILY MIX")
    var artistText: String

    @Parameter(title: "Apple Music 分享链接", default: "music://")
    var musicURL: String

    @Parameter(title: "封面图片", supportedTypeIdentifiers: ["public.image"])
    var coverImage: IntentFile?
}
