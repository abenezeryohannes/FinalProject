package com.askual.ethiocare.networkcall;

import com.askual.ethiocare.databasepackage.Suspect;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class SuspectPagination {

    @SerializedName("data")
    @Expose
    private List<Suspect> suspectList = null;
    @SerializedName("meta")
    @Expose
    private Meta meta;


}
