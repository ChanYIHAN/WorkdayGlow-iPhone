package com.workdayglow.android.widget

import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.DpSize
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.LocalSize
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetReceiver
import androidx.glance.appwidget.SizeMode
import androidx.glance.appwidget.action.actionStartActivity
import androidx.glance.appwidget.appWidgetBackground
import androidx.glance.appwidget.cornerRadius
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.defaultWeight
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxHeight
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.size
import androidx.glance.layout.width
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import com.workdayglow.android.MainActivity

class WorkdayGlowWidget : GlanceAppWidget() {
    override val sizeMode: SizeMode = SizeMode.Responsive(
        setOf(
            DpSize(110.dp, 110.dp),
            DpSize(250.dp, 110.dp),
            DpSize(250.dp, 180.dp)
        )
    )

    override suspend fun provideGlance(context: android.content.Context, id: GlanceId) {
        provideContent {
            WorkdayGlowWidgetContent(LocalSize.current.width >= 220.dp)
        }
    }
}

class WorkdayGlowWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget: GlanceAppWidget = WorkdayGlowWidget()
}

@Composable
private fun WorkdayGlowWidgetContent(isWide: Boolean) {
    val white = ColorProvider(Color.White)
    val secondary = ColorProvider(Color(0xFFA8A4B4))
    val coral = ColorProvider(Color(0xFFFF8D90))
    val mint = ColorProvider(Color(0xFF5FE0C2))
    val lavender = ColorProvider(Color(0xFFCAB8FF))

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(ColorProvider(Color(0xFF1D1C27)))
            .cornerRadius(28.dp)
            .appWidgetBackground()
            .clickable(actionStartActivity<MainActivity>())
            .padding(16.dp)
    ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Text("今日活力", style = TextStyle(color = white, fontSize = 17.sp, fontWeight = FontWeight.Bold))
            Spacer(GlanceModifier.defaultWeight())
            Text("72%", style = TextStyle(color = mint, fontSize = 13.sp, fontWeight = FontWeight.Bold))
        }

        Spacer(GlanceModifier.height(13.dp))

        if (isWide) {
            Row(modifier = GlanceModifier.fillMaxWidth().fillMaxHeight()) {
                Metric("6,842", "步数", coral)
                Spacer(GlanceModifier.width(9.dp))
                Metric("4.8 km", "距离", mint)
                Spacer(GlanceModifier.width(9.dp))
                Metric("386", "千卡", lavender)
            }
        } else {
            Text("6,842", style = TextStyle(color = coral, fontSize = 28.sp, fontWeight = FontWeight.Bold))
            Text("今日步数", style = TextStyle(color = secondary, fontSize = 12.sp))
            Spacer(GlanceModifier.defaultWeight())
            Text("4.8 km · 386 千卡", style = TextStyle(color = white, fontSize = 12.sp))
        }
    }
}

@Composable
private fun Metric(value: String, label: String, tint: ColorProvider) {
    Box(
        modifier = GlanceModifier
            .defaultWeight()
            .fillMaxHeight()
            .background(ColorProvider(Color(0xFF2B2938)))
            .cornerRadius(16.dp)
            .padding(10.dp),
        contentAlignment = Alignment.CenterStart
    ) {
        Column {
            Box(GlanceModifier.size(8.dp).background(tint).cornerRadius(4.dp)) {}
            Spacer(GlanceModifier.height(8.dp))
            Text(value, style = TextStyle(color = ColorProvider(Color.White), fontSize = 16.sp, fontWeight = FontWeight.Bold))
            Text(label, style = TextStyle(color = ColorProvider(Color(0xFFA8A4B4)), fontSize = 10.sp))
        }
    }
}
