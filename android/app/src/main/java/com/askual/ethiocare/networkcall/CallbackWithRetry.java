package com.askual.ethiocare.networkcall;
import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.CountDownTimer;
import android.util.Log;


import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public abstract class CallbackWithRetry<T> implements Callback<T> {

    public static final int TOTAL_RETRIES = 5;
    private static final String TAG = "retryLog";
    public int retryCount = 0;
    Context context;

    public CallbackWithRetry(Context context){
        this.context = context;
    }

    @Override
    public void onResponse(Call<T> call, Response<T> response) {
        Log.d(TAG, call.request().toString()+" successFully after "+retryCount +" retry");
    }

    @Override
    public void onFailure(Call<T> call, Throwable t) {

        if(checkInternetConnection()) {
            Log.d(TAG, t.getLocalizedMessage());
            if (retryCount++ < TOTAL_RETRIES) {
                Log.d(TAG, "Retrying... (" + retryCount + " out of " + TOTAL_RETRIES + ") ..... " + call.request().toString());
                retry(call);
            }
        }else{
            new CountDownTimer(100000000, 10000){
                @Override
                public void onTick(long millisUntilFinished) {
                    if(checkInternetConnection()) {
                        Log.d(TAG, t.getLocalizedMessage());

                        if (retryCount++ < TOTAL_RETRIES) {
                            Log.d(TAG, "Retrying... (" + retryCount + " out of " + TOTAL_RETRIES + ") ..... " + CallbackWithRetry.class.getSimpleName());
                            retry(call);
                        }
                        else this.cancel();
                    } else {
                        retryCount = TOTAL_RETRIES;
                        Log.d(TAG, "onTick: No Internet Connnection "+ call.request().toString());
                    }
                }

                @Override
                public void onFinish() {

                }
            }.start();
        }
    }

    private void retry(Call<T> call) {
        call.clone().enqueue(this);
    }


    public  boolean checkInternetConnection(){
        ConnectivityManager cm =
                (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);

        NetworkInfo activeNetwork = cm.getActiveNetworkInfo();
        return activeNetwork != null && activeNetwork.isConnectedOrConnecting();
    }
}