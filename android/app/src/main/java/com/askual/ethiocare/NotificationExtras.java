package com.askual.ethiocare;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.bluetooth.BluetoothAdapter;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.media.AudioAttributes;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.util.Log;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;


import com.askual.ethiocare.networkcall.Message;



public final class NotificationExtras {
    static String NOTIFICATION_CHANNEL_DESC ="All important notifications like suspicion, previous possible contact with infected person  and warnings";
    static String NOTIFICATION_CHANNEL_ID ="Covid contact tracer";
    static String NOTIFICATION_CHANNEL_NAME ="Covid Contact Tracer";
    static String NOTIFICATION_CHANNEL_DANGER_DESC ="Most critical notifications and warnings";
    static String NOTIFICATION_CHANNEL_DANGER_ID ="Covid contact tracer warnings";
    static String NOTIFICATION_CHANNEL_DANGER_NAME ="Covid Contact Tracer warnings";

    public static String NOTIFIED_ACTION = "com.askual.coronatracker.buttonclick";
    public static String NOTIFIED_ACTION_DOCTORS = "com.askual.coronatracker.doctors";
    static int currentstatus = 3, connection = 0, noconnection = 1, btoff = 2, bton = 3,
    nosuspect = 4, suspect = 5, amsuspect = 6, locationsuspect = 7, locationNoSuspect = 8;

    public static void whenOnConnection(Service service, Context context){
//        Log.d(Util.NOTIFICATION, "whenOnConnection: currentstatus: "+currentstatus);
//        if(currentstatus==bton||currentstatus==noconnection) {
//            Log.d(Util.NOTIFICATION, "whenOnConnection: updated");
//            currentstatus = connection;
//            Message message = new Message();
//            message.status = "unknown";
//            message.title = "Running in background";
//            message.message = "looking for nearby treats";
//            startForgroundNotification(service, context, message);
//        }
    }
    public static void whenNoConnection(Service service, Context context){
//        Log.d(Util.NOTIFICATION, "whenNoConnection: currentstatus: "+currentstatus);
//        if(currentstatus==connection||currentstatus == bton) {
//            Log.d(Util.NOTIFICATION, "whenNoConnection: updated");
//            currentstatus = noconnection;
//            Message message = new Message();
//            message.status = "unknown";
//            message.title = "Running in background";
//            message.message = "Don't forget to turn data on when you are out in public.";
//            startForgroundNotification(service, context, message);
//        }
    }


    public static void whenBluetoothOf(Service service, Context context){
        Log.d(Util.NOTIFICATION, "whenBluetoothOf: currentstatus: "+currentstatus);
        if(currentstatus==bton||currentstatus==nosuspect||currentstatus==locationNoSuspect||currentstatus==noconnection||currentstatus==connection) {
            Log.d(Util.NOTIFICATION, "whenBluetoothOf: updated");
            currentstatus = btoff;
            Message message = new Message();
            message.status = "red";
            message.title = "Please turn Bluetooth on";
            message.message = "We use bluetooth signal to detect nearby threats.";
            startForgroundNotification(service, context, message);
        }
    }

    public static void whenBluetoothOn(Service service, Context context){
        Log.d(Util.NOTIFICATION, "whenBluetoothOn: currentstatus: "+currentstatus);
        if(currentstatus==btoff||currentstatus==nosuspect||currentstatus==bton) {
            Log.d(Util.NOTIFICATION, "whenBluetoothOn: updated");
            currentstatus = bton;
//            if(isConnected(context)){
//                whenOnConnection(service,context);
//            }else{
//                whenNoConnection(service, context);
//            }
            Message message = new Message();
            message.status = "unknown";
            message.title = "Ethio Care";
            message.message = "Don't turn off bluetooth and location for your safety.";
            startForgroundNotification(service, context, message);
        }
    }



    public static void whenLocationSuspectFound(MyService myService, Context context, Message message) {
//        Log.d(Util.NOTIFICATION, "whenLocationSuspectFound: currentstatus: "+currentstatus);
//        if(currentstatus!=amsuspect&&currentstatus!=suspect) {
//            Log.d(Util.NOTIFICATION, "whenLocationSuspectFound: updated");
//            currentstatus = locationsuspect;
//            startForgroundNotification(myService, context, message);
//        }
    }

