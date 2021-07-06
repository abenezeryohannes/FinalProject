package com.askual.ethiocare.databasepackage;

import androidx.annotation.NonNull;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

@Entity
public  class PermmitedDevice {
    @NonNull
    @PrimaryKey
    public String device_uuid;


    public PermmitedDevice(String device_uuid){
        this.device_uuid = device_uuid;
    }

}