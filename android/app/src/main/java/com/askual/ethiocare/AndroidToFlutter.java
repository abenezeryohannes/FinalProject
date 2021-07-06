package com.askual.ethiocare;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.ParcelUuid;
import android.util.Log;

import java.util.ArrayList;
import java.util.List;

class AndroidToFlutter {
    private Context context;
    private List<BluetoothDevices> bluetoothDevicesList = new ArrayList<>();
    private BluetoothAdapter mBluetoothAdapter;


    AndroidToFlutter(Context context){
        this.context = context;
        mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        getListOfAvailableDevices();
    }

    public List<BluetoothDevices> getBluetoothDevicesList() {
        return bluetoothDevicesList;
    }

    private void getListOfAvailableDevices()
    {
        Log.d(Util.TAG, "getListOfAvailableDevices: from android flutter");
        // Register the BroadcastReceiver
        IntentFilter filter = new IntentFilter(BluetoothDevice.ACTION_FOUND);
        IntentFilter filter2 = new IntentFilter("android.bluetooth.adapter.action.DISCOVERY_FINISHED");
        context.registerReceiver(sReceiver, filter);
        context.registerReceiver(sReceiver, filter2);
        // start looking for bluetooth devices
        mBluetoothAdapter.startDiscovery();
    }


    public void onResume(){
        IntentFilter filter = new IntentFilter(BluetoothDevice.ACTION_FOUND);
        IntentFilter filter2 = new IntentFilter("android.bluetooth.adapter.action.DISCOVERY_FINISHED");
        context.registerReceiver(sReceiver, filter);
        context.registerReceiver(sReceiver, filter2);
    }

    public void onDestroy(){
        context.unregisterReceiver(sReceiver);
    }


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

                int rssi = intent.getShortExtra(BluetoothDevice.EXTRA_RSSI,Short.MIN_VALUE);


                boolean isAdded = false;
                for (BluetoothDevices d: bluetoothDevicesList) {
                    if(d.getUuid().equals(device.getUuids()[0].getUuid().toString())){
                        BluetoothDevices dev = d; dev.setRssi(rssi);
                        bluetoothDevicesList.set(bluetoothDevicesList.indexOf(d), dev);
                        isAdded = true; break;
                    }
                }
                if(!isAdded)bluetoothDevicesList.add(new BluetoothDevices(rssi, device.getName(),  device.getUuids()));




            }
            else if(intent.getAction().equals("android.bluetooth.adapter.action.DISCOVERY_FINISHED")){
                Log.d("myLog", "onReceive: finished");
                mBluetoothAdapter.startDiscovery();
            }
        }
    };


    class BluetoothDevices{
        Integer rssi;
        String name;
        String uuid;

        public BluetoothDevices(Integer rssi, String name, ParcelUuid[] uuid) {
            setRssi(rssi);
            setName(name);
            setUuid(uuid);
        }

        public Integer getRssi() {
            return rssi;
        }

        public void setRssi(Integer rssi) {
            this.rssi = rssi;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getUuid() {
            return uuid;
        }

        public void setUuid(ParcelUuid[] uuid) {
            this.uuid = uuid[0].getUuid().toString();
        }
    }

}
