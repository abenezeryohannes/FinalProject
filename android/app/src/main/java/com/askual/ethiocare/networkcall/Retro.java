package com.askual.ethiocare.networkcall;

import com.askual.ethiocare.databasepackage.Suspect;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.List;

import retrofit2.Call;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.POST;

public class Retro {

    public static Api getApi()
    {
        Gson gson = new GsonBuilder().setLenient().create();
        return new Retrofit.Builder()
                .addConverterFactory(GsonConverterFactory.create(gson))
                .baseUrl(Api.BASE_URL)
                .build().create(Api.class);
    }

    public static Call<MyResponse> connections(int id, String connections){
        return getApi().connection(id, connections);
    }

    public static Call<MyResponse> sendBluetoothStates(int id, String bluetoothStates){
        return getApi().sendBluetoothState(id, bluetoothStates);
    }
    public static Call<Message> sendCurrentLocation(int id, double accuracy, double longitude, double altitude, double latitude){
        return getApi().sendCurrentLocation(id,  accuracy,  longitude,  altitude,  latitude);
    }

    public static Call<Message> sendCurrentConnection(int id, String connections){
        return getApi().sendCurrentConnection(id, connections);
    }
    public static Call<List<Message>> getMessage(int id){
        return getApi().getMessage(id);
    }
 public static Call<List<Suspect>> getSuspect(int id, double accuracy, double longitude, double altitude, double latitude){
        return getApi().getSuspects(id, accuracy,  longitude,  altitude,  latitude);
    }


}
