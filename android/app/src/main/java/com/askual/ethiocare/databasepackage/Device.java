package com.askual.ethiocare.databasepackage;

import android.location.Location;
import android.os.ParcelUuid;
import android.os.Parcelable;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

import com.askual.ethiocare.Util;

@Entity
public  class Device {
    @PrimaryKey(autoGenerate = true)
    public int id;
    @Nullable
    public String name = null;
    @Nullable
    public String uuid = null;
    @Nullable
    public Integer rssi = null;
    @Nullable
    public Long enTime = null;
    @Nullable
    public String mac_address
            = null;
    @Nullable
    public Long exTime = null;
    @Nullable
    public Double enLat = null;
    @Nullable
    public Double enLong = null;
    @Nullable
    public Double enAlt = null;
    @Nullable
    public Float enAcc = null;
    @Nullable
    public Float exAcc = null;
    @Nullable
    public Double exAlt = null;
    @Nullable
    public Double exLong = null;
    @Nullable
    public Double exLat = null;

    public void setStartLocation(Location location){
        this.enAcc = location.getAccuracy();
        this.enAlt = location.getAltitude();
        this.enLat = location.getLatitude();
        this.enLong = location.getLongitude();
    }
    public void setExitLocation(Location location){
        if(location==null) return;
        this.exAcc = location.getAccuracy();
        this.exAlt = location.getAltitude();
        this.exLat = location.getLatitude();
        this.exLong = location.getLongitude();
    }




    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setUuid(ParcelUuid[] puuid) {
        StringBuilder uuid = new StringBuilder();
        if(puuid ==null ||puuid.length==0) return;
        for (ParcelUuid puid: puuid)  uuid.append(puid.getUuid().toString());
        this.uuid = uuid.toString();
    }

    public void setDevice_uuids(String device_uuids) {
        if(device_uuids==null || device_uuids.length()==0) return;
        this.uuid = device_uuids;
    }
    public Integer getRssi() {
        return rssi;
    }

    @Override
    public String toString() {
        return "Device{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", uuid='" + uuid + '\'' +
                ", rssi=" + rssi +
//                ", enTime=" + enTime +
                ", mac_address='" + mac_address + '\'' +
//                ", exTime=" + exTime +
//                ", enLat=" + enLat +
//                ", enLong=" + enLong +
//                ", enAlt=" + enAlt +
//                ", enAcc=" + enAcc +
//                ", exAcc=" + exAcc +
//                ", exAlt=" + exAlt +
//                ", exLong=" + exLong +
//                ", exLat=" + exLat +
                '}';
    }

    public Long getEnTime() {
        return enTime;
    }

    public void setEnTime(Long enTime) {
        this.enTime = enTime;
    }

    public Long getExTime() {
        return exTime;
    }

    public void setExTime(Long exTime) {
        if(this.exTime == null)
        this.exTime = exTime;
        if(this.exTime < exTime) {
            this.exTime = exTime;
       // Log.d(Util.TAG, "setExTime: updated");
        }

    }

    public int getId() {
        return id;
    }

    @Nullable
    public String getMac_address() {
        return mac_address;
    }

    public void setMac_address(@Nullable String mac_address) {
        this.mac_address = mac_address;
    }

    public void setRssi(Integer rssi) {
        if(this.rssi == null)
        this.rssi = rssi;
        else if(rssi > this.rssi){
            this.rssi = rssi;
        }
//        if(this.rssi!=null) Log.d(Util.TAG, "setRssi: "+ rssi + " previous: "+ this.rssi);
    }


    public void setDevice_uuids(Parcelable[] uuidExtra) {
        String uuid = "";
        if (uuidExtra != null) {
            for (Parcelable p : uuidExtra) {
                uuid+=p;
            }
            this.uuid = uuid;
            Log.d(Util.TAG, "setUuid: uuidExtra is set for "+ this.name + " "+ this.uuid);
        } else {
            Log.d(Util.TAG, "stackOverflow: uuidExtra is " + this.name + " still null");
        }
    }

}