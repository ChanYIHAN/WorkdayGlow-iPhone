package com.workdayglow.android.ui

import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.togetherWith
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Analytics
import androidx.compose.material.icons.rounded.Bolt
import androidx.compose.material.icons.rounded.Favorite
import androidx.compose.material.icons.rounded.Home
import androidx.compose.material.icons.rounded.Search
import androidx.compose.material.icons.rounded.Settings
import androidx.compose.material.icons.rounded.Tune
import androidx.compose.material.icons.rounded.Widgets
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FilterChip
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.platform.LocalContext
import androidx.compose.foundation.clickable
import androidx.compose.material3.Button
import androidx.compose.material3.Switch
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.workdayglow.android.data.WidgetCatalog
import com.workdayglow.android.data.WidgetCategory
import com.workdayglow.android.data.WidgetLayout
import com.workdayglow.android.data.WidgetTemplate

private data class AppTab(val title: String, val icon: ImageVector)

private val appTabs = listOf(
    AppTab("发现", Icons.Rounded.Home),
    AppTab("组件", Icons.Rounded.Widgets),
    AppTab("学习", Icons.Rounded.Bolt),
    AppTab("概览", Icons.Rounded.Analytics),
    AppTab("设置", Icons.Rounded.Tune)
)

@Composable
fun WorkdayGlowApp(studyLaunchId: Int = 0) {
    val prefs = LocalContext.current.getSharedPreferences("appearance", android.content.Context.MODE_PRIVATE)
    var selectedTab by rememberSaveable { mutableIntStateOf(0) }
    var opaque by remember { mutableStateOf(prefs.getBoolean("opaque", false)) }
    var motion by remember { mutableStateOf(prefs.getBoolean("motion", true)) }

    androidx.compose.runtime.LaunchedEffect(studyLaunchId) { if (studyLaunchId > 0) selectedTab = 2 }

    Scaffold(
        modifier = Modifier.background(Brush.linearGradient(listOf(MaterialTheme.colorScheme.background, MaterialTheme.colorScheme.primaryContainer.copy(alpha = 0.45f), MaterialTheme.colorScheme.secondaryContainer.copy(alpha = 0.35f)))),
        containerColor = Color.Transparent,
        bottomBar = {
            NavigationBar(containerColor = Color.Transparent, modifier = Modifier.navigationBarsPadding().padding(horizontal = 12.dp, vertical = 6.dp).liquidGlass(30, opaque)) {
                appTabs.forEachIndexed { index, tab ->
                    NavigationBarItem(
                        selected = selectedTab == index,
                        onClick = { selectedTab = index },
                        icon = { Icon(tab.icon, contentDescription = tab.title) },
                        label = { Text(tab.title) }
                    )
                }
            }
        }
    ) { innerPadding ->
        AnimatedContent(
            targetState = selectedTab,
            transitionSpec = { fadeIn(tween(if (motion) 220 else 0)) togetherWith fadeOut(tween(if (motion) 160 else 0)) },
            label = "tab content",
            modifier = Modifier.padding(innerPadding)
        ) { tab ->
            when (tab) {
                0, 1 -> WidgetGalleryScreen(showDiscoveryHero = tab == 0, opaque = opaque, onStudy = { selectedTab = 2 })
                2 -> VocabularyStudy(opaque, motion)
                3 -> PlaceholderScreen("今日概览", "下班、活动、日程与行情摘要", Icons.Rounded.Analytics)
                else -> Column(Modifier.fillMaxSize().padding(24.dp), verticalArrangement = Arrangement.spacedBy(20.dp)) {
                    Text("外观与动效", style = MaterialTheme.typography.headlineLarge)
                    Row(verticalAlignment = Alignment.CenterVertically) { Text("使用不透明背景", Modifier.weight(1f)); Switch(checked = opaque, onCheckedChange = { opaque = it; prefs.edit().putBoolean("opaque", it).apply() }) }
                    Row(verticalAlignment = Alignment.CenterVertically) { Text("轻量动效", Modifier.weight(1f)); Switch(checked = motion, onCheckedChange = { motion = it; prefs.edit().putBoolean("motion", it).apply() }) }
                    Text("玻璃风格使用原生渐变、通透底色与反光边缘。桌面卡片受系统刷新限制，动画在应用中播放。")
                }
            }
        }
    }
}

@Composable
private fun PlaceholderScreen(title: String, subtitle: String, icon: ImageVector) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .statusBarsPadding()
            .padding(24.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        Icon(icon, contentDescription = null, modifier = Modifier.size(44.dp))
        Text(title, style = MaterialTheme.typography.headlineLarge, fontWeight = FontWeight.Bold)
        Text(subtitle, color = MaterialTheme.colorScheme.onSurfaceVariant)
    }
}

