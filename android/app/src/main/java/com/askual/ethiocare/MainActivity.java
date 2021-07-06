package com.askual.ethiocare;
//0977315861
import android.Manifest;
import android.app.Activity;
import android.app.ActivityManager;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.bluetooth.BluetoothAdapter;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.ParcelUuid;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.widget.Switch;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.askual.ethiocare.databasepackage.AppDatabase;
import com.askual.ethiocare.databasepackage.MyDevice;
import com.askual.ethiocare.databasepackage.Repository;
import com.askual.ethiocare.databasepackage.Suspect;
import com.askual.ethiocare.networkcall.Retro;
import com.google.gson.Gson;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private int REQUEST_ENABLE_BT = 99; // Any positive integer should work.
    private BluetoothAdapter mBluetoothAdapter;

    Intent forService;
    MainActivityBluetoothController mainActivityBluetoothController;






    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
//        LocationTracker.checkPermissionAndRequest(getApplicationContext(), MainActivity.this);

        Log.d(Util.TAG, "i got custom uuid: "+Util.getDeviceId(getApplicationContext()));
        //For testing purposes
//        Util.getBluetoothUUIDS(getApplicationContext());
//        AppDatabase appDatabase = AppDatabase.getINSTANCE(getApplicationContext());
//        appDatabase.suspectDao().addSuspect(new Suspect(
//               "0d67b5e7-fccc-1c7e-9355-532084893448","danger", "danger"
//        ));
//        Log.d(Util.TAG, "configureFlutterEngine: saved suspect is "+appDatabase.suspectDao().getAllSuspects().toString());

//        appDatabase.permmitedDeviceDao().wipePermitteds();











        mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        mBluetoothAdapter.enable();
        //mainActivityBluetoothController = new MainActivityBluetoothController(getApplicationContext());
        checkPermission();
        new MethodChannel(
                flutterEngine.getDartExecutor().getBinaryMessenger(), "com.askual.ethiocare")
                .setMethodCallHandler(
                        (call, result) -> {
                            Log.d(Util.TAG, "onMethodCall: from android");
                            switch (call.method) {
                                case "startService":
                                    result.success(startService());
                                    break;
                                case "turnBluetoothOn":
                                        result.success(turnBluetoothOn());
                                    break;
                                case "isBluetoothOn":
                                    result.success(isBluetoothOn());
                                    break;
                                case "checkIfSupported":
                                    if (Build.VERSION.SDK_INT > 20) result.success("yes");
                                    else result.success("no");
                                        break;
                                case "getNearbyBluetoothDevices":
//                                    if(mainActivityBluetoothController==null) result.success("[]");
//                                    if (mainActivityBluetoothController.isBluetoothState())
//                                        result.success(new Gson().toJson(mainActivityBluetoothController.getDeviceList()));
//                                    else
                                    result.success("on");
                                    break;
                                case "getDeviceInfo":
                                    result.success(getDeviceInfo());//new Gson().toJson(getDeviceInfo()));
                                    break;
                                case "saveMyDevice":
                                    String json = call.argument("device");
                                    result.success(saveMyDevice(json));
                                    break;
                                case "tellFriends":
                                    String subject = call.argument("subject");
                                    String text = call.argument("text");
                                    result.success(shareText(subject, text));
                                    break;
                                case "call":
                                    String phoneNumber = call.argument("phone_number");
                                    Intent mintent = new Intent(Intent.ACTION_CALL);
                                    mintent.setData(Uri.parse("tel:"+phoneNumber ));
                                    mintent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                                    startActivity(mintent);
                                    result.success("called");
                                    break;

                            }
                        }
                );
     }



    class DeviceInfo{ String device_uuid; String mac_address; String blue_name;
        @NonNull
        @Override
        public String toString() {
            return "device uuid "+ device_uuid + " device name "+blue_name + " device mac_address " + mac_address;
        }
    }

    private String getDeviceInfo() {
        DeviceInfo d = new DeviceInfo();
        if(mBluetoothAdapter == null){
            mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        }
        mBluetoothAdapter.enable();
     d.device_uuid = Util.getDeviceId(getApplicationContext());
     d.mac_address = Util.getMacAddr(getApplicationContext());
     d.blue_name = Build.MANUFACTURER + " - " + Build.MODEL;
        Log.d(Util.TAG, "getDeviceInfo: "+d.toString());
//        Toast.makeText(this, d.toString(), Toast.LENGTH_LONG).show();
        return "{\"device_uuid\":\""+d.device_uuid+"\", \"blue_name\":\""+d.blue_name+ "\", \"mac_address\":\""+d.mac_address+"\"}";
    }

    public String getLocalBluetoothName(){
        if(mBluetoothAdapter == null){
            mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        }
        String name = mBluetoothAdapter.getName();
        if(name == null){
            System.out.println("Name is null!");
            name = mBluetoothAdapter.getAddress();
        }
        return name;
    }





    private String saveMyDevice(String json){
        MyDevice myDevice = new Gson().fromJson(json, MyDevice.class);
        Log.d(Util.TAG, "configureFlutterEngine: i got this string: "+ myDevice.toString());
        AppDatabase appDatabase = AppDatabase.getINSTANCE(getApplicationContext());
        appDatabase.myDeviceDao().addMyDevice(myDevice);
        Log.d(Util.TAG, "Main Activity successfully converted and saved the message to "+ appDatabase.myDeviceDao().getMyDevice().toString());
        return "successfull";
    }
    private String turnBluetoothOn() {
       mBluetoothAdapter.enable();
       return "started";
    }



