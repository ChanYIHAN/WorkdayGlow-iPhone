package com.workdayglow.android

import android.os.Bundle
import android.content.Intent
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.getValue
import androidx.compose.runtime.setValue
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import com.workdayglow.android.ui.WorkdayGlowApp
import com.workdayglow.android.ui.theme.WorkdayGlowTheme

class MainActivity : ComponentActivity() {
    private var studyLaunchId by mutableIntStateOf(0)
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        if (intent.getBooleanExtra("study", false)) studyLaunchId++
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (intent.getBooleanExtra("study", false)) studyLaunchId++
        enableEdgeToEdge()
        setContent {
            WorkdayGlowTheme {
                WorkdayGlowApp(studyLaunchId)
            }
        }
    }
}
