package com.askual.ethiocare.networkcall;


import com.askual.ethiocare.databasepackage.Suspect;

import java.util.List;

import retrofit2.Call;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.GET;
import retrofit2.http.Header;
import retrofit2.http.Headers;
import retrofit2.http.POST;

/**
 * Created by Abenezer on 7/1/2018.
 */

public interface Api {

//            String BASE_URL = "http://192.168.137.1/ShimmerWeb/public/";
        String BASE_URL = "https://corona.ethiogeeks.com/";


        @FormUrlEncoded
        @POST("suspect/add")
        Call<MyResponse> connection(@Field("sender") int id, @Field("connections") String connections);

        @FormUrlEncoded
        @POST("user/signup")
        Call<MyResponse> sendBluetoothState(@Field("sender") int id, @Field("bluetooth_states") String bluetoothStates);

        @FormUrlEncoded
        @POST("user/checkconnection")
        Call<Message> sendCurrentConnection(@Field("sender") int id, @Field("device_uuid") String connections);

//
//        @FormUrlEncoded
//        @POST("user/signup")
//        Call<MyResponse> sendCurrentLocation(@Field("user_id") int id);

        @FormUrlEncoded
        @POST("user/updatelocation")
        Call<Message> sendCurrentLocation(@Field("user_id") int id, @Field("accuracy") double accuracy,@Field("longitude") double longitude,@Field("altitude") double altitude,@Field("latitude") double latitude);

        @FormUrlEncoded
        @POST("user/getnotifications")
        Call<List<Message>> getMessage(@Field("user_id") int id);


        @FormUrlEncoded
        @POST("suspect/get")
        Call<List<Suspect>> getSuspects(@Field("user_id") int id,@Field("accuracy") double accuracy,@Field("longitude") double longitude,@Field("altitude") double altitude,@Field("latitude") double latitude);



//        @Headers({ "Content-Type: application/json;charset=UTF-8"})
//        @GET("api/getvitalsstruct")
//        Call<MyResponse> getBasicStracture();


}