private String isBluetoothOn(){
      return (mBluetoothAdapter.isEnabled())? "enabled":"not enabled";
}


private String startService(){
    if (Build.VERSION.SDK_INT <= 20){
        Log.d(Util.TAG, "startService: device not supported to start service");
        return "not started";
    }
    forService = new Intent(MainActivity.this, MyService.class);
    if(!isMyServiceRunning(MyService.class)) {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        ContextCompat.startForegroundService(MainActivity.this, forService);
      }else {
          startService(forService);
      }
    }
        return "service started";
  }



  public String shareText(String title, String message){
        Intent sharingIntent = new Intent(Intent.ACTION_SEND);
        sharingIntent.setType("text/plain");
        sharingIntent.putExtra(Intent.EXTRA_SUBJECT, title);
        sharingIntent.putExtra(Intent.EXTRA_TEXT, message);
        startActivity(Intent.createChooser(sharingIntent, "Share via"));
        return "successful";
  }












  @Override
  public void onResume() {
    super.onResume();
    if(mainActivityBluetoothController!=null)
    mainActivityBluetoothController.onResume();

  }



  @Override
  protected void onPause() {
      if(mainActivityBluetoothController!=null)
          mainActivityBluetoothController.onDestroy();
    super.onPause();
  }




  private boolean isMyServiceRunning(Class<?> serviceClass) {
    ActivityManager manager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
    for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
      if (serviceClass.getName().equals(service.service.getClassName())) {
        return true;
      }
    }
    return false;
  }



  public void checkPermission() {
      if (ContextCompat.checkSelfPermission(MainActivity.this,
              Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
          if (ActivityCompat.shouldShowRequestPermissionRationale(MainActivity.this,
                  Manifest.permission.ACCESS_FINE_LOCATION)) {
              ActivityCompat.requestPermissions(MainActivity.this,
                      new String[]{Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.READ_PHONE_STATE, Manifest.permission.CALL_PHONE}, 1);
          } else {
              ActivityCompat.requestPermissions(MainActivity.this,
                      new String[]{Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.READ_PHONE_STATE, Manifest.permission.CALL_PHONE}, 1);
          }
      }else checkReadPhonePermission();
  }


    public void checkReadPhonePermission() {
        if (ContextCompat.checkSelfPermission(MainActivity.this,
                Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
            if (ActivityCompat.shouldShowRequestPermissionRationale(MainActivity.this,
                    Manifest.permission.READ_PHONE_STATE)) {
                ActivityCompat.requestPermissions(MainActivity.this,
                        new String[]{Manifest.permission.READ_PHONE_STATE, Manifest.permission.CALL_PHONE}, 1);
            } else {
                ActivityCompat.requestPermissions(MainActivity.this,
                        new String[]{Manifest.permission.READ_PHONE_STATE}, 1);
            }
        }else checkMakeCallPermission();
    }

    public void checkMakeCallPermission() {
        if (ContextCompat.checkSelfPermission(MainActivity.this,
                Manifest.permission.CALL_PHONE) != PackageManager.PERMISSION_GRANTED) {
            if (ActivityCompat.shouldShowRequestPermissionRationale(MainActivity.this,
                    Manifest.permission.CALL_PHONE)) {
                ActivityCompat.requestPermissions(MainActivity.this,
                        new String[]{Manifest.permission.CALL_PHONE}, 1);
            } else {
                ActivityCompat.requestPermissions(MainActivity.this,
                        new String[]{Manifest.permission.CALL_PHONE}, 1);
            }
        }else startService();
    }



    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions,
                                           int[] grantResults){
        if (requestCode == 1) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                if (ContextCompat.checkSelfPermission(MainActivity.this,
                        Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
                    if (ContextCompat.checkSelfPermission(MainActivity.this,
                            Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED) {
                        if (ContextCompat.checkSelfPermission(MainActivity.this,
                                Manifest.permission.CALL_PHONE) == PackageManager.PERMISSION_GRANTED) {
                            startService();
                        }else checkMakeCallPermission();
                    }else
                        checkReadPhonePermission();
                }
            } else {
                finish();
                //Toast.makeText(this, "Permission Denied", Toast.LENGTH_SHORT).show();
            }
        }
    }


}
