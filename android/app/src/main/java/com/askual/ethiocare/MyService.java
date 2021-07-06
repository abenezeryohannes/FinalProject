package com.askual.ethiocare;

import android.app.Service;
import android.bluetooth.BluetoothAdapter;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.Nullable;
import com.askual.ethiocare.databasepackage.AppDatabase;
import com.askual.ethiocare.databasepackage.MyDevice;
import com.askual.ethiocare.databasepackage.PermmitedDevice;
import com.askual.ethiocare.databasepackage.Repository;

public class MyService extends Service {

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
//        onTaskRemoved(intent);
        return START_STICKY;
    }
    Repository repository;
    BluetoothController bluetoothController;

    @Override
    public void onCreate() {
        super.onCreate();
        startForground();
        setNoficationButtonClickListener();
        repository = new Repository(MyService.this, getApplicationContext());
        bluetoothController = new BluetoothController(MyService.this, getApplicationContext(), repository);
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }


    @Override
    public void onTaskRemoved(Intent rootIntent) {
        Intent intent = new Intent(getApplicationContext(), this.getClass());
        intent.setPackage(getPackageName());
        startService(intent);
        startForground();
        super.onTaskRemoved(rootIntent);
    }

    @Override
    public void onDestroy() {

        MyDevice myDevice = AppDatabase.getINSTANCE(getApplicationContext()).myDeviceDao().getMyDevice();
        if(myDevice == null)  BluetoothAdapter.getDefaultAdapter().setName(myDevice.blue_name);
        else BluetoothAdapter.getDefaultAdapter().setName( Build.MANUFACTURER + " - " + Build.MODEL);

        stopForeground(true);

    }

    private void startForground() {
        if(bluetoothController!=null&&bluetoothController.mBluetoothAdapter!=null)
        bluetoothController.mBluetoothAdapter.enable();
        NotificationExtras.whenBluetoothOn(this, this);
    }


    private void sendMessageToActivity(String msg) {
        Intent sendLevel = new Intent();
        sendLevel.setAction("GET_SIGNAL_STRENGTH");
        sendLevel.putExtra( "LEVEL_DATA",msg);
        sendBroadcast(sendLevel);
    }


    public void setNoficationButtonClickListener(){

        IntentFilter mIntentFilter = new IntentFilter();
        IntentFilter mIntentFilter2 = new IntentFilter();

        mIntentFilter.addAction(NotificationExtras.NOTIFIED_ACTION);
        mIntentFilter2.addAction(NotificationExtras.NOTIFIED_ACTION_DOCTORS);

        final BroadcastReceiver sReciever = new BroadcastReceiver() {
            MediaPlayer mp;
            @Override
            public void onReceive(Context context, Intent intent) {
            if(intent.getAction()!=null)
           if(intent.getAction().equals(NotificationExtras.NOTIFIED_ACTION)){
               if(intent.getStringExtra("uuid")!=null){
                  repository.addPermitted(new PermmitedDevice(intent.getStringExtra("uuid")));
               }
               NotificationExtras.whenNoSuspect(MyService.this, context);
           }else{
               Log.d(Util.TAG, "onReceive:  call");
               Intent mintent = new Intent(Intent.ACTION_CALL);
               mintent.setData(Uri.parse("tel:8335" ));
               mintent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
               MyService.this.startActivity(mintent);
               NotificationExtras.whenIamNotSuspect(MyService.this, context);
           }
            }
        };

        registerReceiver(sReciever, mIntentFilter);
        registerReceiver(sReciever, mIntentFilter2);
    }


}
