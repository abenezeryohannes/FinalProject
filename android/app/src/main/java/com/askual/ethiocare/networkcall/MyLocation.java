package com.askual.ethiocare.networkcall;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class MyLocation {
    @SerializedName("latitude")
    @Expose
    public double latitude;
    @SerializedName("longitude")
    @Expose
    public double longitude;
    @SerializedName("altitude")
    @Expose
    public double altitude;
    @SerializedName("accuracy")
    @Expose
    public float accuracy;
}
