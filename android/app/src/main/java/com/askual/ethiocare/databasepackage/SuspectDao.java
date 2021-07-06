package com.askual.ethiocare.databasepackage;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;

import java.util.List;


@Dao
public interface SuspectDao {

        @Insert(onConflict = OnConflictStrategy.REPLACE)
        void addSuspect(Suspect device);

        @Insert(onConflict = OnConflictStrategy.REPLACE)
        void addListSuspect(List<Suspect> devices);

        @Query("SELECT * FROM suspect")
        List<Suspect> getAllSuspects();

        @Query("SELECT * FROM suspect WHERE( device_uuid = :device_uuid)")
        Suspect getSuspect(String device_uuid);

        @Query("SELECT * FROM suspect WHERE( address = :mac_address)")
        Suspect getSuspectFromMac(String mac_address);

        @Delete
        void deleteSuspect(List<Suspect> suspects);

        @Query("delete FROM suspect")
        void wipeSuspects();

}
