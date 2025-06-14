package com.example.isolation_and_naitve

import android.app.Activity
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import android.widget.ImageView
import com.bumptech.glide.Glide

class NaitveView : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_naitve_view)

    val gifImage: ImageView = findViewById(R.id.gifImage)
    Glide.with(this)
        .asGif()
        .load("file:///android_asset/images/animation.gif")
        .into(gifImage)

    val button1: Button = findViewById(R.id.nativeButton1)
    val button2: Button = findViewById(R.id.nativeButton2)
    val textView: TextView = findViewById(R.id.nativeText) // ربط الـ TextView

    button1.setOnClickListener {
        textView.text = "Button 1 was clicked!"
    }

    button2.setOnClickListener {
        textView.text = "Button 2 changed the text!"
    }
}


}
