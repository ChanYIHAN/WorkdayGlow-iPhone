import AppIntents
import SwiftUI
import WidgetKit

struct VocabularyConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "设置词汇学习"
    @Parameter(title: "学习卡样式", default: .wordDaily) var style: VocabularyWidgetStyle
    @Parameter(title: "自定义英文（留空使用每日入门词）", default: "") var word: String
    @Parameter(title: "自定义词义", default: "") var meaning: String
    @Parameter(title: "例句", default: "") var example: String
}

struct VocabularyEntry: TimelineEntry {
    let date: Date
    let template: WidgetTemplateKind
    let word: VocabularyWord
    let revealed: Bool
    let reviewed: Bool
}

struct VocabularyProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> VocabularyEntry { entry(.init(), date: .now) }
    func snapshot(for configuration: VocabularyConfigurationIntent, in context: Context) async -> VocabularyEntry {
        entry(configuration, date: .now)
    }
    func timeline(for configuration: VocabularyConfigurationIntent, in context: Context) async -> Timeline<VocabularyEntry> {
        let now = Date()
        let midnight = Calendar.current.startOfDay(for: now)
        let dates = (0..<3).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: midnight) }
        return Timeline(entries: dates.enumerated().map { entry(configuration, date: $0.offset == 0 ? now : $0.element) }, policy: .atEnd)
    }
    private func entry(_ config: VocabularyConfigurationIntent, date: Date) -> VocabularyEntry {
        let index = (Calendar.current.ordinality(of: .day, in: .era, for: date) ?? 0) % VocabularySeed.words.count
        let custom = config.word.trimmingCharacters(in: .whitespacesAndNewlines)
        let word = custom.isEmpty ? VocabularySeed.words[index] : VocabularyWord(word: custom, meaning: config.meaning, example: config.example)
        let key = "widget.vocabulary.\(word.id)"
        return VocabularyEntry(date: date, template: config.style.template, word: word,
            revealed: UserDefaults.standard.bool(forKey: key + ".revealed"),
            reviewed: UserDefaults.standard.bool(forKey: key + ".reviewed"))
    }
}

struct FlipVocabularyIntent: AppIntent {
    static var title: LocalizedStringResource = "翻面单词"
    @Parameter(title: "单词") var wordID: String
    init() {}
    init(wordID: String) { self.wordID = wordID }
    func perform() async throws -> some IntentResult {
        let key = "widget.vocabulary.\(wordID).revealed"
        UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: key), forKey: key)
        WidgetCenter.shared.reloadTimelines(ofKind: "WorkdayGlow.Vocabulary")
        return .result()
    }
}

struct RememberVocabularyIntent: AppIntent {
    static var title: LocalizedStringResource = "记住单词"
    @Parameter(title: "单词") var wordID: String
    init() {}
    init(wordID: String) { self.wordID = wordID }
    func perform() async throws -> some IntentResult {
        UserDefaults.standard.set(true, forKey: "widget.vocabulary.\(wordID).reviewed")
        WidgetCenter.shared.reloadTimelines(ofKind: "WorkdayGlow.Vocabulary")
        return .result()
    }
}

struct VocabularyWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: "WorkdayGlow.Vocabulary", intent: VocabularyConfigurationIntent.self, provider: VocabularyProvider()) { entry in
            VocabularyWidgetView(entry: entry)
                .containerBackground(for: .widget) { ExpansionTemplateBackground(template: entry.template) }
                .widgetURL(URL(string: "workdayglow://learning"))
        }
        .configurationDisplayName("词汇学习")
        .description("22 种学习主题；每日入门词、自定义词义和交互翻面。完整间隔复习请进入应用。")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .contentMarginsDisabled()
    }
}

private struct VocabularyWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: VocabularyEntry
    var body: some View {
        VStack(spacing: 0) {
            VocabularyArtwork(template: entry.template, word: entry.word,
                size: family == .systemSmall ? .small : family == .systemLarge ? .large : .medium,
                revealed: entry.revealed)
            HStack {
                Button(intent: FlipVocabularyIntent(wordID: entry.word.id)) {
                    Text(entry.revealed ? "英文" : "翻面")
                }
                if entry.revealed {
                    Button(intent: RememberVocabularyIntent(wordID: entry.word.id)) {
                        Text(entry.reviewed ? "已记住 ✓" : "记住了")
                    }.disabled(entry.reviewed)
                }
            }
            .font(.caption).buttonStyle(.bordered).padding(.bottom, 10)
        }
    }
}
