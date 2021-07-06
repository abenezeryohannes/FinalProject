package com.askual.ethiocare.databasepackage;

import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;

import java.util.List;

@Dao
public interface BluetoothStateDao {


    @Insert(onConflict = OnConflictStrategy.IGNORE)
    void addBluetoothState(BluetoothState bluetoothStates);

    @Insert(onConflict = OnConflictStrategy.IGNORE)
    void addListBluetoothState(List<BluetoothState> bluetoothStates);

    @Query("SELECT * FROM bluetoothstate ORDER BY id ASC")
    List<BluetoothState> getAllBluetoothState();

    @Query("SELECT * FROM bluetoothstate ORDER BY id ASC LIMIT 30")
    List<BluetoothState> getAllSendableBluetoothstates();

    @Delete
    void deleteBluetoothStates(List<BluetoothState> bluetoothStates);


}
