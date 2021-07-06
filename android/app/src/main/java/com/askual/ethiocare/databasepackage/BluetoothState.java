package com.askual.ethiocare.databasepackage;


import androidx.room.Entity;
import androidx.room.PrimaryKey;

@Entity
public class BluetoothState {
    @PrimaryKey(autoGenerate = true)
    public int id;
    public Long time;
    public String action;
}
