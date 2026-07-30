import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Label("本地优先，不做用户画像", systemImage: "hand.raised.fill")
                        .font(.headline)
                        .foregroundStyle(Color("PlumInk"))

                    Text("下班光轨不包含账号系统、广告、统计 SDK 或自建服务器。你的工作时间、收入、纪念日和手动健康数据保存在设备或 iOS 的小组件配置中。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 6)
            }

            Section("Apple 健康") {
                policyRow(
                    symbol: "waveform.path.ecg",
                    title: "读取内容",
                    text: "经你授权后，仅只读访问最近心率、最近血氧和昨夜睡眠时长。"
                )
                policyRow(
                    symbol: "iphone.gen3",
                    title: "处理方式",
                    text: "健康数据仅在你的 iPhone 与小组件扩展中处理，不上传、不出售、不用于广告。"
                )
                policyRow(
                    symbol: "lock.rotation",
                    title: "随时撤回",
                    text: "你可以在“健康”App 的隐私设置中查看或撤销权限；未授权时也能选择手动填写数据。"
                )
            }

            Section("天气") {
                policyRow(
                    symbol: "cloud.sun.fill",
                    title: "城市查询",
                    text: "天气组件只把你填写的城市名称发送给 Open-Meteo，用于查询城市坐标与天气预报。"
                )
                policyRow(
                    symbol: "location.slash.fill",
                    title: "不读取定位",
                    text: "当前版本不申请定位权限，也不会上传精确位置。天气结果会显示 Open-Meteo 数据来源。"
                )
            }

            Section("设备数据") {
                policyRow(
                    symbol: "externaldrive.fill.badge.checkmark",
                    title: "保留与删除",
                    text: "卸载应用或删除对应小组件即可删除本地配置；应用没有可保留数据的云端账户。"
                )
            }
        }
        .navigationTitle("隐私说明")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func policyRow(symbol: String, title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Label(title, systemImage: symbol)
                .font(.subheadline)
                .fontWeight(.semibold)

            Text(text)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
