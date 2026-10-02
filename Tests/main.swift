import Foundation

let now = Date(timeIntervalSince1970: 1_000_000)
var review = VocabularyReview()
for (index, days) in [1, 3, 7, 14, 30, 30].enumerated() {
    review.grade(known: true, now: now)
    precondition(review.level == min(index + 1, 5))
    precondition(review.due == now.addingTimeInterval(Double(days) * 86_400))
}
review.grade(known: false, now: now)
precondition(review.level == 0 && review.due == now.addingTimeInterval(60))
precondition(review.attempts == 7)
let imported = VocabularyImport.parse("\nTest | 测试 | An example.\ninvalid\ntest\t更新\tUpdated.\nempty|\n")
precondition(imported.count == 1 && imported[0].meaning == "更新")
precondition(VocabularyImport.parse(String(repeating: "x", count: 81) + "|too long").isEmpty)
let roundTrip = try JSONDecoder().decode(VocabularyReview.self, from: JSONEncoder().encode(review))
precondition(roundTrip.due == review.due && roundTrip.level == review.level)
precondition(WidgetTemplateKind.allCases.count == 150)
precondition(Set(WidgetTemplateKind.allCases.map(\.title)).count == 150)
for template in WidgetTemplateKind.allCases {
    precondition(!template.title.isEmpty && !template.subtitle.isEmpty && !template.supportedSizes.isEmpty)
}
precondition(WidgetTemplateKind.templates(for: .learning).count == 20)
precondition(VocabularySeed.words.count == 40)
print("Swift catalog, review intervals, import and persistence checks passed.")
