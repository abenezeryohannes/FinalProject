package com.askual.ethiocare.databasepackage;

import android.content.Context;
import android.util.Log;

import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;

import com.askual.ethiocare.BluetoothController;
import com.askual.ethiocare.DataSender;
import com.askual.ethiocare.MyService;
import com.askual.ethiocare.Util;
import com.askual.ethiocare.networkcall.MyLocation;

import java.util.ArrayList;
import java.util.List;

public class Repository {


    private  final AppDatabase appDatabase;
    private DataSender dataSender;
    private Context context;
    private BluetoothController bluetoothController = null;
    MyService myService;

    public void setBluetoothController(BluetoothController bluetoothController) {
        Log.d(Util.TAG, "setBluetoothController: to repository! ");
        this.bluetoothController = bluetoothController;
    }

    public MyService getMyService() {
        return myService;
    }

    public BluetoothController getBluetoothController() {
        return bluetoothController;
    }

    public Repository(MyService myService, Context context) {
        this.myService = myService;
        this.context = context;
        this.appDatabase = AppDatabase.getINSTANCE(context);
        this.dataSender = new DataSender( context, Repository.this);
    }

    //Device query
    public void addDevice(Device device){
        Log.d(Util.TAG, "addDevice: "+device.toString());
        appDatabase.deviceDao().addDevice(device);
        Log.d(Util.TAG, "addDevice: after: "+ appDatabase.deviceDao().getAllDevices().toString());

        Log.i("myLog", "sending saved device connection to server from repo ");
        dataSender.sendDatas();
    }

    public void addListDevice(List<Device> devices){
//        Log.d(Util.TAG, "addListDevice: " + devices.toString());
        appDatabase.deviceDao().addListDevice(devices);
        dataSender.sendBluetoothStates();
//        Log.d(Util.TAG, "after saving: " + appDatabase.deviceDao().getAllDevices().toString());
    }

    public List<Device> getAllDevices(){
//        Log.d(Util.TAG, "getAllDevices: "+appDatabase.deviceDao().getAllDevices().toString());
        return appDatabase.deviceDao().getAllDevices();
    }

    public Device getDevice(int id){
        return appDatabase.deviceDao().getDevice(id);
    }

    public void deleteDevice(List<Device> devices){
//        Log.d(Util.TAG, "deleteDevice: "+ devices.toString());
        appDatabase.deviceDao().deleteDevice(devices);
//        Log.d(Util.TAG, "after deleting devices "+ appDatabase.deviceDao().getAllDevices().toString());

    }

    public List<Device> getAllSendableDevices() {
       return appDatabase.deviceDao().getAllSendableDevices();
    }

    //my device queries

    public void addMyDevice(MyDevice device){
        appDatabase.myDeviceDao().addMyDevice(device);
    }

    public MyDevice getMyDevice(){
        return appDatabase.myDeviceDao().getMyDevice();
    }

    public void deleteMyDevice(MyDevice  device){
        appDatabase.myDeviceDao().deleteMyDevice(device);
    }


    ///bluetooth query
    public void addBluetoothState(BluetoothState bluetoothStates){
        appDatabase.bluetoothState().addBluetoothState(bluetoothStates);
    }

    public void addListBluetoothState(List<BluetoothState> bluetoothStates){
        appDatabase.bluetoothState().addListBluetoothState(bluetoothStates);
    }

    public List<BluetoothState> getAllBluetoothState(){
        return appDatabase.bluetoothState().getAllBluetoothState();
    }

    public List<BluetoothState> getAllSendableBluetoothstates(){
        return appDatabase.bluetoothState().getAllSendableBluetoothstates();
    }

    public void deleteBluetoothStates(List<BluetoothState> bluetoothStates){
        appDatabase.bluetoothState().deleteBluetoothStates(bluetoothStates);
    }



    public void sendNewDeviceConnection(Device device){
        Log.d(Util.TAG, "sendNewDeviceConnection: from repository ");
//        if(device == null || device.size() ==0) return;
        List<String> uuids = new ArrayList<>();
//        for(int i =0;i<devices.size();i++){
//            uuids.add(devices.get(i).uuid);
//        }
        dataSender.sendCurrentNewConnection(device);
        
    }

    public void sendLocation(MyLocation location) {
        if(location!=null){
//            dataSender.sendCurrentLocation(location);
            dataSender.getSuspects(location);
        }
    }

    public void onNoDeviceDetected() {
        if(bluetoothController == null) return;
        if(bluetoothController.isOn() && bluetoothController.isDiscovering()){
            Log.d(Util.TAG, "onNoDeviceDetected: bluetooth is on so notify no suspect");
            dataSender.onNoBTDevice();
        }else Log.d(Util.TAG, "onNoDeviceDetected: bluetooth is off so don't notify no suspect");
    }









    public void addSuspect(Suspect device){appDatabase.suspectDao().addSuspect(device);}

    public void addListSuspect(List<Suspect> devices){appDatabase.suspectDao().addListSuspect(devices);}

    public List<Suspect> getAllSuspects(){return appDatabase.suspectDao().getAllSuspects();}

    public Suspect getSuspect(String device_uuid){return appDatabase.suspectDao().getSuspect(device_uuid);}
    public Suspect getSuspectMac(String address){return appDatabase.suspectDao().getSuspectFromMac(address);}

    public void deleteSuspect(List<Suspect> suspects){appDatabase.suspectDao().deleteSuspect(suspects);}

    public void wipeSuspects(){appDatabase.suspectDao().wipeSuspects();}


    public void addPermitted(PermmitedDevice permmitedDevice){ appDatabase.permmitedDeviceDao().addPermitted(permmitedDevice);}

    public void addListPermitted(List<PermmitedDevice> permmitedDevice){appDatabase.permmitedDeviceDao().addListPermitted(permmitedDevice);}

    public List<PermmitedDevice> getAllPermitteds(){return appDatabase.permmitedDeviceDao().getAllPermitteds();}

    public PermmitedDevice getPermitted(String device_uuid){ return appDatabase.permmitedDeviceDao().getPermitted(device_uuid);}

    public void deletePermitted(List<PermmitedDevice> permmitedDevices){appDatabase.permmitedDeviceDao().deletePermitted(permmitedDevices);}

    public void wipePermitteds(){appDatabase.permmitedDeviceDao().wipePermitteds();}

    public Context getContext() { return context;}

}
