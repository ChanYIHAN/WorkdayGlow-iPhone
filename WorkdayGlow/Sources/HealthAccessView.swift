import HealthKit
import SwiftUI
import WidgetKit

struct HealthAccessView: View {
    @StateObject private var model = HealthAccessModel()

    var body: some View {
        List {
            Section {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color("AuroraCoral").opacity(0.14))
                        Image(systemName: "heart.text.square.fill")
                            .font(.system(size: 42))
                            .foregroundStyle(Color("AuroraCoral"))
                    }
                    .frame(width: 84, height: 84)

                    Text("让组件读取你的健康摘要")
                        .font(.title3)
                        .fontWeight(.bold)

                    Text("只读取最近心率、最近血氧和昨夜睡眠时长。数据由 Apple 健康提供，不会上传到服务器。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    Button {
                        Task {
                            await model.requestAccess()
                        }
                    } label: {
                        Label(
                            model.isRequesting ? "正在请求…" : "授权 Apple 健康",
                            systemImage: "checkmark.shield.fill"
                        )
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(model.isRequesting || !HealthDataService.isAvailable)
                }
                .padding(.vertical, 12)
            }

            Section("最近读取结果") {
                healthRow(
                    symbol: "waveform.path.ecg",
                    title: "心率",
                    value: model.heartRateText,
                    tint: Color("AuroraCoral")
                )
                healthRow(
                    symbol: "bed.double.fill",
                    title: "睡眠",
                    value: model.sleepText,
                    tint: Color("AuroraLavender")
                )
                healthRow(
                    symbol: "lungs.fill",
                    title: "血氧",
                    value: model.oxygenText,
                    tint: Color("SkyGlow")
                )
            } footer: {
                Text("没有 Apple Watch 或兼容设备记录时，相应指标会显示为“暂无数据”。血氧数据是否可用取决于设备型号和所在地区。")
            }

            Section {
                Label(model.statusMessage, systemImage: model.statusSymbol)
                    .foregroundStyle(model.statusTint)
            }

            Section {
                NavigationLink {
                    PrivacyPolicyView()
                } label: {
                    Label("查看健康数据隐私说明", systemImage: "hand.raised.fill")
                }
            } footer: {
                Text("如果自动读取不可用，长按桌面健康组件并选择“编辑小组件”，可把数据来源改为“手动填写”。")
            }
        }
        .navigationTitle("健康数据")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await model.refresh()
        }
    }

    private func healthRow(symbol: String, title: String, value: String, tint: Color) -> some View {
        LabeledContent {
            Text(value)
                .fontWeight(.semibold)
                .monospacedDigit()
        } label: {
            Label(title, systemImage: symbol)
                .foregroundStyle(tint)
        }
    }
}

@MainActor
private final class HealthAccessModel: ObservableObject {
    @Published var metrics = HealthMetrics(
        heartRate: nil,
        sleepHours: nil,
        oxygenSaturation: nil,
        updatedAt: .now
    )
    @Published var isRequesting = false
    @Published var statusMessage = "尚未检查授权状态"
    @Published var statusSymbol = "questionmark.circle"
    @Published var statusTint = Color.secondary

    private let service = HealthDataService()

    func requestAccess() async {
        isRequesting = true
        defer { isRequesting = false }

        do {
            try await service.requestAuthorization()
            statusMessage = "授权选择已完成，可以添加健康组件"
            statusSymbol = "checkmark.circle.fill"
            statusTint = Color("SeaGlass")
            metrics = await service.fetchMetrics()
            WidgetCenter.shared.reloadTimelines(ofKind: "WorkdayGlow.HealthStatus")
        } catch {
            statusMessage = error.localizedDescription
            statusSymbol = "exclamationmark.triangle.fill"
            statusTint = Color("AuroraCoral")
        }
    }

    func refresh() async {
        guard HealthDataService.isAvailable else {
            statusMessage = "这台设备不支持 Apple 健康"
            statusSymbol = "xmark.circle.fill"
            statusTint = Color("AuroraCoral")
            return
        }

        let status = await service.authorizationRequestStatus()
        switch status {
        case .shouldRequest:
            statusMessage = "需要先授权，组件才能读取数据"
            statusSymbol = "lock.fill"
            statusTint = Color("AuroraCoral")
        case .unnecessary:
            statusMessage = "授权选择已完成"
            statusSymbol = "checkmark.circle.fill"
            statusTint = Color("SeaGlass")
            metrics = await service.fetchMetrics()
        case .unknown:
            statusMessage = "暂时无法判断授权状态"
            statusSymbol = "questionmark.circle"
            statusTint = .secondary
        @unknown default:
            statusMessage = "授权状态发生变化，请重新检查"
            statusSymbol = "questionmark.circle"
            statusTint = .secondary
        }
    }

    var heartRateText: String {
        guard let value = metrics.heartRate else { return "暂无数据" }
        return "\(Int(value.rounded())) bpm"
    }

    var sleepText: String {
        guard let value = metrics.sleepHours else { return "暂无数据" }
        return "\(value.formatted(.number.precision(.fractionLength(1)))) 小时"
    }

    var oxygenText: String {
        guard let value = metrics.oxygenSaturation else { return "暂无数据" }
        return "\(Int((value * 100).rounded()))%"
    }
}
