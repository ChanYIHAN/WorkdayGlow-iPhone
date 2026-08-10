package com.workdayglow.android.ui.theme

import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext

private val LightColors = lightColorScheme(
    primary = Color(0xFF145E56),
    secondary = Color(0xFF64558B),
    tertiary = Color(0xFF9C4146),
    background = Color(0xFFF6F6FA),
    surface = Color(0xFFFDFBFF),
    onSurface = Color(0xFF1D1C27)
)

private val DarkColors = darkColorScheme(
    primary = Color(0xFF5FE0C2),
    secondary = Color(0xFFCAB8FF),
    tertiary = Color(0xFFFFB2B4),
    background = Color(0xFF121118),
    surface = Color(0xFF1D1C27),
    onSurface = Color(0xFFF3F0FA)
)

@Composable
fun WorkdayGlowTheme(content: @Composable () -> Unit) {
    val dark = isSystemInDarkTheme()
    val context = LocalContext.current
    val scheme = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        if (dark) dynamicDarkColorScheme(context) else dynamicLightColorScheme(context)
    } else if (dark) {
        DarkColors
    } else {
        LightColors
    }

    MaterialTheme(colorScheme = scheme, content = content)
}
