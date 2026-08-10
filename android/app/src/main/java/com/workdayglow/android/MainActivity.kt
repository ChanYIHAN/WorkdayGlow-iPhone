package com.workdayglow.android

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import com.workdayglow.android.ui.WorkdayGlowApp
import com.workdayglow.android.ui.theme.WorkdayGlowTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            WorkdayGlowTheme {
                WorkdayGlowApp()
            }
        }
    }
}
