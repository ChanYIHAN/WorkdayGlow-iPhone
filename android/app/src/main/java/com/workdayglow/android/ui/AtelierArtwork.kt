package com.workdayglow.android.ui

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.workdayglow.android.data.AtelierCatalog
import com.workdayglow.android.data.AtelierDesign
import com.workdayglow.android.data.WidgetCategory
import com.workdayglow.android.data.WidgetTemplate
import kotlin.math.cos
import kotlin.math.sin

private fun pigment(value: String) = Color(android.graphics.Color.parseColor(value))

@Composable
fun AtelierArtwork(template: WidgetTemplate, compact: Boolean = false) {
    val design = AtelierCatalog.designs.getValue(template.title)
    val ink = pigment(design.palette[2])
    val accent = pigment(design.palette[3])
    val muted = pigment(design.palette[4])
    val shape = RoundedCornerShape(24.dp)
    val scale = LocalDensity.current.fontScale.coerceAtLeast(1f)
    Column(
        Modifier.fillMaxWidth().height(((if (compact) 180 else 190) * scale).dp).clip(shape)
            .background(Brush.linearGradient(listOf(pigment(design.palette[0]), pigment(design.palette[1]))))
            .border(0.8.dp, Brush.linearGradient(listOf(Color.White.copy(alpha = 0.5f), Color.White.copy(alpha = 0.05f))), shape)
            .padding(if (compact) 16.dp else 20.dp),
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        Text(design.eyebrow, color = muted, fontSize = 9.sp, letterSpacing = 1.5.sp, fontWeight = FontWeight.Medium, maxLines = 1)
        Box(Modifier.weight(1f).fillMaxWidth(), contentAlignment = Alignment.CenterStart) {
            when (design.layout) {
                "orbit", "dial" -> CircularComposition(design, ink, accent, compact)
                "bento" -> BentoComposition(design, ink, muted, compact)
                "timeline", "waveform" -> ChartComposition(design, ink, accent, muted, template.category == WidgetCategory.Music)
                "gauge" -> Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                    AtelierValue(design.value, ink)
                    Box(Modifier.fillMaxWidth().height(5.dp).clip(CircleShape).background(ink.copy(alpha = 0.09f))) {
                        Box(Modifier.fillMaxWidth(design.progress).fillMaxHeight().background(accent))
                    }
                    Text("${design.metrics[0].label} · ${design.metrics[0].value}", color = muted, fontSize = 10.sp)
                }
                "list" -> Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    design.rows.take(if (compact) 2 else 3).forEachIndexed { index, row ->
                        Row(Modifier.fillMaxWidth(), verticalAlignment = Alignment.CenterVertically) {
                            Text("0${index + 1}", color = accent, fontSize = 9.sp, modifier = Modifier.padding(end = 10.dp))
                            Text(row.label, color = ink, fontSize = 12.sp, modifier = Modifier.weight(1f), maxLines = 1)
                            Text(row.value, color = muted, fontSize = 11.sp, maxLines = 1)
                        }
                        if (index < 2) Box(Modifier.fillMaxWidth().height(0.5.dp).background(ink.copy(alpha = 0.1f)))
                    }
                }
                "ticket" -> Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                    AtelierValue(design.value, ink)
                    Canvas(Modifier.fillMaxWidth().height(1.dp)) {
                        var x = 0f
                        while (x < size.width) { drawLine(ink.copy(alpha = 0.22f), Offset(x, 0f), Offset(x + 3.dp.toPx(), 0f), 0.7.dp.toPx()); x += 7.dp.toPx() }
                    }
                    Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                        design.metrics.take(if (compact) 2 else 3).forEach { row ->
                            Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(3.dp)) {
                                Text(row.label, color = muted, fontSize = 8.sp)
                                Text(row.value, color = ink, fontSize = 11.sp, maxLines = 1)
                            }
                        }
                    }
                }
                "constellation" -> Column(verticalArrangement = Arrangement.spacedBy(14.dp)) {
                    AtelierValue(design.value, ink)
                    Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                        repeat(7) { column ->
                            Column(verticalArrangement = Arrangement.spacedBy(7.dp)) {
                                repeat(3) { row -> Box(Modifier.size(8.dp).clip(CircleShape).background(if ((column * 3 + row) / 21f < design.progress) accent else ink.copy(alpha = 0.1f))) }
                            }
                        }
                    }
                }
                "mosaic" -> MosaicComposition(design, ink, accent, compact)
                else -> Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
                    Box(Modifier.width(28.dp).height(1.dp).background(accent.copy(alpha = 0.7f)))
                    AtelierValue(design.value, ink, serif = design.layout == "editorial")
                    Text(design.caption, color = muted, fontSize = 11.sp, maxLines = 2)
                }
            }
        }
        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
            Text(template.title, color = ink, fontSize = 11.sp, fontWeight = FontWeight.Medium, maxLines = 1)
            if (!compact) Text("EKHART", color = muted, fontSize = 8.sp, letterSpacing = 1.sp)
        }
    }
}

@Composable private fun AtelierValue(value: String, ink: Color, serif: Boolean = false) {
    Text(value, color = ink, fontSize = 27.sp, fontFamily = if (serif) FontFamily.Serif else FontFamily.Default,
        fontWeight = if (serif) FontWeight.Normal else FontWeight.Medium, maxLines = 2, overflow = TextOverflow.Ellipsis)
}

