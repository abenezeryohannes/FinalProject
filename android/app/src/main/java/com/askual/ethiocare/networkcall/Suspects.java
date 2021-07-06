package com.askual.ethiocare.networkcall;


import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class Suspects{
    @SerializedName("uuid")
    @Expose
    public String uuid;
    @SerializedName("suspection")
    @Expose
    public int suspection;
    @SerializedName("latitude")
    @Expose
    public double latitude;
    @SerializedName("longitude")
    @Expose
    public double longitude;
    @SerializedName("altitude")
    @Expose
    public double altitude;

}
