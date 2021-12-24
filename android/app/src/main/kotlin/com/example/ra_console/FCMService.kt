package com.syncronosys.ra_console

import android.app.PendingIntent
import android.content.Intent
import android.media.RingtoneManager
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class FCMService : FirebaseMessagingService() {
    override fun onMessageReceived(payload: RemoteMessage) {
        super.onMessageReceived(payload)
        if(payload.data?.isNotEmpty()) {
            Log.d("FCMService", payload.data.toString())

            sendNotification(payload.data["body"].toString(), payload.data["title"].toString(), payload.data["channel"].toString());
        }
        if(!payload.notification?.body.isNullOrBlank()) {
            Log.d("FCMService", payload.notification?.body.toString())
        }
    }

    private fun sendNotification(messageBody: String, title: String, channel: String) {
        val intent = Intent(this, MainActivity::class.java)
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
        val pendingIntent = PendingIntent.getActivity(this, 0 /* Request code */, intent,
                PendingIntent.FLAG_ONE_SHOT)

        val channelId = channel
        val defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
        val notificationBuilder = NotificationCompat.Builder(this, channelId)
                .setSmallIcon(R.drawable.notification_small_icon)
                .setContentTitle(title)
                .setContentText(messageBody)
                .setAutoCancel(true)
                .setSound(defaultSoundUri)
                .setContentIntent(pendingIntent)
                .setStyle(NotificationCompat.BigTextStyle().bigText(messageBody))

        with(NotificationManagerCompat.from(this)) {
            notify(Math.random().toInt(), notificationBuilder.build());
        }
    }
}