@Composable private fun CircularComposition(d: AtelierDesign, ink: Color, accent: Color, compact: Boolean) {
    Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(18.dp)) {
        Canvas(Modifier.size(if (compact) 78.dp else 90.dp)) {
            if (d.layout == "dial") {
                val center = Offset(size.width / 2, size.height / 2)
                val radius = size.width / 2 - 6.dp.toPx()
                repeat(36) { tick ->
                    val angle = tick * Math.PI / 18
                    val length = if (tick % 3 == 0) 8.dp.toPx() else 4.dp.toPx()
                    val start = Offset(center.x + (cos(angle) * radius).toFloat(), center.y + (sin(angle) * radius).toFloat())
                    val end = Offset(center.x + (cos(angle) * (radius - length)).toFloat(), center.y + (sin(angle) * (radius - length)).toFloat())
                    drawLine(if (tick % 3 == 0) accent else ink.copy(alpha = 0.2f), start, end, 1.dp.toPx())
                }
                drawCircle(accent, 3.dp.toPx(), center)
                drawLine(accent, center, Offset(center.x + radius * 0.5f, center.y - radius * 0.55f), 2.dp.toPx(), StrokeCap.Round)
            } else {
                drawArc(ink.copy(alpha = 0.09f), -90f, 360f, false, style = Stroke(7.dp.toPx()))
                drawArc(accent, -90f, 360 * d.progress, false, style = Stroke(7.dp.toPx(), cap = StrokeCap.Round))
                val inset = 14.dp.toPx()
                drawArc(accent.copy(alpha = 0.38f), -90f, 360 * d.secondaryProgress, false,
                    topLeft = Offset(inset, inset), size = androidx.compose.ui.geometry.Size(size.width - 2 * inset, size.height - 2 * inset), style = Stroke(4.dp.toPx(), cap = StrokeCap.Round))
            }
        }
        Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(7.dp)) {
            AtelierValue(d.value, ink)
            Text("${d.metrics[0].label} · ${d.metrics[0].value}", color = pigment(d.palette[4]), fontSize = 10.sp, maxLines = 2)
        }
    }
}

@Composable private fun BentoComposition(d: AtelierDesign, ink: Color, muted: Color, compact: Boolean) {
    Row(Modifier.fillMaxSize(), horizontalArrangement = Arrangement.spacedBy(10.dp)) {
        Column(Modifier.weight(1.5f).fillMaxHeight().clip(RoundedCornerShape(15.dp)).background(Color.White.copy(alpha = 0.16f)).padding(12.dp), verticalArrangement = Arrangement.Center) {
            AtelierValue(d.value, ink)
            Text(d.metrics[0].label, color = muted, fontSize = 10.sp)
        }
        if (!compact) Column(Modifier.weight(1f).fillMaxHeight(), verticalArrangement = Arrangement.SpaceEvenly) {
            d.metrics.drop(1).forEach { row ->
                Column(verticalArrangement = Arrangement.spacedBy(3.dp)) {
                    Text(row.value, color = ink, fontSize = 15.sp, fontWeight = FontWeight.Medium, maxLines = 1)
                    Text(row.label, color = muted, fontSize = 9.sp)
                }
            }
        }
    }
}

@Composable private fun ChartComposition(d: AtelierDesign, ink: Color, accent: Color, muted: Color, music: Boolean) {
    Column(verticalArrangement = Arrangement.spacedBy(9.dp)) {
        AtelierValue(d.value, ink)
        Canvas(Modifier.fillMaxWidth().height(38.dp)) {
            if (d.layout == "timeline" || music) {
                val width = size.width / d.series.size
                d.series.forEachIndexed { index, value ->
                    drawRoundRect(accent.copy(alpha = if (index == 6) 1f else 0.38f), Offset(index * width + 2.dp.toPx(), size.height * (1 - value)),
                        androidx.compose.ui.geometry.Size(width * 0.6f, size.height * value), androidx.compose.ui.geometry.CornerRadius(3.dp.toPx()))
                }
            } else {
                val path = Path()
                d.series.forEachIndexed { index, value ->
                    val x = size.width * index / (d.series.size - 1)
                    val y = size.height * (1 - value)
                    if (index == 0) path.moveTo(x, y) else path.lineTo(x, y)
                }
                drawPath(path, accent, style = Stroke(2.dp.toPx(), cap = StrokeCap.Round))
            }
        }
        Text("${d.metrics[0].label} · ${d.metrics[0].value}", color = muted, fontSize = 9.sp)
    }
}

@Composable private fun MosaicComposition(d: AtelierDesign, ink: Color, accent: Color, compact: Boolean) {
    Box(Modifier.fillMaxWidth().height(92.dp)) {
        Row(Modifier.fillMaxSize(), horizontalArrangement = Arrangement.spacedBy(7.dp)) {
            LandscapeWindow(accent, Modifier.weight(2f).fillMaxHeight())
            if (!compact) Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(7.dp)) {
                LandscapeWindow(accent.copy(alpha = 0.65f), Modifier.weight(1f))
                LandscapeWindow(accent.copy(alpha = 0.4f), Modifier.weight(1f))
            }
        }
        Text(d.value, color = ink, fontSize = 14.sp, fontFamily = FontFamily.Serif, modifier = Modifier.align(Alignment.BottomStart).padding(10.dp), maxLines = 1)
    }
}

@Composable private fun LandscapeWindow(accent: Color, modifier: Modifier) {
    Canvas(modifier.fillMaxWidth().clip(RoundedCornerShape(12.dp)).background(accent.copy(alpha = 0.12f))) {
        drawCircle(accent.copy(alpha = 0.25f), size.height * 0.2f, Offset(size.width * 0.7f, size.height * 0.28f))
        val hill = Path().apply { moveTo(0f, size.height * 0.8f); quadraticBezierTo(size.width * 0.4f, size.height * 0.25f, size.width, size.height * 0.7f); lineTo(size.width, size.height); lineTo(0f, size.height); close() }
        drawPath(hill, accent.copy(alpha = 0.16f))
    }
}
