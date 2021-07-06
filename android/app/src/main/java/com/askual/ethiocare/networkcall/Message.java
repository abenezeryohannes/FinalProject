package com.askual.ethiocare.networkcall;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class Message {
    @SerializedName("status")
    @Expose
    public String status;
    @SerializedName("title")
    @Expose
    public String title;
    @SerializedName("description")
    @Expose
    public String message;
    @SerializedName("uuid")
    @Expose
    public String uuid;


}
