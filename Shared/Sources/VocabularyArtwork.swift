import SwiftUI

struct VocabularyArtwork: View {
    let template: WidgetTemplateKind
    let word: VocabularyWord
    let size: WidgetArtworkSize
    var revealed = false

    var body: some View {
        VStack(alignment: .leading, spacing: size == .large ? 12 : 6) {
            Label(template.title, systemImage: template.symbolName)
                .font(.caption2.weight(.semibold)).lineLimit(1)
            Rectangle().fill(Color(atelierHex: template.design.palette[3]).opacity(0.4)).frame(height: 0.5)
            Spacer(minLength: 0)
            if template.design.layout == .constellation {
                HStack(spacing: 6) {
                    ForEach(0..<7) { index in
                        Circle().fill(Color(atelierHex: template.design.palette[3]).opacity(index < 5 ? 0.8 : 0.2)).frame(width: 5, height: 5)
                    }
                }.accessibilityHidden(true)
            }
            if template.design.layout == .ticket {
                HStack {
                    Text("EN → ZH").tracking(1.5)
                    Spacer()
                    Image(systemName: "arrow.triangle.2.circlepath")
                }.font(.system(size: 9, weight: .medium)).opacity(0.7)
            }
            Text(revealed ? word.meaning : word.word)
                .font(.system(size: size == .large ? 34 : 24, weight: .semibold, design: .serif))
                .minimumScaleFactor(0.72).lineLimit(size == .large ? 2 : 1)
            if size != .small {
                if size == .large && (template.design.layout == .bento || template.design.layout == .list) {
                    HStack(alignment: .top, spacing: 12) {
                        Text("01\n回想").font(.system(size: 10, weight: .medium)).opacity(0.65)
                        Rectangle().fill(Color(atelierHex: template.design.palette[3]).opacity(0.3)).frame(width: 0.5)
                        Text("02\n核对").font(.system(size: 10, weight: .medium)).opacity(0.65)
                    }.frame(height: 28)
                }
                Text(revealed ? word.example : "先回想词义，再翻面核对")
                    .font(.caption).lineLimit(size == .large ? 4 : 1)
            }
            Text(revealed ? word.word : "ENGLISH · 每天一点")
                .font(.caption2.weight(.medium)).opacity(0.7)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(size == .large ? 20 : 14)
        .foregroundStyle(Color(atelierHex: template.design.palette[2]))
        .accessibilityElement(children: .combine)
    }
}
