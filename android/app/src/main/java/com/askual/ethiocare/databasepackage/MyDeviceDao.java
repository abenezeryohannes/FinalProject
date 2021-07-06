package com.askual.ethiocare.databasepackage;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;

import java.util.List;

@Dao
public interface MyDeviceDao {


    @Insert(onConflict = OnConflictStrategy.IGNORE)
    void addMyDevice(MyDevice device);

    @Query("SELECT * FROM mydevice ORDER BY id ASC LIMIT 1")
    MyDevice getMyDevice();

    @Delete
    void deleteMyDevice(MyDevice  device);


}
