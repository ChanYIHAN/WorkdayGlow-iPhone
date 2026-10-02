package com.workdayglow.android.data

import org.junit.Assert.*
import org.junit.Test

class VocabularyTest {
    @Test fun reviewIntervalsAndReset() {
        val now = 1_000_000L
        var review = VocabularyReview()
        listOf(1L, 3L, 7L, 14L, 30L, 30L).forEachIndexed { index, days ->
            review = review.grade(true, now)
            assertEquals((index + 1).coerceAtMost(5), review.level)
            assertEquals(now + days * 86_400_000L, review.due)
        }
        review = review.grade(false, now)
        assertEquals(0, review.level)
        assertEquals(now + 60_000L, review.due)
        assertEquals(7, review.attempts)
    }
    @Test fun importRejectsInvalidRowsAndKeepsLatestDuplicate() {
        val words = VocabularyImport.parse("Test|测试|Example\ninvalid\ntest\t更新\tNew example\nempty|\n")
        assertEquals(1, words.size)
        assertEquals("更新", words.first().meaning)
        assertTrue(VocabularyImport.parse("x".repeat(81) + "|too long").isEmpty())
    }
    @Test fun allTemplatesAreUniqueAndLearningThemesArePresent() {
        assertEquals(200, WidgetCatalog.templates.size)
        assertEquals(200, WidgetCatalog.templates.map { it.id }.toSet().size)
        assertEquals(200, WidgetCatalog.templates.map { it.title }.toSet().size)
        assertEquals(22, WidgetCatalog.templates.count { it.category == WidgetCategory.Learning })
        assertEquals(200, AtelierCatalog.designs.size)
        assertEquals(WidgetCatalog.templates.map { it.title }.toSet(), AtelierCatalog.designs.keys)
        assertEquals(40, vocabularySeed.size)
    }
}
