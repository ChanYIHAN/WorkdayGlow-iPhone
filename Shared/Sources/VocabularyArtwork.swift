import SwiftUI

struct VocabularyArtwork: View {
    let template: WidgetTemplateKind
    let word: VocabularyWord
    let size: WidgetArtworkSize
    var revealed = false

    var body: some View {
        VStack(alignment: .leading, spacing: size == .small ? 8 : 12) {
            Label(template.title, systemImage: template.symbolName)
                .font(.caption.weight(.semibold))
            Spacer(minLength: 0)
            Text(revealed ? word.meaning : word.word)
                .font(.system(size: size == .small ? 25 : 32, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.55).lineLimit(2)
            if size != .small {
                Text(revealed ? word.example : "先回想词义，再翻面核对")
                    .font(.caption).lineLimit(size == .large ? 4 : 2)
            }
            Text(revealed ? word.word : "ENGLISH · 每天一点")
                .font(.caption2.weight(.medium)).opacity(0.7)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(size == .small ? 16 : 20)
        .foregroundStyle([1, 3].contains(template.expansionMetadata?.palette ?? 0) ? Color.white : Color("PlumInk"))
        .accessibilityElement(children: .combine)
    }
}
