package com.askual.ethiocare.databasepackage;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;

import java.util.List;


@Dao
public interface DeviceDao {

        @Insert(onConflict = OnConflictStrategy.REPLACE)
        void addDevice(Device device);

        @Insert(onConflict = OnConflictStrategy.IGNORE)
        void addListDevice(List<Device> devices);

        @Query("SELECT * FROM device ORDER BY id ASC")
        List<Device> getAllDevices();

        @Query("SELECT * FROM device ORDER BY id ASC LIMIT 10")
        List<Device> getAllSendableDevices();


        @Query("SELECT * FROM device WHERE( id = :id)")
        Device getDevice(int id);

        @Delete
        void deleteDevice(List<Device> devices);



}
