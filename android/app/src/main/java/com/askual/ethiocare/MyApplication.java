package com.askual.ethiocare;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.os.Build;



import io.flutter.app.FlutterApplication;

public class MyApplication extends FlutterApplication {

    @Override
    public void onCreate() {
        super.onCreate();
//        String NOTIFICATION_CHANNEL_DESC ="notification_Channel_desc";
//        String NOTIFICATION_CHANNEL_ID ="notification_channel_id";
//        String NOTIFICATION_CHANNEL_NAME ="notification_channel_name";
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            NotificationChannel channel = new NotificationChannel(NOTIFICATION_CHANNEL_ID, NOTIFICATION_CHANNEL_NAME, NotificationManager.IMPORTANCE_DEFAULT);
//            channel.setDescription(NOTIFICATION_CHANNEL_DESC);
//            NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
//            notificationManager.createNotificationChannel(channel);
//        }
    }
}
