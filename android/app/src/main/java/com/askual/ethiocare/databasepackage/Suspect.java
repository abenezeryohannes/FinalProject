package com.askual.ethiocare.databasepackage;

import android.location.Location;
import android.os.ParcelUuid;
import android.os.Parcelable;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

import com.askual.ethiocare.Util;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

@Entity
public  class Suspect {
    @NonNull
    @PrimaryKey
    @SerializedName("device_uuid")
    @Expose
    public String device_uuid;

    @SerializedName("status")
    @Expose
    public String status;

    @SerializedName("mac_address")
    @Expose
    public String address;


    public Suspect(String device_uuid, String status, String address){
        this.device_uuid = device_uuid;
        this.status = status;
        this.address = address;
    }


    @Override
    public String toString() {
        return "Suspect{" +
                "device_uuid='" + device_uuid + '\'' +
                ", status='" + status + '\'' +
                ", mac_address='" + address + '\'' +
                '}';
    }
}