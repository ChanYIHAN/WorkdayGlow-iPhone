package com.workdayglow.android.widget

import android.content.Context
import android.content.Intent
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.DpSize
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.*
import androidx.glance.action.ActionParameters
import androidx.glance.action.actionParametersOf
import androidx.glance.action.clickable
import androidx.glance.appwidget.*
import androidx.glance.appwidget.action.ActionCallback
import androidx.glance.appwidget.action.actionRunCallback
import androidx.glance.appwidget.action.actionStartActivity
import androidx.glance.layout.*
import androidx.glance.text.*
import androidx.glance.unit.ColorProvider
import com.workdayglow.android.MainActivity
import com.workdayglow.android.data.VocabularyRepository

class VocabularyWidget : GlanceAppWidget() {
    override val sizeMode = SizeMode.Responsive(setOf(DpSize(150.dp, 150.dp), DpSize(280.dp, 150.dp)))
    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val repo = VocabularyRepository(context)
        val word = repo.next()
        val prefs = context.getSharedPreferences("vocabulary", Context.MODE_PRIVATE)
        val revealed = word != null && prefs.getBoolean("widget.${word.id}.revealed", false)
        provideContent {
            Column(GlanceModifier.fillMaxSize().background(ColorProvider(Color(0xFFF0F5F1))).cornerRadius(28.dp).appWidgetBackground().padding(16.dp)) {
                Text("词汇学习", style = TextStyle(color = ColorProvider(Color(0xFF287B67)), fontSize = 13.sp))
                Spacer(GlanceModifier.height(10.dp))
                Text(if (word == null) "本轮完成 ✓" else if (revealed) word.meaning else word.word,
                    style = TextStyle(color = ColorProvider(Color(0xFF202B3A)), fontSize = 23.sp, fontWeight = FontWeight.Bold), maxLines = 2)
                Spacer(GlanceModifier.height(8.dp))
                if (word != null) {
                    Text(if (revealed) word.word else "先回想，再翻面", style = TextStyle(color = ColorProvider(Color(0xFF625F6C)), fontSize = 12.sp))
                    Row {
                        Button(if (revealed) "英文" else "翻面", onClick = actionRunCallback<VocabularyAction>(actionParametersOf(WordKey to word.id, ActionKey to "flip")))
                        if (revealed) Button("记住了", onClick = actionRunCallback<VocabularyAction>(actionParametersOf(WordKey to word.id, ActionKey to "known")))
                    }
                }
                Text("打开学习 →", modifier = GlanceModifier.clickable(actionStartActivity(Intent(context, MainActivity::class.java).putExtra("study", true))),
                    style = TextStyle(color = ColorProvider(Color(0xFF287B67)), fontSize = 12.sp))
            }
        }
    }
}

val WordKey = ActionParameters.Key<String>("word")
val ActionKey = ActionParameters.Key<String>("action")
class VocabularyAction : ActionCallback {
    override suspend fun onAction(context: Context, glanceId: GlanceId, parameters: ActionParameters) {
        val id = parameters[WordKey] ?: return
        val prefs = context.getSharedPreferences("vocabulary", Context.MODE_PRIVATE)
        val key = "widget.$id.revealed"
        if (parameters[ActionKey] == "flip") prefs.edit().putBoolean(key, !prefs.getBoolean(key, false)).apply()
        else {
            val repo = VocabularyRepository(context)
            val word = repo.words().firstOrNull { it.id == id } ?: return
            repo.grade(word, true)
            prefs.edit().remove(key).apply()
        }
        VocabularyWidget().updateAll(context)
    }
}

class VocabularyWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget: GlanceAppWidget = VocabularyWidget()
}
