package com.askual.ethiocare.databasepackage;

import android.location.Location;
import android.os.ParcelUuid;
import android.os.Parcelable;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

import com.askual.ethiocare.Util;

public  class MiniDevice {
    public String  device_name = null;
    public String device_uuids = null;
    public Integer  device_rssi = null;
    public String address  = null;
    public Float accuracy = null;
    public Double altitude = null;
    public Double longitude = null;
    public Double latitude = null;

    public String getDevice_uuids() {
        return device_uuids;
    }

    public void setDevice_uuids(String device_uuids) {
        this.device_uuids = device_uuids;
    }

    public Float getAccuracy() {
        return accuracy;
    }

    public void setAccuracy(Float accuracy) {
        this.accuracy = accuracy;
    }

    public Double getAltitude() {
        return altitude;
    }

    public void setAltitude(Double altitude) {
        this.altitude = altitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public String getDevice_name() {
        return device_name;
    }

    public void setDevice_name(String device_name) {
        this.device_name = device_name;
    }

    public void setDevice_uuids(ParcelUuid[] device_uuids) {
        StringBuilder uuid = new StringBuilder();
        if(device_uuids==null || device_uuids.length==0) {
            Log.d(Util.TAG, "setUuid: uuid is null");return;}
        for (ParcelUuid puid: device_uuids)  uuid.append(puid.getUuid().toString());
        this.device_uuids = uuid.toString();
    }

    public Integer getDevice_rssi() {
        return device_rssi;
    }


    @Override
    public String toString() {
        return "MiniDevice{" +
                "name='" + device_name + '\'' +
                ", uuid='" + device_uuids + '\'' +
                ", rssi=" + device_rssi +
                ", mac_address='" + address + '\'' +
                ", accuracy=" + accuracy +
                ", altitude=" + altitude +
                ", longitude=" + longitude +
                ", latitude=" + latitude +
                '}';
    }

    @Nullable
    public String getAddress() {
        return address;
    }

    public void setAddress(@Nullable String address) {
        this.address = address;
    }

    public void setDevice_rssi(Integer device_rssi) {
        if(this.device_rssi == null)
        this.device_rssi = device_rssi;
        else if(device_rssi > this.device_rssi){
            this.device_rssi = device_rssi;
        }
//        if(this.rssi!=null) Log.d(Util.TAG, "setRssi: "+ rssi + " previous: "+ this.rssi);
    }


    public void setDevice_uuids(Parcelable[] uuidExtra) {
        String uuid = "";
        if (uuidExtra != null) {
            for (Parcelable p : uuidExtra) {
                uuid+=p;
            }
            this.device_uuids = uuid;
            Log.d(Util.TAG, "setUuid: uuidExtra is set for "+ this.device_name+ " "+ this.device_uuids);
        } else {
            Log.d(Util.TAG, "stackOverflow: uuidExtra is " + this.device_name + " still null");
        }
    }
}