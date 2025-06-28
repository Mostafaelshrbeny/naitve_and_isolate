package com.example.isolation_and_naitve

import android.app.Activity
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import android.widget.ImageView
import android.content.Context // ✅ ده هو الحل
import com.bumptech.glide.Glide
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor


class NaitveView : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_naitve_view)

        // عرض GIF من الأصول
        val gifImage: ImageView = findViewById(R.id.gifImage)
        Glide.with(this)
            .asGif()
            .load("file:///android_asset/images/animation.gif")
            .into(gifImage)

        // ربط العناصر من XML
        val button1: Button = findViewById(R.id.nativeButton1)
        val button2: Button = findViewById(R.id.nativeButton2)
        val textView: TextView = findViewById(R.id.nativeText)
        val textView2: TextView = findViewById(R.id.nativeText2)

        // استلام الداتا المبعوتة من Flutter
        val message = intent.getStringExtra("message") ?: "No message"
        textView2.text = message

        // إعداد FlutterEngine مرة واحدة وربطه بالـ Cache
        val flutterEngine = FlutterEngine(this)
        flutterEngine.navigationChannel.setInitialRoute("/profile") // 👈 لو عايز تبعت داتا
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )
        FlutterEngineCache
            .getInstance()
            .put("my_engine_id", flutterEngine)

        // الزر الأول: يفتح صفحة Flutter من الكاش
        button1.setOnClickListener {
            button1.setOnClickListener {
    launchFlutterIfNeeded(this, "/profile")
}
        }

        // الزر التاني: يغير نص TextView
        button2.setOnClickListener {
            textView.text = "Button 2 changed the text!"
        }
    }
    fun launchFlutterIfNeeded(context: Context, route: String) {
    val cachedEngineId = "my_engine_id"
    val cache = FlutterEngineCache.getInstance()

    if (cache.get(cachedEngineId) == null) {
        val engine = FlutterEngine(context)
        engine.navigationChannel.setInitialRoute(route)
        engine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )
        cache.put(cachedEngineId, engine)
    }

    val intent = FlutterActivity
        .withCachedEngine(cachedEngineId)
        .build(context)
    context.startActivity(intent)
}
}