@Composable
private fun WidgetGalleryScreen(showDiscoveryHero: Boolean, opaque: Boolean, onStudy: () -> Unit) {
    var query by remember { mutableStateOf("") }
    var category by remember { mutableStateOf(WidgetCategory.Featured) }
    val templates = remember(query, category) {
        WidgetCatalog.templates.filter {
            (category == WidgetCategory.Featured || it.category == category) &&
                (query.isBlank() || it.title.contains(query, true) || it.subtitle.contains(query, true))
        }
    }

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .statusBarsPadding(),
        contentPadding = androidx.compose.foundation.layout.PaddingValues(bottom = 28.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        item {
            Column(
                modifier = Modifier.padding(horizontal = 20.dp, vertical = 12.dp),
                verticalArrangement = Arrangement.spacedBy(14.dp)
            ) {
                Text(
                    if (showDiscoveryHero) "发现" else "组件库",
                    style = MaterialTheme.typography.displaySmall,
                    fontWeight = FontWeight.Bold
                )

                if (showDiscoveryHero) DiscoveryHero()
                Button(onClick = onStudy) { Text("开始背单词 · 本地词库与间隔复习") }

                OutlinedTextField(
                    value = query,
                    onValueChange = { query = it },
                    modifier = Modifier.fillMaxWidth(),
                    singleLine = true,
                    shape = RoundedCornerShape(22.dp),
                    leadingIcon = { Icon(Icons.Rounded.Search, contentDescription = null) },
                    placeholder = { Text("搜索时间、健康、天气或行情") },
                    keyboardActions = KeyboardActions.Default
                )
            }
        }

        item {
            Row(
                modifier = Modifier
                    .horizontalScroll(rememberScrollState())
                    .padding(horizontal = 20.dp),
                horizontalArrangement = Arrangement.spacedBy(10.dp)
            ) {
                WidgetCategory.entries.forEach { item ->
                    FilterChip(
                        selected = category == item,
                        onClick = { category = item },
                        label = { Text(item.title) },
                        modifier = Modifier.height(48.dp)
                    )
                }
            }
        }

        item {
            Row(
                modifier = Modifier.padding(horizontal = 20.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column {
                    Text("200 款原创模板", style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
                    Text("三端同名目录 · 原生桌面组件", color = MaterialTheme.colorScheme.onSurfaceVariant)
                }
                Spacer(Modifier.weight(1f))
                Text("${templates.size} 款", color = MaterialTheme.colorScheme.primary, fontWeight = FontWeight.Bold)
            }
        }

        items(templates, key = { it.id }) { template ->
            WidgetTemplateCard(template, Modifier.padding(horizontal = 20.dp), opaque, onStudy)
        }
    }
}

@Composable
private fun DiscoveryHero() {
    val shape = RoundedCornerShape(32.dp)
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clip(shape)
            .background(
                Brush.linearGradient(
                    listOf(
                        Color(0xFFD7FAF2).copy(alpha = 0.72f),
                        Color(0xFFE7DFFF).copy(alpha = 0.8f),
                        MaterialTheme.colorScheme.surface
                    )
                )
            )
            .border(1.dp, MaterialTheme.colorScheme.outlineVariant.copy(alpha = 0.5f), shape)
            .padding(22.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Text("EKHART WIDGETS", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.primary)
        Text("让每一刻\n恰好可见", style = MaterialTheme.typography.headlineLarge, fontWeight = FontWeight.Bold)
        Text("奕刻 · 200 款原创设计 · 三端同名目录", color = MaterialTheme.colorScheme.onSurfaceVariant)
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            HeroTag("健康", Color(0xFFFF8D90))
            HeroTag("日程", Color(0xFF65C7FF))
            HeroTag("生活", Color(0xFFAD91ED))
        }
    }
}

@Composable
private fun HeroTag(text: String, tint: Color) {
    Text(
        text,
        modifier = Modifier
            .clip(CircleShape)
            .background(tint.copy(alpha = 0.14f))
            .padding(horizontal = 13.dp, vertical = 8.dp),
        color = tint,
        style = MaterialTheme.typography.labelLarge
    )
}

@Composable
private fun WidgetTemplateCard(template: WidgetTemplate, modifier: Modifier = Modifier, opaque: Boolean = false, onStudy: () -> Unit = {}) {
    Card(
        modifier = modifier
            .fillMaxWidth()
            .liquidGlass(28, opaque)
            .then(if (template.category == WidgetCategory.Learning) Modifier.clickable(onClick = onStudy) else Modifier)
            .semantics { contentDescription = "${template.title}，${template.subtitle}" },
        shape = RoundedCornerShape(28.dp),
        colors = CardDefaults.cardColors(containerColor = Color.Transparent),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Column(Modifier.padding(14.dp), verticalArrangement = Arrangement.spacedBy(12.dp)) {
            AtelierArtwork(template)
            Text(if (template.category == WidgetCategory.Learning) "点击开始学习 · 可导入个人词库" else "本地示例 · 暂无实时数据", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
            Row(verticalAlignment = Alignment.CenterVertically) {
                Column(Modifier.weight(1f)) {
                    Text(template.title, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
                    Text(
                        template.subtitle,
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis
                    )
                }
                Text(template.category.title, color = MaterialTheme.colorScheme.primary, style = MaterialTheme.typography.labelMedium)
            }
        }
    }
}
