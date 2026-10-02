package com.workdayglow.android.data

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject

data class VocabularyWord(val word: String, val meaning: String, val example: String = "") {
    val id: String get() = word.lowercase(java.util.Locale.ROOT)
}

data class VocabularyReview(val level: Int = 0, val due: Long = 0, val attempts: Int = 0) {
    fun grade(known: Boolean, now: Long): VocabularyReview {
        val next = if (known) (level + 1).coerceAtMost(5) else 0
        val delay = if (known) listOf(0L, 1L, 3L, 7L, 14L, 30L)[next] * 86_400_000L else 60_000L
        return VocabularyReview(next, now + delay, attempts + 1)
    }
}

object VocabularyImport {
    fun parse(text: String): List<VocabularyWord> = text.lineSequence().take(500).mapNotNull { line ->
        val fields = line.split(if ('\t' in line) '\t' else '|').map(String::trim)
        if (fields.size < 2 || fields[0].isEmpty() || fields[1].isEmpty() || fields[0].length > 80 || fields[1].length > 300) null
        else VocabularyWord(fields[0], fields[1], fields.getOrElse(2) { "" }.take(500))
    }.toList().asReversed().distinctBy { it.id }.asReversed()
}

class VocabularyRepository(context: Context) {
    private val prefs = context.applicationContext.getSharedPreferences("vocabulary", Context.MODE_PRIVATE)
    fun words(): List<VocabularyWord> = runCatching {
        val json = JSONArray(prefs.getString("words", null) ?: JSONArray().also { seed ->
            vocabularySeed.forEach { seed.put(JSONObject().put("word", it.word).put("meaning", it.meaning).put("example", it.example)) }
        }.toString())
        (0 until json.length()).map {
            val item = json.getJSONObject(it)
            VocabularyWord(item.getString("word"), item.getString("meaning"), item.optString("example"))
        }
    }.getOrDefault(vocabularySeed)

    fun review(word: VocabularyWord): VocabularyReview = VocabularyReview(
        prefs.getInt("${word.id}.level", 0), prefs.getLong("${word.id}.due", 0), prefs.getInt("${word.id}.attempts", 0))
    fun next(now: Long = System.currentTimeMillis()): VocabularyWord? = words().filter { review(it).due <= now }
        .sortedWith(compareBy<VocabularyWord> { review(it).due }.thenBy { it.id }).firstOrNull()
    fun grade(word: VocabularyWord, known: Boolean) {
        val result = review(word).grade(known, System.currentTimeMillis())
        prefs.edit().putInt("${word.id}.level", result.level).putLong("${word.id}.due", result.due)
            .putInt("${word.id}.attempts", result.attempts).apply()
    }
    fun importWords(text: String): Int {
        val incoming = VocabularyImport.parse(text)
        val ids = incoming.map { it.id }.toSet()
        val merged = words().filterNot { it.id in ids } + incoming
        val json = JSONArray()
        merged.forEach { json.put(JSONObject().put("word", it.word).put("meaning", it.meaning).put("example", it.example)) }
        val edit = prefs.edit().putString("words", json.toString())
        incoming.forEach { edit.remove("${it.id}.level").remove("${it.id}.due").remove("${it.id}.attempts") }
        edit.apply()
        return incoming.size
    }
}
