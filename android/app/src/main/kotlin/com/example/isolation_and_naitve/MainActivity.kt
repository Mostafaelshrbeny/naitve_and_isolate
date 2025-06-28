package com.example.isolation_and_naitve

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel

import android.content.Intent
import kotlin.concurrent.thread 

class MainActivity : FlutterActivity(), SensorEventListener {
    
    private val METHOD_CHANNEL = "Methodexample"
    private val SENSOR_CHANNEL = "com.example.naitveintegrationexample/sensor"

    private var sensorManager: SensorManager? = null
    private var accelerometer: Sensor? = null
    private var eventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
            var x =50
        // MethodChannel for counter and helloWorld
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "counter" -> {
                    val value = call.arguments as? Int
                    if (value != null) {
                        result.success(value + 1)
                    } else {
                        result.error("INVALID_ARGUMENT", "Expected an integer", null)
                    }
                }
                "heavyLoop" -> {
                 val iterations = call.arguments as? Int
                if (iterations != null) {
      
                var sum = 0
                for (i in 0 until iterations) {
                    sum += (i % 100)
                }
        
                result.success(sum)
                } else {
                result.error("INVALID_ARGUMENT", "Expected an integer", null)
                }
}
"heavyLoopWithThreads" -> {
    val iterations = (call.arguments as? Number)?.toLong()
    if (iterations != null) {
        thread {
            var sum = 0L
            for (i in 0 until iterations) {
                sum += (i % 100)
            }

           sum = sum+x
            runOnUiThread {
                result.success(sum)
            }
        }
    } else {
        result.error("INVALID_ARGUMENT", "Expected a numeric value", null)
    }
}


                else -> result.notImplemented()
            }
        }
MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example/native")
    .setMethodCallHandler { call, result ->
        if (call.method == "openNativeScreen") {
            val args = call.arguments as? Map<String, Any>
            val message = args?.get("message") as? String ?: "No data"
            val intent = Intent(this, NaitveView::class.java)
            intent.putExtra("message", message)
            startActivity(intent)
            
            result.success(null)
        } else {
            result.notImplemented()
        }
    }
        // EventChannel for accelerometer sensor streaming
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, SENSOR_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
                    accelerometer = sensorManager?.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
                    sensorManager?.registerListener(this@MainActivity, accelerometer, SensorManager.SENSOR_DELAY_NORMAL)
                }

                override fun onCancel(arguments: Any?) {
                    sensorManager?.unregisterListener(this@MainActivity)
                    eventSink = null
                }
            }
        )
       

    }

    override fun onSensorChanged(event: SensorEvent?) {
        if (event?.sensor?.type == Sensor.TYPE_ACCELEROMETER) {
            val x = event.values[0].toDouble()
            val y = event.values[1].toDouble()
            val z = event.values[2].toDouble()
            eventSink?.success(mapOf("x" to x, "y" to y, "z" to z))
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
}