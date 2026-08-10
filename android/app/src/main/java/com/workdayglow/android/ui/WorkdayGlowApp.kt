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
    AppTab("工具", Icons.Rounded.Bolt),
    AppTab("概览", Icons.Rounded.Analytics),
    AppTab("设置", Icons.Rounded.Tune)
)

@Composable
fun WorkdayGlowApp() {
    var selectedTab by remember { mutableIntStateOf(0) }

    Scaffold(
        containerColor = MaterialTheme.colorScheme.background,
        bottomBar = {
            NavigationBar(modifier = Modifier.navigationBarsPadding()) {
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
            transitionSpec = { fadeIn(tween(220)) togetherWith fadeOut(tween(160)) },
            label = "tab content",
            modifier = Modifier.padding(innerPadding)
        ) { tab ->
            when (tab) {
                0, 1 -> WidgetGalleryScreen(showDiscoveryHero = tab == 0)
                2 -> PlaceholderScreen("快捷工具", "通过系统快捷方式与深层链接打开常用操作", Icons.Rounded.Bolt)
                3 -> PlaceholderScreen("今日概览", "下班、活动、日程与行情摘要", Icons.Rounded.Analytics)
                else -> PlaceholderScreen("设置", "主题、隐私、健康授权与数据来源", Icons.Rounded.Settings)
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
private fun WidgetGalleryScreen(showDiscoveryHero: Boolean) {
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
                    Text("100 款原创模板", style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
                    Text("三端同名目录 · 原生桌面组件", color = MaterialTheme.colorScheme.onSurfaceVariant)
                }
                Spacer(Modifier.weight(1f))
                Text("${templates.size} 款", color = MaterialTheme.colorScheme.primary, fontWeight = FontWeight.Bold)
            }
        }

        items(templates, key = { it.id }) { template ->
            WidgetTemplateCard(template, Modifier.padding(horizontal = 20.dp))
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
        Text("奕刻 · 100 款原创设计 · 三端同名目录", color = MaterialTheme.colorScheme.onSurfaceVariant)
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
private fun WidgetTemplateCard(template: WidgetTemplate, modifier: Modifier = Modifier) {
    Card(
        modifier = modifier
            .fillMaxWidth()
            .semantics { contentDescription = "${template.title}，${template.subtitle}" },
        shape = RoundedCornerShape(28.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface.copy(alpha = 0.9f)),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Column(Modifier.padding(14.dp), verticalArrangement = Arrangement.spacedBy(12.dp)) {
            WidgetVisual(template)
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

@Composable
private fun WidgetVisual(template: WidgetTemplate) {
    val palettes = listOf(
        listOf(Color(0xFFF7F1E8), Color(0xFF7CE1C8)),
        listOf(Color(0xFF1D1C27), Color(0xFF34314A)),
        listOf(Color(0xFF65C7FF), Color(0xFFAD91ED)),
        listOf(Color(0xFF191824), Color(0xFF4A3E78)),
        listOf(Color(0xFFFFE27D), Color(0xFFFF9E9F)),
        listOf(Color(0xFFAD91ED), Color(0xFFFF8D90))
    )
    val colors = palettes[template.palette % palettes.size]
    val dark = template.palette == 1 || template.palette == 3
    val text = if (dark) Color.White else Color(0xFF1D1C27)
    val shape = RoundedCornerShape(24.dp)

    Box(
        modifier = Modifier
            .fillMaxWidth()
            .height(174.dp)
            .clip(shape)
            .background(Brush.linearGradient(colors))
            .padding(17.dp)
    ) {
        when (template.layout) {
            WidgetLayout.Orbit -> OrbitPreview(template.title, text)
            WidgetLayout.Bento -> BentoPreview(template.title, text)
            WidgetLayout.Timeline -> TimelinePreview(template.title, text)
            WidgetLayout.Poster -> PosterPreview(template.title, template.category, text)
            WidgetLayout.Gauge -> GaugePreview(template.title, text)
            WidgetLayout.List -> ListPreview(template.title, text)
        }
    }
}

@Composable
private fun OrbitPreview(title: String, text: Color) {
    Row(Modifier.fillMaxSize(), verticalAlignment = Alignment.CenterVertically) {
        Canvas(Modifier.size(118.dp)) {
            drawArc(text.copy(alpha = 0.12f), -90f, 360f, false, style = Stroke(13.dp.toPx()))
            drawArc(Color(0xFF5FE0C2), -90f, 260f, false, style = Stroke(13.dp.toPx(), cap = StrokeCap.Round))
            val inset = 21.dp.toPx()
            drawArc(Color(0xFFCAB8FF), -90f, 176f, false, topLeft = Offset(inset, inset), size = Size(size.width - inset * 2, size.height - inset * 2), style = Stroke(8.dp.toPx(), cap = StrokeCap.Round))
        }
        Column(Modifier.padding(start = 18.dp), verticalArrangement = Arrangement.spacedBy(7.dp)) {
            Text(title, color = text, fontWeight = FontWeight.Bold, fontSize = 19.sp)
            Text("72%", color = text, fontWeight = FontWeight.Black, fontSize = 30.sp)
            Text("今日状态", color = text.copy(alpha = 0.58f))
        }
    }
}

@Composable
private fun BentoPreview(title: String, text: Color) {
    Column(Modifier.fillMaxSize(), verticalArrangement = Arrangement.spacedBy(10.dp)) {
        Text(title, color = text, fontWeight = FontWeight.Bold, fontSize = 19.sp)
        Row(Modifier.fillMaxSize(), horizontalArrangement = Arrangement.spacedBy(9.dp)) {
            listOf("6,842" to "今日", "4.8 km" to "距离", "386" to "能量").forEachIndexed { index, item ->
                Column(
                    Modifier
                        .weight(1f)
                        .fillMaxSize()
                        .clip(RoundedCornerShape(16.dp))
                        .background(text.copy(alpha = 0.08f))
                        .padding(11.dp),
                    verticalArrangement = Arrangement.SpaceBetween
                ) {
                    Box(Modifier.size(9.dp).clip(CircleShape).background(listOf(Color(0xFFFF8D90), Color(0xFF5FE0C2), Color(0xFFAD91ED))[index]))
                    Text(item.first, color = text, fontWeight = FontWeight.Bold, maxLines = 1)
                    Text(item.second, color = text.copy(alpha = 0.56f), fontSize = 11.sp)
                }
            }
        }
    }
}

@Composable
private fun TimelinePreview(title: String, text: Color) {
    Column(Modifier.fillMaxSize(), verticalArrangement = Arrangement.SpaceBetween) {
        Text(title, color = text, fontWeight = FontWeight.Bold, fontSize = 19.sp)
        Row(Modifier.fillMaxWidth().height(92.dp), horizontalArrangement = Arrangement.spacedBy(8.dp), verticalAlignment = Alignment.Bottom) {
            listOf(0.38f, 0.62f, 0.48f, 0.82f, 1f, 0.66f, 0.52f).forEachIndexed { index, value ->
                Column(Modifier.weight(1f), horizontalAlignment = Alignment.CenterHorizontally) {
                    Box(Modifier.fillMaxWidth().height((68 * value).dp).clip(CircleShape).background(if (index == 4) Color(0xFF5FE0C2) else text.copy(alpha = 0.22f)))
                    Text("一二三四五六日"[index].toString(), color = text.copy(alpha = 0.55f), fontSize = 10.sp)
                }
            }
        }
    }
}

@Composable
private fun PosterPreview(title: String, category: WidgetCategory, text: Color) {
    Column(Modifier.fillMaxSize(), verticalArrangement = Arrangement.SpaceBetween) {
        Row { Text(category.title, color = text.copy(alpha = 0.56f), fontWeight = FontWeight.Bold) }
        Column {
            Text(if (category == WidgetCategory.Time) "09:41" else "TODAY", color = text, fontWeight = FontWeight.Black, fontSize = 34.sp)
            Text(title, color = text, fontWeight = FontWeight.Bold, fontSize = 20.sp)
        }
    }
}

@Composable
private fun GaugePreview(title: String, text: Color) {
    Column(Modifier.fillMaxSize(), verticalArrangement = Arrangement.spacedBy(13.dp)) {
        Text(title, color = text, fontWeight = FontWeight.Bold, fontSize = 19.sp)
        Text("72%", color = text, fontWeight = FontWeight.Black, fontSize = 38.sp)
        Box(Modifier.fillMaxWidth().height(12.dp).clip(CircleShape).background(text.copy(alpha = 0.12f))) {
            Box(Modifier.fillMaxWidth(0.72f).fillMaxSize().clip(CircleShape).background(Color(0xFF5FE0C2)))
        }
        Text("正在稳稳向目标靠近", color = text.copy(alpha = 0.58f))
    }
}

@Composable
private fun ListPreview(title: String, text: Color) {
    Column(Modifier.fillMaxSize(), verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Text(title, color = text, fontWeight = FontWeight.Bold, fontSize = 19.sp)
        listOf("09:30  第一项", "14:00  第二项", "19:30  今日状态").forEachIndexed { index, row ->
            Row(
                Modifier.fillMaxWidth().weight(1f).clip(RoundedCornerShape(12.dp)).background(text.copy(alpha = 0.08f)).padding(horizontal = 11.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Box(Modifier.size(8.dp).clip(CircleShape).background(listOf(Color(0xFF65C7FF), Color(0xFFAD91ED), Color(0xFF5FE0C2))[index]))
                Text(row, color = text, modifier = Modifier.padding(start = 9.dp), fontSize = 13.sp)
            }
        }
    }
}
