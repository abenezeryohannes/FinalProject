package com.askual.ethiocare.databasepackage;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;

import java.util.List;


@Dao
public interface PermmitedDeviceDao {

        @Insert(onConflict = OnConflictStrategy.REPLACE)
        void addPermitted(PermmitedDevice permmitedDevice);

        @Insert(onConflict = OnConflictStrategy.REPLACE)
        void addListPermitted(List<PermmitedDevice> permmitedDevice);

        @Query("SELECT * FROM permmiteddevice")
        List<PermmitedDevice> getAllPermitteds();

        @Query("SELECT * FROM permmiteddevice WHERE( device_uuid = :device_uuid)")
        PermmitedDevice getPermitted(String device_uuid);

        @Delete
        void deletePermitted(List<PermmitedDevice> permmitedDevices);

        @Query("delete FROM permmiteddevice")
        void wipePermitteds();

}
