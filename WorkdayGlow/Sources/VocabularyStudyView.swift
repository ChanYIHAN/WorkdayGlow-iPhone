import SwiftUI
import AVFoundation

@MainActor
final class VocabularyStore: ObservableObject {
    @Published var words: [VocabularyWord]
    @Published var reviews: [String: VocabularyReview]
    private let defaults = UserDefaults.standard
    private let speaker = AVSpeechSynthesizer()

    init() {
        words = defaults.data(forKey: "vocabulary.words").flatMap { try? JSONDecoder().decode([VocabularyWord].self, from: $0) } ?? VocabularySeed.words
        reviews = defaults.data(forKey: "vocabulary.reviews").flatMap { try? JSONDecoder().decode([String: VocabularyReview].self, from: $0) } ?? [:]
    }

    func next(at now: Date) -> VocabularyWord? {
        words.filter { (reviews[$0.id]?.due ?? .distantPast) <= now }
            .sorted {
                let a = reviews[$0.id]?.due ?? .distantPast
                let b = reviews[$1.id]?.due ?? .distantPast
                return a == b ? $0.id < $1.id : a < b
            }.first
    }

    func grade(_ word: VocabularyWord, known: Bool) {
        var review = reviews[word.id] ?? VocabularyReview()
        review.grade(known: known, now: .now)
        reviews[word.id] = review
        defaults.set(try? JSONEncoder().encode(reviews), forKey: "vocabulary.reviews")
    }

    func importWords(_ text: String) -> Int {
        let incoming = VocabularyImport.parse(text)
        for word in incoming {
            words.removeAll { $0.id == word.id }
            words.append(word)
            reviews.removeValue(forKey: word.id)
        }
        defaults.set(try? JSONEncoder().encode(words), forKey: "vocabulary.words")
        defaults.set(try? JSONEncoder().encode(reviews), forKey: "vocabulary.reviews")
        return incoming.count
    }

    func speak(_ word: VocabularyWord) {
        speaker.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: word.word)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.42
        speaker.speak(utterance)
    }
}

struct VocabularyStudyView: View {
    @StateObject private var store = VocabularyStore()
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var revealed = false
    @State private var importText = ""
    @State private var feedback = ""
    @State private var importing = false

    var body: some View {
        TimelineView(.periodic(from: .now, by: 15)) { timeline in
            ScrollView {
                VStack(spacing: 20) {
                    Text("每天一点，记得更久。")
                        .font(.title2.bold()).frame(maxWidth: .infinity, alignment: .leading)
                    let word = store.next(at: timeline.date)
                    let learned = store.reviews.values.filter { $0.level > 0 }.count
                    Label("已学习 \(learned) / \(store.words.count) 词", systemImage: "book.closed.fill")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if let word {
                        VStack(spacing: 18) {
                            Text(revealed ? word.meaning : word.word)
                                .font(.largeTitle.bold()).multilineTextAlignment(.center)
                                .id(revealed).transition(.opacity.combined(with: .scale(scale: reduceMotion ? 1 : 0.96)))
                            if revealed {
                                Text(word.word).font(.headline).foregroundStyle(.secondary)
                                Text(word.example).font(.body).multilineTextAlignment(.center)
                            }
                            Button { store.speak(word) } label: {
                                Label("朗读单词", systemImage: "speaker.wave.2.fill")
                            }.buttonStyle(.bordered)
                            Button(revealed ? "查看英文" : "翻面 · 查看词义") {
                                withAnimation(reduceMotion ? nil : .spring(response: 0.35, dampingFraction: 0.8)) { revealed.toggle() }
                            }.buttonStyle(.borderedProminent)
                        }
                        .frame(maxWidth: .infinity, minHeight: 250)
                        .padding(24).appGlassSurface(cornerRadius: 30, interactive: true)
                        HStack {
                            Button("再想一想") { grade(word, known: false) }
                            Button("记住了") { grade(word, known: true) }
                        }
                        .buttonStyle(.borderedProminent).disabled(!revealed)
                        Text("忘记后 1 分钟再练；记住后按 1、3、7、14、30 天复习。")
                            .font(.caption).foregroundStyle(.secondary)
                    } else {
                        Label("本轮完成，稍后再来复习", systemImage: "checkmark.seal.fill")
                            .font(.title3).padding(30).appGlassSurface()
                        if let next = store.reviews.values.map(\.due).min() {
                            Text("下次复习：\(next.formatted(date: .abbreviated, time: .shortened))").font(.caption)
                        }
                    }
                    Button("导入自己的词库") { importing = true }.buttonStyle(.bordered)
                    Text(feedback).font(.caption).foregroundStyle(.secondary)
                    Text("内置 40 个入门词。考试、词根与旅行卡是学习主题模板，可导入对应内容；不包含完整考试题库。")
                        .font(.caption).foregroundStyle(.secondary)
                }.padding(20)
            }
        }
        .background(AppCanvas()).navigationTitle("词汇学习")
        .sheet(isPresented: $importing) {
            NavigationStack {
                VStack(spacing: 16) {
                    Text("每行：英文 | 中文 | 例句（可选）\n相同英文会更新词义并重置该词进度。")
                    TextEditor(text: $importText).frame(minHeight: 220).border(.secondary.opacity(0.2))
                    Button("导入并保存") {
                        let count = store.importWords(importText)
                        feedback = count > 0 ? "已导入 \(count) 词" : "未找到有效行，请检查分隔符。"
                        revealed = false
                        if count > 0 { importing = false; importText = "" }
                    }.buttonStyle(.borderedProminent)
                    Text(feedback).font(.caption)
                }.padding().navigationTitle("导入词库")
                    .toolbar { Button("关闭") { importing = false } }
            }
        }
    }

    private func grade(_ word: VocabularyWord, known: Bool) {
        store.grade(word, known: known)
        revealed = false
    }
}
