package com.askual.ethiocare.networkcall;
import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class Meta  {

    @SerializedName("current_page")
    @Expose
    private Integer currentPage;
    @SerializedName("from")
    @Expose
    private Integer from;
    @SerializedName("last_page")
    @Expose
    private Integer lastPage;
    @SerializedName("path")
    @Expose
    private String path;
    @SerializedName("per_page")
    @Expose
    private Integer perPage;
    @SerializedName("to")
    @Expose
    private Integer to;
    @SerializedName("total")
    @Expose
    private Integer total;

    public Meta(){}
    protected Meta(Parcel in) {
        if (in.readByte() == 0) {
            currentPage = null;
        } else {
            currentPage = in.readInt();
        }
        if (in.readByte() == 0) {
            from = null;
        } else {
            from = in.readInt();
        }
        if (in.readByte() == 0) {
            lastPage = null;
        } else {
            lastPage = in.readInt();
        }
        path = in.readString();
        if (in.readByte() == 0) {
            perPage = null;
        } else {
            perPage = in.readInt();
        }
        if (in.readByte() == 0) {
            to = null;
        } else {
            to = in.readInt();
        }
        if (in.readByte() == 0) {
            total = null;
        } else {
            total = in.readInt();
        }
    }


    public Integer getCurrentPage() {
        return currentPage;
    }

    public void setCurrentPage(Integer currentPage) {
        this.currentPage = currentPage;
    }

    public Integer getFrom() {
        return from;
    }

    public void setFrom(Integer from) {
        this.from = from;
    }

    public Integer getLastPage() {
        return lastPage;
    }

    public void setLastPage(Integer lastPage) {
        this.lastPage = lastPage;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public Integer getPerPage() {
        return perPage;
    }

    public void setPerPage(Integer perPage) {
        this.perPage = perPage;
    }

    public Integer getTo() {
        return to;
    }

    public void setTo(Integer to) {
        this.to = to;
    }

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }


}
