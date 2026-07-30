import SwiftUI

struct WidgetTemplateDetailView: View {
    let template: WidgetTemplateKind

    @State private var selectedSize: WidgetArtworkSize

    init(template: WidgetTemplateKind) {
        self.template = template
        _selectedSize = State(initialValue: template.preferredPreviewSize)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                previewSection
                sizePicker
                aboutSection
                if template.usesHealthData {
                    healthPermissionSection
                }
                if template.usesWeatherData {
                    weatherSourceSection
                }
                if template.usesShortcutBridge {
                    shortcutSetupSection
                }
                if template.usesPhotoFile {
                    photoSetupSection
                }
                if template.usesMusicLink {
                    musicSetupSection
                }
                installSection
            }
            .padding()
            .padding(.bottom, 24)
        }
        .background(Color("GalleryCanvas").ignoresSafeArea())
        .navigationTitle(template.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var previewSection: some View {
        VStack(spacing: 14) {
            WidgetPreviewView(template: template, size: selectedSize)
                .frame(maxWidth: selectedSize == .small ? 220 : nil)
                .animation(.snappy, value: selectedSize)

            Text(previewFootnote)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }

    private var sizePicker: some View {
        Picker("组件尺寸", selection: $selectedSize) {
            ForEach(template.supportedSizes) { size in
                Text(size.title).tag(size)
            }
        }
        .pickerStyle(.segmented)
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("关于这款组件", systemImage: template.symbolName)
                .font(.headline)

            Text(template.subtitle)
                .font(.body)
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                Label(template.usesWeatherData ? "在线更新" : "本地处理", systemImage: "iphone")
                Label(template.usesWeatherData ? "每小时" : "隐私优先", systemImage: template.usesWeatherData ? "arrow.clockwise" : "hand.raised.fill")
                Label("可编辑", systemImage: "slider.horizontal.3")
            }
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundStyle(Color("PlumInk").opacity(0.68))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var installSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("添加到桌面", systemImage: "plus.rectangle.on.rectangle")
                .font(.headline)

            instructionRow(number: 1, text: "在主屏幕长按空白处，点击“添加小组件”。")
            instructionRow(number: 2, text: "搜索“下班光轨”，选择“\(template.widgetDisplayName)”。")
            instructionRow(number: 3, text: configurationInstruction)

            Text("iOS 暂不允许 App 直接替你把组件放上桌面，这是系统的隐私限制。")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top, 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var healthPermissionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("需要 Apple 健康授权", systemImage: "heart.text.square.fill")
                .font(.headline)
                .foregroundStyle(Color("AuroraCoral"))

            Text("Widget 不能弹出健康授权窗口，请先在主 App 中完成一次授权。只读取心率、睡眠时长和血氧；免费侧载未保留 HealthKit 能力时可改用手动数据。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            NavigationLink {
                HealthAccessView()
            } label: {
                Label("前往健康授权", systemImage: "checkmark.shield.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color("AuroraCoral"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var weatherSourceSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("免费天气数据", systemImage: "cloud.sun.fill")
                .font(.headline)

            Text("使用 Open-Meteo 的城市搜索与天气预报接口，无需 API Key。组件会每小时请求一次最新数据。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Link("查看 Open-Meteo 数据来源", destination: URL(string: "https://open-meteo.com/")!)
                .font(.caption)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var shortcutSetupSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("使用 Apple 快捷指令", systemImage: "switch.2")
                .font(.headline)

            Text("iOS 不允许普通 App 直接切换系统连接状态。这组组件会运行你创建的系统快捷指令，默认名称为“切换 Wi-Fi”“切换蓝牙”“切换蜂窝数据”和“切换飞行模式”。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            NavigationLink {
                ToolboxView()
            } label: {
                Label("查看设置教程与测试按钮", systemImage: "wand.and.stars")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color("PlumInk"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var photoSetupSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("选择你的照片", systemImage: "photo.on.rectangle.angled")
                .font(.headline)

            Text("免费 Apple ID 模式不使用 App Group。请先在系统相册打开照片 → 分享 →“存储到文件”，然后长按桌面组件 →“编辑小组件”，从“文件”选择一至三张照片。图片会缩小后在本机显示，不会上传。")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var musicSetupSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("连接 Apple Music", systemImage: "music.note")
                .font(.headline)

            Text("在 Apple Music 打开歌曲、专辑或歌单，点击分享并复制链接，再粘贴到组件的“Apple Music 分享链接”中。组件不读取你的播放历史，也不会冒充系统的实时播放控制器。")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var configurationInstruction: String {
        if let style = template.configurationStyleName {
            if template.usesHealthData {
                return "添加后长按并选择“编辑小组件”，把样式设为“\(style)”；自动读取不可用时把数据来源改为“手动填写”。"
            }
            if template.usesShortcutBridge {
                return "先按教程建立四条系统快捷指令，再长按组件并把样式设为“\(style)”；名称不同时可在编辑页修改。"
            }
            if template.usesPhotoFile {
                return "长按组件并选择“编辑小组件”，把样式设为“\(style)”，再从“文件”选择照片并填写照片文字。"
            }
            if template.usesMusicLink {
                return "长按组件并选择“编辑小组件”，把样式设为“\(style)”，填写歌名、歌手、Apple Music 分享链接和可选封面。"
            }
            return "添加后长按并选择“编辑小组件”，把样式设为“\(style)”并填写对应信息。"
        }
        return "添加后长按组件并点“编辑小组件”，填写你的时间和偏好。"
    }

    private var previewFootnote: String {
        switch template.category {
        case .health:
            "桌面实际效果会读取你授权的 Apple 健康摘要"
        case .weather:
            "桌面实际效果会根据你填写的城市每小时更新"
        case .love:
            "桌面实际效果会根据纪念日与称呼自动计算"
        case .time:
            "桌面实际效果会随设备时间和所选城市更新"
        case .tools:
            "点击按钮会交给你创建的系统快捷指令执行"
        case .photos:
            "桌面实际效果会显示你从“文件”选择的私人照片"
        case .music:
            "点击桌面组件会打开你填写的 Apple Music 链接"
        default:
            "桌面实际效果会根据你的上下班时间与收入设置更新"
        }
    }

    private func instructionRow(number: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(Color("PlumInk"))
                .frame(width: 24, height: 24)
                .background(Color("ButterGlow"), in: Circle())

            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}
