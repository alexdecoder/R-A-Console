package com.syncronosys.ra_console

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.util.Log
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.messaging.FirebaseMessaging
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.syncronosys.ra_console/fcm";

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if(call.method == "getFCMtoken") {
                FirebaseMessaging.getInstance().token.addOnCompleteListener(OnCompleteListener { task ->
                    Log.d("FCMService", task.result)

                    result.success(task.result)
                })
            } else if(call.method == "setupNotificationChannels") {
                setupChannels()

                result.success(null)
            }
        }
    }

    private fun setupChannels() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // Create the NotificationChannel

            val aChannel = NotificationChannel("auth", "Authorizations", NotificationManager.IMPORTANCE_HIGH)
            aChannel.description = "Payment notifications from issued cards"

            val crChannel = NotificationChannel("cr", "Contact Requests", NotificationManager.IMPORTANCE_HIGH)
            crChannel.description = "Contact requests filled out on the homepage"

            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(aChannel)
            notificationManager.createNotificationChannel(crChannel)
        }
    }
}
