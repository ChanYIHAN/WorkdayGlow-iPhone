// Learning styles map to the shared catalog.
import AppIntents
enum VocabularyWidgetStyle: String, CaseIterable, AppEnum {
    case wordDaily
    case wordFlip
    case wordReview
    case wordProgress
    case wordStreak
    case wordRoots
    case wordExample
    case wordSynonyms
    case wordPhrase
    case wordSpelling
    case wordListening
    case wordTravel
    case wordWork
    case wordIELTS
    case wordCET
    case wordMistakes
    case wordGoal
    case readingNote
    case examSprint
    case languagePassport
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "学习卡样式"
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .wordDaily: "每日单词",
        .wordFlip: "单词翻面",
        .wordReview: "到期复习",
        .wordProgress: "词汇进度",
        .wordStreak: "学习连续日",
        .wordRoots: "词根拆解",
        .wordExample: "例句卡片",
        .wordSynonyms: "近义辨析",
        .wordPhrase: "短语积累",
        .wordSpelling: "拼写挑战",
        .wordListening: "听读练习",
        .wordTravel: "旅行英语",
        .wordWork: "职场英语",
        .wordIELTS: "雅思词汇",
        .wordCET: "四六级词汇",
        .wordMistakes: "易忘词夹",
        .wordGoal: "每日词汇目标",
        .readingNote: "阅读摘录",
        .examSprint: "考试冲刺",
        .languagePassport: "语言护照"
    ]
    var template: WidgetTemplateKind { WidgetTemplateKind(rawValue: rawValue) ?? .wordDaily }
}
