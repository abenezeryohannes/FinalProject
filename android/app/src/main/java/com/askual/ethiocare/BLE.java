package com.askual.ethiocare;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothManager;
import android.bluetooth.le.AdvertiseCallback;
import android.bluetooth.le.AdvertiseData;
import android.bluetooth.le.AdvertiseSettings;
import android.bluetooth.le.AdvertisingSetParameters;
import android.bluetooth.le.BluetoothLeAdvertiser;
import android.bluetooth.le.BluetoothLeScanner;
import android.bluetooth.le.ScanCallback;
import android.bluetooth.le.ScanFilter;
import android.bluetooth.le.ScanResult;
import android.bluetooth.le.ScanSettings;
import android.content.Context;
import android.icu.text.BreakIterator;
import android.os.Build;
import android.os.Handler;
import android.os.ParcelUuid;
import android.util.Log;

import androidx.annotation.RequiresApi;

import com.askual.ethiocare.databasepackage.AppDatabase;
import com.askual.ethiocare.databasepackage.MyDevice;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import static com.askual.ethiocare.Util.bytesToHex;

public class BLE {
    private BluetoothAdapter mBluetoothAdapter;
    private int REQUEST_ENABLE_BT = 1;
    private Handler mHandler;
    private static final long SCAN_PERIOD = 12000;
    private static int SCAN_BREAK_PERIOD = 8000;
    private BluetoothLeScanner mLEScanner;
    private ScanSettings settings;
    private List<ScanFilter> filters;
    private BluetoothGatt mGatt;
    Context context;
    DeviceController deviceController;
    BluetoothLeAdvertiser advertiser = null;
    AdvertiseCallback advertiseCallback  = null;
    AdvertiseData.Builder dataBuilder = null;
    AdvertiseSettings.Builder settingsBuilder = null;
    @RequiresApi(api = Build.VERSION_CODES.O)
    BLE(Context context, DeviceController deviceController){
        this.context = context;
        this.deviceController  = deviceController;
        onCreate();
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private void onCreate(){

        mHandler = new Handler();
        final BluetoothManager bluetoothManager =
                (BluetoothManager) context.getSystemService(Context.BLUETOOTH_SERVICE);
        mBluetoothAdapter = bluetoothManager.getAdapter();
        advertiser = mBluetoothAdapter.getBluetoothLeAdvertiser();
        onResume();
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private void onResume() {
            if(!mBluetoothAdapter.isEnabled())
            {
                mBluetoothAdapter.enable();
            }

            if (Build.VERSION.SDK_INT >= 21) {
                mLEScanner = mBluetoothAdapter.getBluetoothLeScanner();
                settings = new ScanSettings.Builder()
                        .setScanMode(ScanSettings.SCAN_MODE_LOW_POWER)
                        .build();
                filters = new ArrayList<ScanFilter>();
            }
            scanLeDevice(true);

    }


    @RequiresApi(api = Build.VERSION_CODES.O)
    protected void onPause() {
        if (mBluetoothAdapter != null && mBluetoothAdapter.isEnabled()) {
            scanLeDevice(false);
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    protected void onDestroy() {
        if (mGatt == null) {
            return;
        }
        mGatt.close();
        mGatt = null;
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private void scanLeDevice(final boolean enable) {
        if (enable) {
            Log.d(Util.TAG, "run: starting BLE SCAN after "+ SCAN_BREAK_PERIOD/1000 +" seconds.");
            advertiseBle();
            scanFor_SCAN_PERIOD();
        } else {
             if (Build.VERSION.SDK_INT > 21){
                mLEScanner.stopScan(mScanCallback);
            }else if (Build.VERSION.SDK_INT > 17) {
                mBluetoothAdapter.stopLeScan(mLeScanCallback);
            }
             advertiser.stopAdvertising(advertiseCallback);
             startScanAfter_SCAN_BREAK_PERIOD();
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    public void startScanAfter_SCAN_BREAK_PERIOD() {
        Log.d(Util.TAG, "startScanAfter_SCAN_BREAK_PERIOD: start advertising");
        mHandler.postDelayed(new Runnable() {
            @RequiresApi(api = Build.VERSION_CODES.O)
            @Override
            public void run() {
                Log.d(Util.TAG, "run: stop advertising");
                scanLeDevice(true);
                SCAN_BREAK_PERIOD = (int) (8000 + ((Math.random()*20)*1000));
            }
        }, SCAN_BREAK_PERIOD);
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    public void scanFor_SCAN_PERIOD(){
        Log.d(Util.TAG, "run: starting BLE SCAN");
        MyDevice myDevice = AppDatabase.getINSTANCE(context).myDeviceDao().getMyDevice();
        if(myDevice == null)  mBluetoothAdapter.setName(Util.getDeviceId(context));
        else mBluetoothAdapter.setName(myDevice.device_uuid);
        if (Build.VERSION.SDK_INT > 21){
            mLEScanner.startScan(filters, settings, mScanCallback);
        }else if (Build.VERSION.SDK_INT > 17) {
            mBluetoothAdapter.startLeScan(mLeScanCallback);
        }
        mHandler.postDelayed(new Runnable() {
            @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
            @Override
            public void run() {
                Log.d(Util.TAG, "run: ending BLE SCAN after "+ SCAN_PERIOD/1000 +" seconds.");
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    scanLeDevice(false);
                }
            }
        }, SCAN_PERIOD);
    }

//tecno 5eecfa42-0e7c-3bb5-8279-08730a30917c //samsung e8fb1c40-fa26-3ced-9cad-d34cecd5d18f
// from smasung 0a5f3eb4-5492-f28e-d358-587100076508 // from tecno 0d67b5e7-fccc-1c7e-9355-532084893448


    @RequiresApi(api = Build.VERSION_CODES.O)
    private ScanCallback mScanCallback = new ScanCallback() {
        @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
        @Override
        public void onScanResult(int callbackType, ScanResult result) {
//            Log.d(Util.TAG, "callbackType" + String.valueOf(callbackType));
//            Log.d(Util.TAG, "result" + result.toString());
            if(result.getScanRecord().getServiceUuids() == null || result.getScanRecord().getServiceUuids().size() ==0 || result.getScanRecord().getServiceUuids().get(0) == null)
            {
                byte[] advertisementData = result.getScanRecord().getBytes();
                Log.i(Util.TAG, "onScanResult: advertisement data: " + bytesToHex(advertisementData));
                Log.d(Util.TAG, "onScanResult: service uuid is null");
            }
            else {
                Log.d(Util.TAG, "onScanResult: new device discovered " + result.getScanRecord().getServiceUuids().get(0).getUuid().toString());
                BluetoothDevice btDevice = result.getDevice();
                deviceController.addDevice(result.getDevice(), result.getScanRecord().getServiceUuids().get(0).getUuid().toString(), result.getRssi());
            }
        }
        @Override
        public void onBatchScanResults(List<ScanResult> results) {
            for (ScanResult result : results) {
//                Log.i("ScanResult - Results", result.toString());
                if(result.getScanRecord().getServiceUuids() == null || result.getScanRecord().getServiceUuids().size() ==0 || result.getScanRecord().getServiceUuids().get(0) == null){
                    Log.d(Util.TAG, "onBatchScanResults: from BLE UUID is null");
                    return;
                }
                    Log.d(Util.TAG, "onBatchScanResults: from BLE is "+ result.getDevice().getName());
                deviceController.addDevice(result.getDevice(),result.getScanRecord().getServiceUuids().get(0).toString(), result.getRssi());
            }
        }
        @Override
        public void onScanFailed(int errorCode) {
            Log.e("Scan Failed", "Error Code: " + errorCode);
            Log.d(Util.TAG, "onScanFailed from BLE: "+errorCode);
        }
    };
    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
    private BluetoothAdapter.LeScanCallback mLeScanCallback =
            new BluetoothAdapter.LeScanCallback() {
                @Override
                public void onLeScan(final BluetoothDevice device, int rssi,
                                     byte[] scanRecord) {
                    Log.d(Util.TAG, "onLeScan: we discovered new device "+ device.getName());
                    if(device.getUuids()!=null && device.getUuids().length>0 && device.getUuids()[0] != null)
                    deviceController.addDevice(device,device.getUuids()[0].toString(), rssi);
                }
            };
    public DeviceController getDeviceController(){
        return deviceController;
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    public  String getUUID(ScanResult result){
        String UUIDx = UUID.nameUUIDFromBytes(result.getScanRecord().getBytes()).toString();
        return UUIDx;
    }


    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public void advertiseBle(){

        if(advertiser!=null && dataBuilder!=null && settingsBuilder!=null && advertiseCallback!=null){
            advertiser.startAdvertising(settingsBuilder.build(),dataBuilder.build(),advertiseCallback);
            return;
        }
        advertiser = mBluetoothAdapter.getBluetoothLeAdvertiser();
         dataBuilder = new AdvertiseData.Builder();
        //Define a service UUID according to your needs

        dataBuilder.addServiceUuid(ParcelUuid.fromString(Util.getDeviceId(context)));
//        try {
//            dataBuilder.addServiceData(ParcelUuid.fromString(Util.getDeviceId(context)), Util.get(context).replace("-", "").getBytes("UTF-8"));
//        } catch (UnsupportedEncodingException e) {
//            Log.e(Util.TAG, "advertiseBle: error seting service data");
//            e.printStackTrace();
//        }
//        dataBuilder.addServiceUuid(ParcelUuid.fromString(UUID.randomUUID().toString()));
        dataBuilder.setIncludeDeviceName(false);
        dataBuilder.setIncludeTxPowerLevel(false);


        settingsBuilder = new AdvertiseSettings.Builder();
        settingsBuilder.setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_LOW_POWER);
        settingsBuilder.setTimeout(0);

        //Use the connectable flag if you intend on opening a Gatt Server
        //to allow remote connections to your device.
        settingsBuilder.setConnectable(false);

         advertiseCallback=new AdvertiseCallback() {
            @Override
            public void onStartSuccess(AdvertiseSettings settingsInEffect) {
                super.onStartSuccess(settingsInEffect);
                Log.i(Util.TAG, "onStartSuccess: advertising with UUID: " + ParcelUuid.fromString(Util.getDeviceId(context)).getUuid().toString());
            }

            @Override
            public void onStartFailure(int errorCode) {
                super.onStartFailure(errorCode);
                Log.e(Util.TAG, "onStartFailure: advertising"+errorCode );
            }
        };
         if(advertiser!=null)
        advertiser.startAdvertising(settingsBuilder.build(),dataBuilder.build(),advertiseCallback);

    }

}