    public static void whenLocationNoSuspect(MyService myService, Context context) {
//        Log.d(Util.NOTIFICATION, "whenLocationNoSuspect: currentstatus: "+currentstatus);
//        if(currentstatus==locationsuspect) {
//            Log.d(Util.NOTIFICATION, "whenLocationNoSuspect: updated");
//            currentstatus = locationNoSuspect;
//            BluetoothAdapter ba = BluetoothAdapter.getDefaultAdapter();
//            if(ba.isEnabled()) whenBluetoothOn(myService, context);
//            else whenBluetoothOf(myService, context);
//        }
    }




    public static void whenSuspectFound(Service service, Context context, Message message){
        Log.d(Util.NOTIFICATION, "whenSuspectFound: currentstatus: "+currentstatus);
        if(currentstatus!=amsuspect) {
            Log.d(Util.NOTIFICATION, "whenSuspectFound: updated");
            currentstatus = suspect;
            startForgroundNotification(service, context, message);
        }
    }

    public static void whenNoSuspect(Service service, Context context){
        Log.d(Util.NOTIFICATION, "whenNoSuspect: currentstatus: "+currentstatus);
        if(currentstatus==suspect) {
            Log.d(Util.NOTIFICATION, "whenNoSuspect: updated");
            currentstatus = nosuspect;
            BluetoothAdapter ba = BluetoothAdapter.getDefaultAdapter();
            if(ba.isEnabled()) whenBluetoothOn(service, context);
            else whenBluetoothOf(service, context);
        }
    }

    public static void whenIamSuspect(Service service, Context context, Message message){
        Log.d(Util.NOTIFICATION, "whenIamSuspect: currentstatus: "+currentstatus);
        Log.d(Util.NOTIFICATION, "whenIamSuspect: updated");
        currentstatus = amsuspect;
        startForgroundNotification(service, context, message);
    }
    public static void whenIamNotSuspect(Service service, Context context){
        Log.d(Util.NOTIFICATION, "whenIamNotSuspect: currentstatus: "+currentstatus);
        currentstatus = suspect;
        whenNoSuspect(service, context);
    }



    public static void showSimpleNotification(Context context, String name, String desc, String status ){
        String NOTIFICATION_CHANNEL_ID ="notification_channel_id";
        int NOTIFICATION_ID = (int)(Math.random()*100);
        int color = context.getResources().getColor(R.color.accent);
        switch (status.toLowerCase()){
            case "danger":
            case "red":
                color = Color.RED;
//                MediaPlayer mp=MediaPlayer.create(context, R.raw.alarm);
//                mp.start();
                break;
            case "green":
                color = context.getResources().getColor(R.color.accent);
                break;
            case "yellow":
                color = Color.YELLOW;
                break;
        }
        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        Intent notificationIntent = new Intent(context, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, notificationIntent, 0);
        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, NOTIFICATION_CHANNEL_ID)
                .setSmallIcon(R.mipmap.appicon2)
                .setContentTitle(name)
                .setColorized(true)
                .setColor(color)
                .setColor(Color.RED)
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setContentText(desc)
                .setTicker("TICKER")
                .setAutoCancel(false)
                .setContentIntent(pendingIntent);


