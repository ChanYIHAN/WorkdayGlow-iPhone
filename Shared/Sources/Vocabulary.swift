import Foundation

struct VocabularyWord: Codable, Identifiable, Equatable, Sendable {
    let word: String
    let meaning: String
    var example: String = ""
    var id: String { word.lowercased() }
}

struct VocabularyReview: Codable, Sendable {
    var level: Int = 0
    var due: Date = .distantPast
    var attempts: Int = 0

    mutating func grade(known: Bool, now: Date) {
        attempts += 1
        level = known ? min(level + 1, 5) : 0
        let days = [0, 1, 3, 7, 14, 30]
        due = now.addingTimeInterval(known ? Double(days[level]) * 86_400 : 60)
    }
}

enum VocabularyImport {
    // A tab or | separates word, meaning, and optional example. Repeated words replace earlier rows.
    static func parse(_ text: String) -> [VocabularyWord] {
        var words: [VocabularyWord] = []
        for line in text.split(whereSeparator: \.isNewline).prefix(500) {
            let fields = line.components(separatedBy: line.contains("\t") ? "\t" : "|")
                .map { $0.trimmingCharacters(in: .whitespaces) }
            guard fields.count >= 2, !fields[0].isEmpty, !fields[1].isEmpty,
                  fields[0].count <= 80, fields[1].count <= 300 else { continue }
            let word = VocabularyWord(word: fields[0], meaning: fields[1], example: fields.count > 2 ? String(fields[2].prefix(500)) : "")
            words.removeAll { $0.id == word.id }
            words.append(word)
        }
        return words
    }
}
