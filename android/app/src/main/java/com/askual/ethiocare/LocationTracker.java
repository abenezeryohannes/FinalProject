package com.askual.ethiocare;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Looper;
import android.util.Log;
import android.widget.Toast;

import androidx.core.app.ActivityCompat;

import com.askual.ethiocare.networkcall.CallbackWithRetry;
import com.askual.ethiocare.networkcall.MyLocation;
import com.askual.ethiocare.networkcall.MyResponse;
import com.askual.ethiocare.networkcall.Retro;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.gson.Gson;

import java.util.List;

import retrofit2.Call;
import retrofit2.Response;

public class LocationTracker {
    public static  int LOCATION_REQUEST_CODE = 101;
    boolean isPermited = false;
    private Context context;
    private Location currentLocation;
    private FusedLocationProviderClient fusedLocationProviderClient;

    private LocationCallback locationCallback;

    private static final int  LACTION_UPDATE_REQUEST_INTERVAL = 20000;
    private static final int  LACTION_UPDATE_REQUEST_FAST_INTERVAL = 10000;

    LocationTracker(Context context){
        this.context = context;
        requestLocation();
        startLocationUpdates();
    }

    public Location getCurrentLocation() {
        if(checkPermission(context) && currentLocation == null){
            requestLocation();
            if(locationCallback==null) startLocationUpdates();
        }
        return currentLocation;
    }

    private void startLocationUpdates() {
        if(!checkPermission(context)) return;
        LocationRequest lr = new LocationRequest();
        lr.setPriority(LocationRequest.PRIORITY_LOW_POWER);

        lr.setInterval(LACTION_UPDATE_REQUEST_INTERVAL);
        lr.setFastestInterval(LACTION_UPDATE_REQUEST_FAST_INTERVAL);

        locationCallback = new LocationCallback() {
            @Override
            public void onLocationResult(LocationResult locationResult) {
                if (locationResult == null) {
                    return;
                }
                for (Location location : locationResult.getLocations()) {
                    currentLocation = location;
                    Log.d(Util.TAG, "tracking: latitude: "+currentLocation.getLatitude() +"longitude: "+location.getLongitude() + " altitude: " + location.getAltitude() + " accuracy: " + location.getAccuracy());
                }
            }
        };
        fusedLocationProviderClient.requestLocationUpdates(lr,
                locationCallback,
                Looper.getMainLooper());
    }

    public static boolean  checkPermission(Context context){
        Log.d(Util.TAG, "checkPermission: ");
        boolean permissionAccessCoarseLocationApproved =
                ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION)
                        == PackageManager.PERMISSION_GRANTED;

        if (permissionAccessCoarseLocationApproved) {
            Log.d(Util.TAG, "checkPermission: location approved");
                return true;
        } else {
            Log.d(Util.TAG, "checkPermission: no permission given");
            return false;
            // App doesn't have access to the device's location at all. Make full request
            // for permission.
//            ActivityCompat.requestPermissions(context, new String[] {
//                            Manifest.permission.ACCESS_COARSE_LOCATION
////                            ,Manifest.permission.ACCESS_BACKGROUND_LOCATION
//                    },
//                    LOCATION_REQUEST_CODE);
        }
    }

    public static boolean  checkPermissionAndRequest(Context context, Activity activity){
        Log.d(Util.TAG, "checkPermission: ");
        boolean permissionAccessCoarseLocationApproved =
                ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION)
                        == PackageManager.PERMISSION_GRANTED;

        if (permissionAccessCoarseLocationApproved) {
            Log.d(Util.TAG, "checkPermission: location approved");
            return true;
        } else {
            Log.d(Util.TAG, "checkPermission: no permission given");
            // App doesn't have access to the device's location at all. Make full request
            // for permission.
            ActivityCompat.requestPermissions(activity, new String[] {
                            Manifest.permission.ACCESS_COARSE_LOCATION
//                            ,Manifest.permission.ACCESS_BACKGROUND_LOCATION
                    },
                    LOCATION_REQUEST_CODE);
            return false;
        }
    }



    public void requestLocation(){
        isPermited = checkPermission(context);
        if(!isPermited) return;
        fusedLocationProviderClient = new FusedLocationProviderClient(context);
        fusedLocationProviderClient.getLastLocation().addOnSuccessListener(new OnSuccessListener<Location>() {
            @Override
            public void onSuccess(Location location) {
                         currentLocation = location;

                         if(currentLocation!=null)
                Log.d(Util.TAG, "onSuccess: latitude: "+currentLocation.getLatitude() +"longitude: "+location.getLongitude() + " altitude: " + location.getAltitude() + " accuracy: " + location.getAccuracy());
            }
        });
    }



}
