import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var store: SettingsStore
    private let calculator = WorkdayCalculator()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    TimelineView(.periodic(from: .now, by: 1)) { timeline in
                        let snapshot = calculator.snapshot(
                            for: timeline.date,
                            settings: store.settings
                        )

                        WorkdayHeroCard(
                            settings: store.settings,
                            snapshot: snapshot,
                            density: .expanded,
                            showsStats: true
                        )
                    }

                    HStack(spacing: 12) {
                        SummaryCard(
                            title: "月薪",
                            value: store.settings.privacyMode
                                ? "••••"
                                : "\(store.settings.currency.symbol)\(store.settings.monthlySalary.formatted(.number.precision(.fractionLength(0))))",
                            symbol: "creditcard.fill",
                            tint: store.settings.theme.palette.accentStart
                        )

                        SummaryCard(
                            title: "工作日",
                            value: "每周 \(store.settings.workdays.count) 天",
                            symbol: "calendar",
                            tint: store.settings.theme.palette.highlight
                        )
                    }

                    setupTip
                }
                .padding()
            }
            .background(AppCanvas())
            .navigationTitle("概览")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: store.settings.theme.symbolName)
                        .foregroundStyle(store.settings.theme.palette.accentStart)
                        .accessibilityLabel("当前主题：\(store.settings.theme.displayName)")
                }
            }
        }
    }

    private var setupTip: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "rectangle.3.group.fill")
                .font(.title3)
                .foregroundStyle(store.settings.theme.palette.accentEnd)
                .frame(width: 34)

            VStack(alignment: .leading, spacing: 4) {
                Text("把节奏放到桌面")
                    .font(.headline)

                Text("添加“奕刻”后，长按小组件并选择“编辑小组件”，填写上下班时间和收入信息。")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding()
        .appGlassSurface(cornerRadius: 20)
    }
}

private struct SummaryCard: View {
    let title: String
    let value: String
    let symbol: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: symbol)
                .font(.headline)
                .foregroundStyle(tint)

            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .appGlassSurface(cornerRadius: 20)
    }
}
