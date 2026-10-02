package com.workdayglow.android.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawWithContent
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp

// Portable glass: translucent tint, edge reflection and specular sheen. No content blur.
@Composable
fun Modifier.liquidGlass(radius: Int = 28, opaque: Boolean = false): Modifier {
    val shape = RoundedCornerShape(radius.dp)
    val dark = isSystemInDarkTheme()
    val surface = MaterialTheme.colorScheme.surface
    return shadow(8.dp, shape).clip(shape)
        .background(if (opaque) surface else surface.copy(alpha = if (dark) 0.84f else 0.72f))
        .drawWithContent {
            if (!opaque) {
                drawRect(Brush.linearGradient(listOf(Color.White.copy(alpha = if (dark) 0.06f else 0.36f), Color.Transparent, Color(0xFF9DDDED).copy(alpha = 0.12f)), start = Offset.Zero, end = Offset(size.width, size.height)))
            }
            drawContent()
        }
        .border(1.dp, Brush.linearGradient(listOf(Color.White.copy(alpha = 0.65f), surface.copy(alpha = 0.2f), Color.White.copy(alpha = 0.2f))), shape)
}
