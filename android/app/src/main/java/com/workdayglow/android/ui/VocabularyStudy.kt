package com.workdayglow.android.ui

import android.speech.tts.TextToSpeech
import androidx.glance.appwidget.updateAll
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.workdayglow.android.data.VocabularyRepository
import com.workdayglow.android.data.VocabularyWord
import kotlinx.coroutines.delay
import java.util.Locale

@Composable
fun VocabularyStudy(opaque: Boolean, motion: Boolean) {
    val context = LocalContext.current
    val repo = remember { VocabularyRepository(context) }
    var revision by remember { mutableIntStateOf(0) }
    var now by remember { mutableLongStateOf(System.currentTimeMillis()) }
    var revealed by rememberSaveable { mutableStateOf(false) }
    var importing by remember { mutableStateOf(false) }
    var text by rememberSaveable { mutableStateOf("") }
    var message by remember { mutableStateOf("") }
    var speaker by remember { mutableStateOf<TextToSpeech?>(null) }
    var speechReady by remember { mutableStateOf(false) }
    DisposableEffect(context) {
        val engine = TextToSpeech(context) { status -> speechReady = status == TextToSpeech.SUCCESS }
        speaker = engine
        onDispose { engine.stop(); engine.shutdown() }
    }
    LaunchedEffect(Unit) { while (true) { delay(15_000); now = System.currentTimeMillis() } }
    LaunchedEffect(revision) { com.workdayglow.android.widget.VocabularyWidget().updateAll(context) }
    androidx.lifecycle.compose.LifecycleResumeEffect(Unit) {
        revision++
        onPauseOrDispose { }
    }
    val word = remember(revision, now) { repo.next(now) }
    val words = remember(revision) { repo.words() }
    fun grade(current: VocabularyWord, known: Boolean) {
        repo.grade(current, known); revision++; revealed = false
    }
    Column(Modifier.fillMaxSize().verticalScroll(rememberScrollState()).padding(22.dp), verticalArrangement = Arrangement.spacedBy(18.dp)) {
        Text("词汇学习", style = MaterialTheme.typography.headlineLarge, fontWeight = FontWeight.Bold)
        Text("已学习 ${words.count { repo.review(it).level > 0 }} / ${words.size} 词")
        Column(Modifier.fillMaxWidth().liquidGlass(30, opaque).padding(24.dp), verticalArrangement = Arrangement.spacedBy(18.dp)) {
            if (word != null) {
                AnimatedContent(targetState = revealed, transitionSpec = { fadeIn(tween(if (motion) 220 else 0)) togetherWith fadeOut(tween(if (motion) 120 else 0)) }, label = "word flip") { back ->
                    Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                        Text(if (back) word.meaning else word.word, style = MaterialTheme.typography.headlineLarge, fontWeight = FontWeight.Bold)
                        if (back) { Text(word.word); Text(word.example) }
                    }
                }
                OutlinedButton(onClick = {
                    val engine = speaker
                    if (engine != null && speechReady) {
                        val language = engine.setLanguage(Locale.US)
                        if (language >= 0) engine.speak(word.word, TextToSpeech.QUEUE_FLUSH, null, word.id)
                        else message = "请先安装设备的英语语音包。"
                    }
                }, enabled = speechReady) { Text("朗读单词") }
                Button(onClick = { revealed = !revealed }) { Text(if (revealed) "查看英文" else "翻面 · 查看词义") }
                Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                    OutlinedButton(onClick = { grade(word, false) }, enabled = revealed) { Text("再想一想") }
                    Button(onClick = { grade(word, true) }, enabled = revealed) { Text("记住了") }
                }
            } else Text("本轮完成，稍后再来复习。")
        }
        Text("忘记后 1 分钟再练；记住后按 1、3、7、14、30 天复习。", style = MaterialTheme.typography.bodySmall)
        Text("内置 40 个入门词。主题卡可搭配自定义内容，不包含完整考试题库。", style = MaterialTheme.typography.bodySmall)
        OutlinedButton(onClick = { importing = true }) { Text("导入自己的词库") }
        Text(message)
    }
    if (importing) AlertDialog(onDismissRequest = { importing = false }, title = { Text("导入词库") }, text = {
        Column { Text("每行：英文 | 中文 | 例句（可选）\n相同英文更新内容并重置进度。"); OutlinedTextField(value = text, onValueChange = { text = it }, modifier = Modifier.height(220.dp)); Text(message) }
    }, confirmButton = { TextButton(onClick = {
        val count = repo.importWords(text)
        message = if (count > 0) "已导入 $count 词" else "未找到有效行，请检查格式。"
        if (count > 0) { revision++; revealed = false; importing = false; text = "" }
    }) { Text("导入并保存") } }, dismissButton = { TextButton(onClick = { importing = false }) { Text("取消") } })
}
