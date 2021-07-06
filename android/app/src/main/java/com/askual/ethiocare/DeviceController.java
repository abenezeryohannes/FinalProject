package com.askual.ethiocare;

import android.bluetooth.BluetoothDevice;
import android.location.Location;
import android.os.CountDownTimer;
import android.util.Log;

import com.askual.ethiocare.databasepackage.Device;
import com.askual.ethiocare.databasepackage.Repository;
import com.askual.ethiocare.databasepackage.Suspect;
import com.askual.ethiocare.networkcall.Message;
import com.askual.ethiocare.networkcall.MyLocation;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

public class DeviceController {
    private List<Device> deviceList = new ArrayList<>();
    private final int timeOfExit = 300000;//60000
    private LocationTracker locationTracker;
    private Repository repository;

    public List<Device> getDeviceList() {
        return deviceList;
    }

    DeviceController(LocationTracker locationTracker, Repository repository){
        this.locationTracker = locationTracker;
        this.repository = repository;
        updateDeviceLeaveToDetectDeviceExit();
    }

     void addDevice(BluetoothDevice bluetoothDevice,String uuid, int rssi){
        if(!locationTracker.isPermited) {
            Log.d(Util.TAG, "location no permitted so couldn't save device");return;}
        Device dev = changeBluetoothDevice(bluetoothDevice, rssi);
        boolean is_present = false;
        for (Device d: deviceList) {
            if(d.mac_address.equals(dev.mac_address)){
                int index = deviceList.indexOf(d);
                d.setExTime(new Date().getTime());
                d.setDevice_uuids(uuid);
                d.setExitLocation(locationTracker.getCurrentLocation());
                d.setRssi(rssi);
                deviceList.set(index, d);
                is_present = true;
                Log.d(Util.TAG, "addDevice: device "+ d.name + " UUID "+d.uuid +" time and rssi updated "+d.getRssi());
                break;
            }
        }
        if(!is_present){
            // else  set the start time and add the device in the list;
            dev.setEnTime(new Date().getTime());
            dev.setExTime(new Date().getTime());
            dev.setDevice_uuids(uuid);
            if(locationTracker.getCurrentLocation()!=null) {
                dev.setStartLocation(locationTracker.getCurrentLocation());
                dev.setExitLocation(locationTracker.getCurrentLocation());
            }
            //for name coding
            deviceList.add(dev);
            Log.d(Util.TAG, "addDevice: device "+ dev.getName() + " added as new");
            Log.d(Util.TAG, "addDevice: since its new checking for suspect offline and online if connected");
            repository.sendNewDeviceConnection(dev);
            checkIfSuspect(dev);

        }
    }



    private void checkIfSuspect(Device dev) {
        Log.d(Util.TAG, "checkIfSuspect: sending" + dev.name + " device if i am connected to check if it is suspect");
        Suspect s = repository.getSuspect(dev.uuid);
        if(s==null) s = repository.getSuspectMac(dev.mac_address);
        if(s == null){
            Log.d(Util.TAG, "checkIfSuspect: checkIfSuspect: found device "+dev.name +" not suspect");
        }else if(s.status.equals("unknown")){
            Log.d(Util.TAG, "checkIfSuspect: checkIfSuspect: found device "+dev.name +" unknown suspect");
        }
        else{
            if(repository.getPermitted(dev.uuid)!=null){
                Log.d(Util.TAG, "checkIfSuspect: found device "+dev.name +" to be permitted");
                return;
            }
            Log.d(Util.TAG, "checkIfSuspect: found device "+dev.name +" to be suspect");
            Message message = new Message();
            message.status = s.status;
            message.title = "danger";
            message.message = "We found "+dev.name +" to be suspecious please take care!!";
            message.uuid = dev.uuid;
            NotificationExtras.whenSuspectFound(repository.getMyService(), repository.getContext(), message);
        }
    }


    private Device changeBluetoothDevice(BluetoothDevice bluetoothDevice, int rssi) {
        Device dev = new Device();
        dev.setName(bluetoothDevice.getName());
        dev.setUuid(bluetoothDevice.getUuids());
        dev.setMac_address(bluetoothDevice.getAddress());
        dev.setRssi(rssi);
        return dev;
    }




    private void updateDeviceLeaveToDetectDeviceExit(){
        new CountDownTimer(1000000000, timeOfExit){
            @Override
            public void onTick(long millisUntilFinished) {
                    detectDeviceLeave();
            }

            @Override
            public void onFinish() {
                this.start();
            }
        }.start();
    }

     private void detectDeviceLeave(){
        for (Device d: deviceList) {
            if(Math.abs(Util.getMinuteDiff(d.getExTime())) >= TimeUnit.MILLISECONDS.toMinutes(timeOfExit)){
                repository.addDevice(d);
                Log.d(Util.TAG, "detectDeviceLeave: ");//+ d.getName());
                deviceList.remove(d);
            } }

        if(deviceList.size() ==0) {
            repository.onNoDeviceDetected();
        }
         Log.d(Util.TAG, "sending current location to server" );
         repository.sendLocation(getLocation());
        Log.d(Util.TAG, "last Available Devices"+ deviceList.toString());
    }

    public MyLocation getLocation(){
        Location location = locationTracker.getCurrentLocation();
        if(location==null) return  null;
        MyLocation myLocation =new MyLocation();
        myLocation.altitude = location.getAltitude();
        myLocation.longitude = location.getLongitude();
        myLocation.latitude = location.getLatitude();
        myLocation.accuracy = location.getAccuracy();
        return myLocation;
    }


}
