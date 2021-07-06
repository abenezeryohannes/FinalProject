package com.askual.ethiocare;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.CountDownTimer;
import android.os.Parcelable;
import android.util.Log;

import com.askual.ethiocare.databasepackage.BluetoothState;
import com.askual.ethiocare.databasepackage.Device;
import com.askual.ethiocare.databasepackage.MiniDevice;
import com.askual.ethiocare.databasepackage.Repository;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

public class MainActivityBluetoothController {
    IntentFilter filter, filter3, filter2;
    BroadcastReceiver sReceiver;

    Context context;
    BluetoothAdapter mBluetoothAdapter;
    boolean bluetoothState = false;
    LocationTracker locationTracker;
    int timeOfExit = 10000;
    List<MiniDevice> deviceList = new ArrayList<>();
    ArrayList<BluetoothDevice> mDeviceList = new ArrayList<BluetoothDevice>();
    List<MiniDevice> getDeviceList(){
        return deviceList;
    }

    boolean isBluetoothState(){
        return bluetoothState;
    }


    MainActivityBluetoothController(Context context){
        this.context = context;
        mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        locationTracker = new LocationTracker(context);
        if(mBluetoothAdapter.isEnabled()) bluetoothState = true;
        displayListOfFoundDevices();
        setBroadcastReceiverForBluetoothState();
        updateDeviceLeaveToDetectDeviceExit();
    }

    private void displayListOfFoundDevices()
    {

        sReceiver = new BroadcastReceiver()
        {
            @Override
            public void onReceive(Context context, Intent intent)
            {
                String action = intent.getAction();
                // When discovery finds a device
                if (BluetoothDevice.ACTION_FOUND.equals(action))
                {
                    BluetoothDevice device = (BluetoothDevice) intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                    mDeviceList.add(device);
                    int rssi = intent.getShortExtra(BluetoothDevice.EXTRA_RSSI,Short.MIN_VALUE);

                    for (MiniDevice d: deviceList) {
                        if(device.getAddress().equals(d.getAddress())){
//                        Log.d(Util.TAG, "Mainactivity onReceive: update Device "+ device.getName());
                        deviceList.remove(d);
                        break;}
                    }

                    deviceList.add(changeBluetoothDevice(device, rssi));

                    Log.d("myLog", "Mainactivity onReceive: device discovered " + deviceList.toString());
                }
                else if(intent.getAction().equals("android.bluetooth.adapter.action.DISCOVERY_FINISHED")){
                    Log.d("myLog", "Mainactivity onReceive: finished");
//                    mBluetoothAdapter.startDiscovery();
                    // discovery has finished, give a call to fetchUuidsWithSdp on first device in list.
//                    Log.d(Util.TAG, "onReceive: bluetooth list before filtering: "+mDeviceList.size());
                   for(int i =0;i<mDeviceList.size();i++){
                       for(int j =i+1;j<mDeviceList.size();j++){
                           if(mDeviceList.get(i).getName().equals(mDeviceList.get(j).getName()) && i!=j) mDeviceList.remove(j--);
                       }
                   }
//                    Log.d(Util.TAG, "onReceive: bluetooth list after filtering: "+mDeviceList.size());
                    if (!mDeviceList.isEmpty()) {
                        BluetoothDevice device = mDeviceList.remove(0);
                        device.fetchUuidsWithSdp();
                    }else mBluetoothAdapter.startDiscovery();
                } else if (BluetoothDevice.ACTION_UUID.equals(action)) {

                    BluetoothDevice deviceExtra = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                    Parcelable[] uuidExtra = intent.getParcelableArrayExtra(BluetoothDevice.EXTRA_UUID);

                    if (!mDeviceList.isEmpty()) {
                        BluetoothDevice device = mDeviceList.remove(0);
                        Log.d(Util.TAG, "on UUiD found: removed "+device.getName() + " from bluetooth device list");
                        boolean result = device.fetchUuidsWithSdp();
                    }else{
                        mBluetoothAdapter.startDiscovery();
                        Log.d(Util.TAG, "on UUiD found: for all bluetooth device so starting discovery again");
                    }

//                    if(uuidExtra==null || uuidExtra.length==0){
//                        deviceExtra.fetchUuidsWithSdp();
//                        Log.d(Util.TAG, "on UUiD found: requested uuiid "+deviceExtra.getName() + " because uuid was null");
//                        return;
//                    }

                    for (MiniDevice d:deviceList) {
                        if(d.getAddress()!=null && deviceExtra.getAddress()!=null)
                        if(d.getAddress().equals(deviceExtra.getAddress())){
                            d.setDevice_uuids(uuidExtra);
                            Log.d(Util.TAG, "on UUiD found: updated  "+d.getDevice_name() + " becouse uiid is found");
                            break;
                        }
                    }

                }
            }
        };

        // Register the BroadcastReceiver
         filter = new IntentFilter(BluetoothDevice.ACTION_FOUND);
         filter3 = new IntentFilter(BluetoothDevice.ACTION_UUID);
         filter2 = new IntentFilter("android.bluetooth.adapter.action.DISCOVERY_FINISHED");
        context.registerReceiver(sReceiver, filter);
        context.registerReceiver(sReceiver, filter2);
        context.registerReceiver(sReceiver, filter3);
        // start looking for bluetooth devices
        mBluetoothAdapter.startDiscovery();
    }

