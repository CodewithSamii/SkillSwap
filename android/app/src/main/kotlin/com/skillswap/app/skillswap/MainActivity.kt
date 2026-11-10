package com.skillswap.app.skillswap

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Explicitly ensure screenshotting and screen recording are completely unrestricted
        window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
    }
}
