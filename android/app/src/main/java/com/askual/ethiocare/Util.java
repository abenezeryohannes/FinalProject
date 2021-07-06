package com.askual.ethiocare;

import android.Manifest;
import android.bluetooth.BluetoothAdapter;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.ParcelUuid;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.util.Log;

import androidx.annotation.NonNull;

import com.askual.ethiocare.databasepackage.Device;
import com.askual.ethiocare.databasepackage.MiniDevice;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

public class Util {
    public final static String TAG = "myLog";
    public static final String NOTIFICATION = "myNotification";

    public static long getMinuteDiff(long time){
        long now =new Date().getTime();
        long diffInMillisec = time - now;
        long diffInMin = TimeUnit.MILLISECONDS.toMinutes(diffInMillisec);
        return diffInMin;
    }

    public static List<Device> getDeviceWithCorrectTime(List<Device> deviceList){
        if(deviceList == null || deviceList.size() == 0) return  new ArrayList<>();
        List<Device> correctDevices = new ArrayList<>();
        for(Device d : deviceList){
            Device temp = d;
            temp.setEnTime(getMinuteDiff(temp.enTime));
            temp.setExTime(getMinuteDiff(temp.exTime));
            correctDevices.add(temp);
        }
        return correctDevices;
    }


    public static String getDeviceId(Context context){
        String uuid= "null";
        try {
            TelephonyManager tm = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);

            String androidID = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
              String deviceID = tm.getDeviceId();
//            @SuppressLint("MissingPermission") String simID = tm.getSimSerialNumber();

            if ("9774d56d682e549c".equals(androidID) || androidID == null) {
                androidID = "";
            }

            if (deviceID == null) {
                deviceID = "";
            }

//            if (simID == null) {
//                simID = "";
//            }

            uuid = androidID + deviceID;//+simID;
            uuid = String.format("%32s", uuid).replace(' ', '0');
            uuid = uuid.substring(0, 32);
            uuid = uuid.replaceAll("(\\w{8})(\\w{4})(\\w{4})(\\w{4})(\\w{12})", "$1-$2-$3-$4-$5");

        }catch(Exception e ) {
            Log.e(Util.TAG, "getDeviceId: error occured "+e.getMessage());
        }
        return uuid;
    }

    public static String getBluetoothUUIDS(Context context) {
//        StringBuilder myUUID = new StringBuilder();
//        try {
//            BluetoothAdapter adapter = BluetoothAdapter.getDefaultAdapter();
//            adapter.enable();
//
//            Method getUuidsMethod = BluetoothAdapter.class.getDeclaredMethod("getUuids", null);
//
//            ParcelUuid[] uuids = (ParcelUuid[]) getUuidsMethod.invoke(adapter, (Object) null);
//
//            for (ParcelUuid uuid: uuids) {
//                myUUID.append(uuid.getUuid().toString());
//                Log.d(Util.TAG, "UUID: " + uuid.getUuid().toString());
//            }
//
//            Log.d(Util.TAG, "getBluetoothUUIDS: myUUID: "+myUUID.toString());
//
//        } catch (Exception ignored) {}

        return "null";//myUUID.toString();
    }
    public static String getMacAddr(Context context) {
        String result = null;
        if (context.checkCallingOrSelfPermission(Manifest.permission.BLUETOOTH)
                == PackageManager.PERMISSION_GRANTED) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                // Hardware ID are restricted in Android 6+
                // https://developer.android.com/about/versions/marshmallow/android-6.0-changes.html#behavior-hardware-id
                // Getting bluetooth mac via reflection for devices with Android 6+
                result = android.provider.Settings.Secure.getString(context.getContentResolver(),
                        "bluetooth_address");
            } else {
                BluetoothAdapter bta = BluetoothAdapter.getDefaultAdapter();
                result = bta != null ? bta.getAddress() : "";
            }
        }
        return result;
    }






    public static List<MiniDevice> changeTOMiniDevices(List<Device> deviceList){
        List<MiniDevice> miniDevices = new ArrayList<>();
        for (Device d: deviceList) {
            miniDevices.add(changeToMiniDevice(d));
        }
        return miniDevices;
    }

    public static MiniDevice changeToMiniDevice(Device d){
        MiniDevice mini = new MiniDevice();
        mini.setDevice_uuids(d.uuid);
        mini.setDevice_name(d.name);
        mini.setAltitude(d.enAlt);
        mini.setAccuracy(d.enAcc);
        mini.setLongitude(d.enLong);
        mini.setAddress(d.mac_address);
        mini.setLatitude(d.enLat);
        return mini;

    }

    public static List<Uuids> changeToUuids(List<Device> deviceList){
        List<Uuids> uuids = new ArrayList<>();
        for (Device d: deviceList) {
            if(d.uuid == null) continue;
            uuids.add(new Uuids(d.uuid));
        }
        return uuids;
    }

    static class Uuids{
        String uuid;
        Uuids(String uuid){this.uuid = uuid;}

        @NonNull
        @Override
        public String toString() {
            return "uuid: " + uuid;
        }
    }



    private static final char[] HEX_ARRAY = "0123456789ABCDEF".toCharArray();

    public static String bytesToHex(byte[] bytes) {
        char[] hexChars = new char[bytes.length * 2];
        for (int j = 0; j < bytes.length; j++) {
            int v = bytes[j] & 0xFF;
            hexChars[j * 2] = HEX_ARRAY[v >>> 4];
            hexChars[j * 2 + 1] = HEX_ARRAY[v & 0x0F];
        }
        return new String(hexChars);
    }

}