    public void setBroadcastReceiverForBluetoothState(){
        IntentFilter intentFilter = new IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED);
        context.registerReceiver(sReciever, intentFilter);
    }


    private final BroadcastReceiver sReciever = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            final int state  = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.ERROR);
            switch (state){
                case BluetoothAdapter.STATE_OFF:
                    Log.d(Util.TAG, "Mainactivity onReceive: state off");
                    bluetoothState = false;
                    break;
                case BluetoothAdapter.STATE_ON:
                    Log.d(Util.TAG, "Mainactivity onReceive: state on");
                    bluetoothState = true;
                    break;
            }
        }
    };



    private MiniDevice changeBluetoothDevice(BluetoothDevice bluetoothDevice, int rssi) {
        MiniDevice dev = new MiniDevice();
        dev.setDevice_name(bluetoothDevice.getName());
        dev.setDevice_uuids(bluetoothDevice.getUuids());
        dev.setDevice_rssi(rssi);
        dev.setAddress(bluetoothDevice.getAddress());
        if(locationTracker.getCurrentLocation()!=null) {
            dev.setAccuracy(locationTracker.getCurrentLocation().getAccuracy());
            dev.setLatitude(locationTracker.getCurrentLocation().getLatitude());
            dev.setLongitude(locationTracker.getCurrentLocation().getLongitude());
            dev.setAltitude(locationTracker.getCurrentLocation().getAltitude());
        }
        return dev;
    }



    private void detectDeviceLeave(){
//        for (Device d: deviceList) {
//            if(Math.abs(Util.getMinuteDiff(d.getExTime())) >= TimeUnit.MILLISECONDS.toMinutes(timeOfExit)){
//                Log.d(Util.TAG, "Mainactivity detectDeviceLeave: "+ d.getName());
//                deviceList.remove(d);
//            }
//        }
        Log.d(Util.TAG, "Mainactivity last Available Devices "+ deviceList.toString());
    }


    private void updateDeviceLeaveToDetectDeviceExit(){
        new CountDownTimer(999999999, timeOfExit){
            @Override
            public void onTick(long millisUntilFinished) {
                Log.d(Util.TAG, "Mainactivity onTick: device list is: "+ new Gson().toJson(deviceList));
                deviceList.clear();
            }

            @Override
            public void onFinish() {
                this.start();
            }
        }.start();
    }

    public void onDestroy(){
        context.unregisterReceiver(sReceiver);
    }
    public void onResume(){
        context.registerReceiver(sReceiver, filter);
        context.registerReceiver(sReceiver, filter2);
        context.registerReceiver(sReceiver, filter3);
    }

}