        Notification n = builder.build();
        NotificationManagerCompat.from(context).notify(NOTIFICATION_ID, n);

    }

    public static void startForgroundNotification(Service service, Context context, Message message) {

        int NOTIFICATION_ID = 101;
        Intent notificationIntent = new Intent();
        notificationIntent.setAction(NOTIFIED_ACTION);
        notificationIntent.putExtra("status", currentstatus);
        NotificationCompat.Builder builder;

        if(message.status.equals("danger")){
           builder =new NotificationCompat.Builder(context, NOTIFICATION_CHANNEL_DANGER_ID);
        } else{
            builder =new NotificationCompat.Builder(context, NOTIFICATION_CHANNEL_ID);
        }


        int color = context.getResources().getColor(R.color.accent);
        Uri soundUri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" +  context.getPackageName() + "/raw/alarm");
        switch (message.status.toLowerCase()){
            case "danger":
            case "red":
                color = context.getResources().getColor(R.color.red);
                break;
            case "green":
            case "unknown":
                color = context.getResources().getColor(R.color.accent);
                break;
            case "yellow":
                color = context.getResources().getColor(R.color.yellow);
                break;
        }

            if(currentstatus == suspect) {
                if (message.status.equals("danger")) {
                    Intent willTakeCaution = new Intent();
                    willTakeCaution.setAction(NOTIFIED_ACTION);
                    PendingIntent pendingIntentYes = PendingIntent.getBroadcast(context, 12345, willTakeCaution, PendingIntent.FLAG_UPDATE_CURRENT);


                    Intent dontWarnMe = new Intent();
                    dontWarnMe.setAction(NOTIFIED_ACTION);
                    if(message.uuid!=null){ dontWarnMe.putExtra("uuid", message.uuid); }
                    PendingIntent pendingIntentdontWarnMe = PendingIntent.getBroadcast(context, 12335, dontWarnMe, PendingIntent.FLAG_UPDATE_CURRENT);

                    builder.addAction(R.drawable.ic_done_black_24dp, "Add this device to safe list", pendingIntentdontWarnMe);
                    builder.addAction(R.drawable.ic_done_black_24dp, "I will take Caution", pendingIntentYes);
                     }
            }else if(currentstatus == amsuspect){
                if (message.status.equals("danger")) {
                    Intent yesReceive = new Intent();
                    yesReceive.setAction(NOTIFIED_ACTION_DOCTORS);
                    PendingIntent pendingIntentYes = PendingIntent.getBroadcast(context, 12345, yesReceive, PendingIntent.FLAG_UPDATE_CURRENT);
                    builder.addAction(R.drawable.ic_done_black_24dp, "Call a Health Care Provider", pendingIntentYes);
                    notificationIntent.setAction(NOTIFIED_ACTION_DOCTORS);
                }
            }


        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            if(message.status.equals("danger")){
                NotificationChannel channel = new NotificationChannel(NOTIFICATION_CHANNEL_DANGER_ID, NOTIFICATION_CHANNEL_DANGER_NAME, NotificationManager.IMPORTANCE_DEFAULT);
                channel.setDescription(NOTIFICATION_CHANNEL_DANGER_DESC);
                NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
                AudioAttributes audioAttributes = new AudioAttributes.Builder()
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .build();
                notificationManager.deleteNotificationChannel(NOTIFICATION_CHANNEL_ID);
                channel.setSound(soundUri, audioAttributes);
                builder.setSound(soundUri);
                channel.enableVibration(true);
                channel.enableLights(true);
                notificationManager.createNotificationChannel(channel);
            }else {
                NotificationChannel channel = new NotificationChannel(NOTIFICATION_CHANNEL_ID, NOTIFICATION_CHANNEL_NAME, NotificationManager.IMPORTANCE_DEFAULT);
                channel.setDescription(NOTIFICATION_CHANNEL_DESC);
                NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
                notificationManager.createNotificationChannel(channel);
            }
        }



            builder
            .setSmallIcon(R.mipmap.ic_covid_contact_tracer_notification)
            .setContentTitle(message.title)
            .setContentText(message.message)
            .setTicker("TICKER")
            .setSound(null)
            .setPriority(NotificationCompat.PRIORITY_MAX);
        if(!message.status.equals("unknown")){
            builder.setColorized(true);
            builder.setColor(color);
        }

            PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);
            builder.setContentIntent(pendingIntent);
            Notification notification = builder.build();
            service.startForeground(NOTIFICATION_ID, notification);
    }



    public static boolean isConnected(Context context) {
        ConnectivityManager connectivityManager
                = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo activeNetworkInfo = connectivityManager.getActiveNetworkInfo();
        return activeNetworkInfo != null && activeNetworkInfo.isConnected();
    }

}
