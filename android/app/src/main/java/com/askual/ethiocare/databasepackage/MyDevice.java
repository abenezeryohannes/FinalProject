package com.askual.ethiocare.databasepackage;

import android.content.IntentFilter;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

@Entity
public class MyDevice {

    @PrimaryKey
    @SerializedName("id")
    public Integer id;

    @SerializedName("device_uuid")
    public String device_uuid;

    @SerializedName("blue_name")
    public String blue_name;

    @SerializedName("mac_address")
    @Expose
    public String mac_address;
    @SerializedName("phone_number_user")
    @Expose
    public String phone_number_user;

    @SerializedName("phone_number_fetch")
    @Expose
    public String phone_number_fetch;

    @SerializedName("full_name")
    @Expose
    public String full_name;
    @SerializedName("device_type")
    @Expose
    public String device_type;


    public MyDevice(int id){
        this.id = id;
    }
    @Override
    public String toString() {
        return "MyDevice{" +
                "id=" + id +
                ", name='" + device_uuid + '\'' +
                ", blue_name='" + blue_name + '\'' +
                ", mac_address='" + mac_address + '\'' +
                ", device_uuid='" + device_uuid + '\'' +
                ", phone_number_user='" + phone_number_user + '\'' +
                ", phone_number_fetch='" + phone_number_fetch + '\'' +
                ", full_name='" + full_name + '\'' +
                ", device_type='" + device_type + '\'' +
                '}';
    }
}
