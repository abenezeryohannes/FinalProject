package com.askual.ethiocare;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.ParcelUuid;
import android.os.Parcelable;
import android.util.Log;

import androidx.annotation.RequiresApi;

import com.askual.ethiocare.databasepackage.BluetoothState;
import com.askual.ethiocare.databasepackage.Device;
import com.askual.ethiocare.databasepackage.MiniDevice;
import com.askual.ethiocare.databasepackage.Repository;
import com.askual.ethiocare.networkcall.Message;

import java.util.ArrayList;
import java.util.Date;

public class BluetoothController {
    Context context;
    BluetoothAdapter mBluetoothAdapter;
    DeviceController deviceController;
    Repository repository;
    ArrayList<BluetoothDevice> mDeviceList = new ArrayList<BluetoothDevice>();
    boolean bluetoothState = false;
    MyService myService;
    static final int waitThisMuchSecondBeforeTurningDiscovery = 60000;
    static ParcelUuid myUUID = null;

    BLE ble;
    public DeviceController getDeviceController() {
        return deviceController;
    }

    BluetoothController(MyService myService,Context context, Repository repository){
        this.context = context;
        this.myService = myService;
        this.repository = repository;
        mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
       // mBluetoothAdapter.setName(Util.getDeviceId(context).replace("-",""));
        if(mBluetoothAdapter.isEnabled()) bluetoothState = true;
        this.repository.setBluetoothController(BluetoothController.this);
        deviceController = new DeviceController(
                new LocationTracker(context), this.repository);
        setBroadcastReceiverForBluetoothState();
        checkIfBLEisAvailable();
    }

    private void checkIfBLEisAvailable() {

        if (context.getPackageManager().hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE) && (Build.VERSION.SDK_INT >= 21)) {
            Log.d(Util.TAG, "checkIfBLEisAvailable: BLE is way to go");
                ble = new BLE(context, deviceController);
        }else {
            Log.d(Util.TAG, "checkIfBLEisAvailable: Classic BT is way to go");
            displayListOfFoundDevices();
        }
    }


    private void displayListOfFoundDevices()
    {

        final BroadcastReceiver sReceiver = new BroadcastReceiver()
        {
            @Override
            public void onReceive(Context context, Intent intent)
            {
                String action = intent.getAction();
                // When discovery finds a device
                if (BluetoothDevice.ACTION_FOUND.equals(action))
                {
                    Log.d("myLog", "onReceive: device discovered");
                    BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                    mDeviceList.add(device);

                    int rssi = intent.getShortExtra(BluetoothDevice.EXTRA_RSSI, Short.MIN_VALUE);
                    deviceController.addDevice(device,"null", rssi);
                    Log.d(Util.TAG, "onReceive: devices are: " + deviceController.getDeviceList().toString());
                }
                else if(intent.getAction().equals("android.bluetooth.adapter.action.DISCOVERY_FINISHED")){
//                    if(mDeviceList.isEmpty()){
//                        Log.d(Util.TAG, "onReceive: finished but no device is discovered so start Discovery after"+(waitThisMuchSecondBeforeTurningDiscovery/1000)+" seconds");
                        Log.d(Util.TAG, "onReceive: finished so start Discovery after"+(waitThisMuchSecondBeforeTurningDiscovery/1000)+" seconds");

                        new Thread(new Runnable() {
                            @Override
                            public void run() {
                                try {
                                    Thread.sleep(waitThisMuchSecondBeforeTurningDiscovery);
                                } catch (InterruptedException e) {
                                    e.printStackTrace();
                                }finally {
                                    mBluetoothAdapter.startDiscovery();
                                }
                            }
                        }).start();
                    }
//                else {
//                        Log.d("myLog", "onReceive: finished");
//                        mBluetoothAdapter.setName(Util.getDeviceId(context).replace("-",""));
//                        for(int i =0;i<mDeviceList.size();i++){
//                            for(int j =i+1;j<mDeviceList.size();j++){
//                                if(mDeviceList.get(i).getMac_address()!=null && mDeviceList.get(j).getMac_address()!=null)
//                                    if(mDeviceList.get(i).getMac_address().equals(mDeviceList.get(j).getMac_address()) && i!=j) mDeviceList.remove(j--);
//                            }
//                        }
//                        Log.d(Util.TAG, "onReceive: finished bluetooth list after filtering: "+mDeviceList.size());
//
//                        for (BluetoothDevice dev : mDeviceList) {
//                            if (dev.getUuids() != null) mDeviceList.remove(dev);
//                        }
//
//                        Log.d(Util.TAG, "onReceive: finished after removing device uuid that is already saved");
//                        if (!mDeviceList.isEmpty()) {
//                            Log.d(Util.TAG, "onReceive: finished removing device " + mDeviceList.get(0).getName() + " to get its uuid");
//                            BluetoothDevice device = mDeviceList.remove(0);
//                            device.fetchUuidsWithSdp();
//                        } else {
//                            Log.d(Util.TAG, "onReceive: starting discovery immediately cause there is discoverable devices");
//                            mBluetoothAdapter.startDiscovery();
//                        }
//                    }
//                } else if (BluetoothDevice.ACTION_UUID.equals(action)) {
//
//                    BluetoothDevice deviceExtra = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
//                    Parcelable[] uuidExtra = intent.getParcelableArrayExtra(BluetoothDevice.EXTRA_UUID);
//                    Log.d(Util.TAG, "on UUiD found: removed "+deviceExtra.getName() + " from bluetooth device list");
//                    if (!mDeviceList.isEmpty()) {
//                        BluetoothDevice device = mDeviceList.remove(0);
//                        boolean result = device.fetchUuidsWithSdp();
//                    }else{
//                        mBluetoothAdapter.startDiscovery();
//                        Log.d(Util.TAG, "on UUiD found: for all bluetooth device so starting discovery again");
//                    }
//                    deviceController.deviceUUIDDescovered(deviceExtra.getMac_address(), uuidExtra);
//                }
            }
        };

        // Register the BroadcastReceiver
        IntentFilter filter = new IntentFilter(BluetoothDevice.ACTION_FOUND);
//        IntentFilter filter3 = new IntentFilter(BluetoothDevice.ACTION_UUID);
        IntentFilter filter2 = new IntentFilter("android.bluetooth.adapter.action.DISCOVERY_FINISHED");
        context.registerReceiver(sReceiver, filter);
        context.registerReceiver(sReceiver, filter2);
//        context.registerReceiver(sReceiver, filter3);
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
                    Log.d(Util.TAG, "onReceive: state off");
                    bluetoothState = false;
                    saveState("off");
                    NotificationExtras.whenBluetoothOf(myService, context);
                    break;
                case BluetoothAdapter.STATE_ON:
                    Log.d(Util.TAG, "onReceive: state on");
                    saveState("on");
                    NotificationExtras.whenBluetoothOn(myService, context);
                    bluetoothState = true;
                    break;
            }
        }
    };

    public void saveState(String state){
        BluetoothState bs = new BluetoothState();
        bs.action = state;
        bs.time = new Date().getTime();
        repository.addBluetoothState(bs);
    }


    public boolean isOn() {
        return bluetoothState;
    }

    public boolean isDiscovering() {
        return mBluetoothAdapter.isDiscovering();
    }
}
