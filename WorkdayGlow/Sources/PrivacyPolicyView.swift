import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Label("本地优先，不做用户画像", systemImage: "hand.raised.fill")
                        .font(.headline)
                        .foregroundStyle(Color("PlumInk"))

                    Text("下班光轨不包含账号系统、广告、统计 SDK 或自建服务器。你的工作时间、收入、纪念日、日程与手动健康数据保存在设备或 iOS 的小组件配置中。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 6)
            }

            Section("Apple 健康") {
                policyRow(
                    symbol: "waveform.path.ecg",
                    title: "读取内容",
                    text: "经你授权后，仅只读访问最近心率、最近血氧、昨夜睡眠，以及今日步数、步行距离和活动能量。"
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

            Section("快捷工具") {
                policyRow(
                    symbol: "switch.2",
                    title: "系统快捷指令",
                    text: "工具组件只按你填写的名称打开 Apple“快捷指令”App，不读取 Wi-Fi、蓝牙、蜂窝数据或飞行模式状态。"
                )
                policyRow(
                    symbol: "checkmark.shield.fill",
                    title: "不使用私有接口",
                    text: "应用不会绕过 iOS 权限直接切换系统设置，也不会使用未公开的系统设置地址。"
                )
            }

            Section("照片与音乐") {
                policyRow(
                    symbol: "photo.fill",
                    title: "本地照片",
                    text: "你为相册或音乐组件选择的图片由 iOS 小组件配置保存，只在设备上缩小和显示，不会上传。"
                )
                policyRow(
                    symbol: "music.note",
                    title: "音乐链接",
                    text: "音乐组件仅保存你填写的标题、描述和分享链接；点击时由系统打开对应的 Apple Music 页面。"
                )
            }

            Section("汇率与行情") {
                policyRow(
                    symbol: "eurosign.arrow.circlepath",
                    title: "ECB 每日汇率",
                    text: "汇率组件只把所选币种代码发送给欧洲中央银行公开接口，不需要账号或密钥。"
                )
                policyRow(
                    symbol: "chart.line.uptrend.xyaxis",
                    title: "Alpha Vantage 行情",
                    text: "黄金与股票组件会把你填写的 API Key 和品种或股票代码发送给 Alpha Vantage。密钥由 iOS 保存在对应的小组件配置中，不会写入 GitHub。"
                )
                policyRow(
                    symbol: "clock.badge.exclamationmark",
                    title: "延迟参考数据",
                    text: "免费行情可能延迟，并按较低频率刷新；它不是实时交易报价，也不构成投资建议。"
                )
            }

            Section("日程与每日灵感") {
                policyRow(
                    symbol: "checklist",
                    title: "仅保存在本机",
                    text: "日程事项、专注目标、日出日落时间由 iOS 保存在对应的小组件配置中，不会上传。"
                )
                policyRow(
                    symbol: "moonphase.waxing.gibbous",
                    title: "本地估算",
                    text: "每日语录与月相均在设备上生成；月相是便于日常展示的近似计算，不用于天文观测。"
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
