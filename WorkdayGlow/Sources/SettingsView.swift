import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: SettingsStore
    @State private var showsResetConfirmation = false

    private let weekdayOptions: [(value: Int, label: String)] = [
        (2, "一"), (3, "二"), (4, "三"), (5, "四"), (6, "五"), (7, "六"), (1, "日")
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker(
                        "上班时间",
                        selection: startTimeBinding,
                        displayedComponents: .hourAndMinute
                    )

                    DatePicker(
                        "下班时间",
                        selection: endTimeBinding,
                        in: endTimeRange,
                        displayedComponents: .hourAndMinute
                    )

                    weekdayPicker
                } header: {
                    Text("工作时间")
                } footer: {
                    Text("倒计时以设备本地时间为准；第一版暂不扣除午休时间。")
                }

                Section {
                    TextField(
                        "月薪",
                        value: salaryBinding,
                        format: .number.precision(.fractionLength(0...2))
                    )
                    .keyboardType(.decimalPad)

                    Picker("货币", selection: currencyBinding) {
                        ForEach(CurrencyCode.allCases) { currency in
                            Text("\(currency.displayName) · \(currency.symbol)")
                                .tag(currency)
                        }
                    }

                    Stepper(value: paydayBinding, in: 1...28) {
                        LabeledContent("发薪日", value: "每月 \(store.settings.paydayDay) 日")
                    }

                    Toggle("隐藏金额", isOn: privacyBinding)
                } header: {
                    Text("收入估算")
                } footer: {
                    Text("今日预计收入按“月薪 ÷ 21.75 × 今日工作进度”计算，仅作为轻量估算。")
                }

                Section("外观") {
                    Picker("主题", selection: themeBinding) {
                        ForEach(WorkdayTheme.allCases) { theme in
                            Label(theme.displayName, systemImage: theme.symbolName)
                                .tag(theme)
                        }
                    }
                    .pickerStyle(.segmented)

                    ThemePreviewRow(theme: store.settings.theme)
                }

                Section {
                    NavigationLink {
                        HealthAccessView()
                    } label: {
                        Label("Apple 健康授权", systemImage: "heart.text.square.fill")
                    }
                } header: {
                    Text("健康组件")
                } footer: {
                    Text("健康组件只读访问心率、昨夜睡眠、血氧、今日步数、步行距离和活动能量；授权必须在主 App 内完成。")
                }

                Section {
                    NavigationLink {
                        PrivacyPolicyView()
                    } label: {
                        Label("隐私说明", systemImage: "hand.raised.fill")
                    }
                } header: {
                    Text("隐私与数据")
                } footer: {
                    Text("健康数据留在设备上；天气、汇率、黄金和股票组件仅向对应数据服务发送完成查询所需的内容。")
                }

                Section {
                    Button("恢复默认设置", role: .destructive) {
                        showsResetConfirmation = true
                    }
                }

                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("免费签名模式", systemImage: "checkmark.shield.fill")
                            .font(.headline)
                            .foregroundStyle(store.settings.theme.palette.accentStart)

                        Text("应用内设置只用于概览页。由于免费 Apple ID 不支持 App Group，桌面小组件需要长按后单独配置一次；行情密钥与自选代码也由 iOS 保存在对应组件配置中。")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("设置")
            .alert("恢复默认设置？", isPresented: $showsResetConfirmation) {
                Button("取消", role: .cancel) {}
                Button("恢复", role: .destructive) {
                    store.reset()
                }
            } message: {
                Text("上下班时间、月薪、发薪日和主题都会恢复为初始值。")
            }
        }
    }

    private var weekdayPicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("工作日")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 7) {
                ForEach(weekdayOptions, id: \.value) { option in
                    let isSelected = store.settings.workdays.contains(option.value)

                    Button {
                        var updated = store.settings
                        if isSelected {
                            if updated.workdays.count > 1 {
                                updated.workdays.remove(option.value)
                            }
                        } else {
                            updated.workdays.insert(option.value)
                        }
                        store.settings = updated
                    } label: {
                        Text(option.label)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 34)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(isSelected ? Color("GlowCanvas") : .secondary)
                    .background(
                        isSelected
                            ? AnyShapeStyle(store.settings.theme.palette.accentGradient)
                            : AnyShapeStyle(Color(.quaternarySystemFill)),
                        in: Circle()
                    )
                    .accessibilityLabel("星期\(option.label)")
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                }
            }
        }
        .padding(.vertical, 4)
    }

    private var startTimeBinding: Binding<Date> {
        Binding(
            get: { date(for: store.settings.startMinute) },
            set: { newValue in
                var updated = store.settings
                updated.startMinute = min(minute(from: newValue), (23 * 60) + 29)
                if updated.endMinute <= updated.startMinute {
                    updated.endMinute = min(updated.startMinute + 60, (24 * 60) - 1)
                }
                store.settings = updated
            }
        )
    }

    private var endTimeBinding: Binding<Date> {
        Binding(
            get: { date(for: store.settings.endMinute) },
            set: { newValue in
                var updated = store.settings
                updated.endMinute = max(minute(from: newValue), updated.startMinute + 30)
                store.settings = updated
            }
        )
    }

    private var endTimeRange: ClosedRange<Date> {
        let lower = date(for: min(store.settings.startMinute + 30, (24 * 60) - 1))
        let upper = date(for: (24 * 60) - 1)
        return lower...upper
    }

    private var salaryBinding: Binding<Double> {
        Binding(
            get: { store.settings.monthlySalary },
            set: { value in
                var updated = store.settings
                updated.monthlySalary = max(value, 0)
                store.settings = updated
            }
        )
    }

    private var paydayBinding: Binding<Int> {
        Binding(
            get: { store.settings.paydayDay },
            set: { value in
                var updated = store.settings
                updated.paydayDay = value
                store.settings = updated
            }
        )
    }

    private var currencyBinding: Binding<CurrencyCode> {
        Binding(
            get: { store.settings.currency },
            set: { value in
                var updated = store.settings
                updated.currency = value
                store.settings = updated
            }
        )
    }

    private var privacyBinding: Binding<Bool> {
        Binding(
            get: { store.settings.privacyMode },
            set: { value in
                var updated = store.settings
                updated.privacyMode = value
                store.settings = updated
            }
        )
    }

    private var themeBinding: Binding<WorkdayTheme> {
        Binding(
            get: { store.settings.theme },
            set: { value in
                var updated = store.settings
                updated.theme = value
                store.settings = updated
            }
        )
    }

    private func date(for minute: Int) -> Date {
        Calendar.current.startOfDay(for: .now)
            .addingTimeInterval(TimeInterval(minute * 60))
    }

    private func minute(from date: Date) -> Int {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        return (components.hour ?? 0) * 60 + (components.minute ?? 0)
    }
}

private struct ThemePreviewRow: View {
    let theme: WorkdayTheme

    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<3, id: \.self) { index in
                Capsule()
                    .fill(index == 0 ? theme.palette.accentGradient : secondaryStyle(for: index))
                    .frame(height: 12)
            }
        }
        .padding(.vertical, 6)
        .accessibilityLabel("\(theme.displayName)主题配色预览")
    }

    private func secondaryStyle(for index: Int) -> LinearGradient {
        LinearGradient(
            colors: [
                index == 1 ? theme.palette.accentEnd : theme.palette.highlight,
                index == 1 ? theme.palette.highlight : theme.palette.accentStart
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}
