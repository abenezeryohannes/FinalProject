package com.askual.ethiocare.databasepackage;

import android.content.Context;

import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;

@Database(entities = {Device.class,PermmitedDevice.class,Suspect.class, BluetoothState.class, MyDevice.class}, version = 1, exportSchema = false)
public abstract class AppDatabase extends RoomDatabase {

    public static AppDatabase INSTANCE;

    public static AppDatabase getINSTANCE(Context context) {
        if (INSTANCE == null) {
            INSTANCE = Room.databaseBuilder(context.getApplicationContext(), AppDatabase.class, "database.db").allowMainThreadQueries().build();
        }
        return INSTANCE;
    }
    public abstract DeviceDao deviceDao();
    public abstract BluetoothStateDao bluetoothState();
    public abstract MyDeviceDao myDeviceDao();
    public abstract PermmitedDeviceDao permmitedDeviceDao();
    public abstract SuspectDao suspectDao();

}

