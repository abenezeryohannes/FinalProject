package com.askual.ethiocare;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.util.Log;

import com.askual.ethiocare.databasepackage.BluetoothState;
import com.askual.ethiocare.databasepackage.Device;
import com.askual.ethiocare.databasepackage.MiniDevice;
import com.askual.ethiocare.databasepackage.MyDevice;
import com.askual.ethiocare.databasepackage.Repository;
import com.askual.ethiocare.databasepackage.Suspect;
import com.askual.ethiocare.networkcall.CallbackWithRetry;
import com.askual.ethiocare.networkcall.Message;
import com.askual.ethiocare.networkcall.MyLocation;
import com.askual.ethiocare.networkcall.MyResponse;
import com.askual.ethiocare.networkcall.NetworkUtil;
import com.askual.ethiocare.networkcall.Retro;
import com.askual.ethiocare.networkcall.Suspects;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.List;

import retrofit2.Call;
import retrofit2.Response;

public class DataSender {
    Repository repository;
    Context context;
    boolean isSendingConnectionRequest = false;
    boolean isSendingBluetoothRequest = false;

    boolean connected = false;
    MyDevice myDevice;




    public DataSender(Context context, Repository repository){
        this.context = context; this.repository = repository;
        IntentFilter filter = new IntentFilter("android.net.conn.CONNECTIVITY_CHANGE");
        IntentFilter filter2 = new IntentFilter("android.net.wifi.WIFI_STATE_CHANGED");
        context.registerReceiver(NetworkChangeReceiver, filter);
        context.registerReceiver(NetworkChangeReceiver, filter2);
        updateMyDevice();
        Log.d(Util.TAG, "DataSender: myId: "+myDevice.id);
    }

    private void updateMyDevice() {
        myDevice = repository.getMyDevice();
        if(myDevice == null){
            myDevice = new MyDevice(1);
        }
    }


    final BroadcastReceiver NetworkChangeReceiver  = new  BroadcastReceiver(){
        @Override
        public void onReceive(final Context context, final Intent intent) {
            int status = NetworkUtil.getConnectivityStatusString(context);
            if ("android.net.conn.CONNECTIVITY_CHANGE".equals(intent.getAction())) {
                if (status == NetworkUtil.NETWORK_STATUS_NOT_CONNECTED) {//                    Log.d(Util.TAG, "onReceive: no connection");
                connected  = false;
                NotificationExtras.whenNoConnection(repository.getMyService(), context);
                } else {//                    Log.d(Util.TAG, "onReceive: connection");
                        connected = true;
                        NotificationExtras.whenOnConnection(repository.getMyService(), context);
                        getMessageIfAny();
                        if(repository != null && repository.getBluetoothController()!=null && repository.getBluetoothController().getDeviceController()!=null&& repository.getBluetoothController().getDeviceController().getDeviceList()!=null)
                        sendCurrentConnections(Util.changeToUuids(repository.getBluetoothController().getDeviceController().getDeviceList()));
                        sendDatas();
                    }
            }
        }
    };






    private void sendConnections() {
        updateMyDevice();
        final List<Device> allSendableDevices = Util.getDeviceWithCorrectTime(repository.getAllSendableDevices());
        Log.d(Util.TAG, "sendConnections: sending saved connection " + allSendableDevices.toString());
        if(isSendingConnectionRequest || allSendableDevices.size() == 0) return;
        isSendingConnectionRequest = true;
        Retro.connections(myDevice.id, new Gson().toJson( allSendableDevices )).enqueue(
                new CallbackWithRetry<MyResponse>(context) {
                    @Override
                    public void onResponse(Call<MyResponse> call, Response<MyResponse> response) {
                        super.onResponse(call, response);
                        Log.d("myLog", "onResponse: success sending connection!");
                        if(response.body()==null) return;
                        if(response.body().status ==  1) {
                            repository.deleteDevice(allSendableDevices);
                            isSendingConnectionRequest = false;
                         }
                        sendConnections();
                    }
                    @Override
                    public void onFailure(Call<MyResponse> call, Throwable t) {
                        super.onFailure(call, t);
                        Log.d("myLog", "onFailure: sending connections");
                        isSendingConnectionRequest = false;
                    }
                });
    }





    public void sendBluetoothStates(){
        updateMyDevice();
        final List<BluetoothState> bluetoothStates = repository.getAllSendableBluetoothstates();
        if(isSendingBluetoothRequest || bluetoothStates == null || bluetoothStates.size() == 0) return;
        isSendingBluetoothRequest = true;
        Retro.sendBluetoothStates(myDevice.id, new Gson().toJson(bluetoothStates)).enqueue(
                new CallbackWithRetry<MyResponse>(context) {
                    @Override
                    public void onResponse(Call<MyResponse> call, Response<MyResponse> response) {
                        super.onResponse(call, response);
                        Log.d(Util.TAG, "onResponse: success sending bluetooth states");
                        repository.deleteBluetoothStates(bluetoothStates);
                        isSendingBluetoothRequest = false;
                        sendBluetoothStates();
                    }


                    @Override
                    public void onFailure(Call<MyResponse> call, Throwable t) {
                        isSendingBluetoothRequest = true;
                        Log.d("myLog", "onFailure: sending bluetooth state");
                        super.onFailure(call, t);
                    }
                }
        );
    }





    public void sendDatas(){
        if(repository.getMyDevice() != null) {
//                Log.d(Util.TAG, "sendDatas: got myDevice "+ repository.getMyDevice().toString());
                if(connected){
                    Log.d(Util.TAG, "sendDatas: connected so sending all available data ... ");
                    sendConnections();
                    //sendBluetoothStates();
                }else Log.d(Util.TAG, "sendDatas: not connected so unable to send ... ");
            }else{
            Log.d(Util.TAG, "sendDatas: myDevice no saved yet!!");
        }
    }







    public void sendCurrentNewConnection(Device device) {
//        Log.d(Util.TAG, "sendCurrentNewConnection: already sending the request to server ");
//        List<Device> devices = new ArrayList<>();
//        devices.add(device);
//        sendCurrentConnections(Util.changeToUuids(devices));
        //we gonna send all connected devices to check if they are treats.
        if(repository != null && repository.getBluetoothController()!=null && repository.getBluetoothController().getDeviceController()!=null&& repository.getBluetoothController().getDeviceController().getDeviceList()!=null)
        {
            Log.d(Util.TAG, "sendCurrentNewConnection: sending all connections even if one new device is found");
            sendCurrentConnections(Util.changeToUuids(repository.getBluetoothController().getDeviceController().getDeviceList()));
        }else{
            Log.d(Util.TAG, "sendCurrentNewConnection: can't send the new connection because ");
            Log.d(Util.TAG, "repository is null   ||   rep bluecontroller is null   ||   rep blue dev conroller is null ");
        }
    }








    private void sendCurrentConnections(List<Util.Uuids> deviceList) {
        Log.d(Util.TAG, "sendCurrentConnections: is called but not important since all suspects are loaded for offline so dismissed the request");
//        updateMyDevice();
//        if( deviceList==null||deviceList.size()==0) return;
//        Log.d(Util.TAG, "sendCurrentConnections:  "+ deviceList.toString());
//        Log.d(Util.TAG, "sendCurrentConnections: "+new Gson().toJson(deviceList));
//        if(connected){
//            Retro.sendCurrentConnection(myDevice.id, new Gson().toJson(deviceList) )
//            .enqueue(new CallbackWithRetry<Message>(context) {
//                @Override
//                public void onResponse(Call<Message> call, Response<Message> response) {
//                    super.onResponse(call, response);
//                    Message message = response.body();
//                    if(message!=null && message.status!=null && message.title!=null && message.message!=null){
//                       if(!message.status.equals("unknown")){
//                           NotificationExtras.whenSuspectFound(repository.getMyService(), context, message);
//                       }else NotificationExtras.whenNoSuspect(repository.getMyService(), context);
//                    }
//                    Log.d(Util.TAG, "onResponse: sending current connections");
//                }
//                @Override
//                public void onFailure(Call<Message> call, Throwable t) {
//                    super.onFailure(call, t);
//                    Log.d(Util.TAG, "onFailure: sending current connection");
//                }}); }
    }








    public void getMessageIfAny(){
        updateMyDevice();
        Log.d(Util.TAG, "getMessageIfAny: called");
        Retro.getMessage(myDevice.id).enqueue(new CallbackWithRetry<List<Message>>(context) {
            @Override
            public void onResponse(Call<List<Message>> call, Response<List<Message>> response) {
                super.onResponse(call, response);
                Log.d(Util.TAG, "onResponse: getList<Message>IfAny");
                if(response.body()!=null && response.body().size()>0){
                    for (Message m: response.body()) {
                        if(m.status.equals("unknown"))
                        NotificationExtras.showSimpleNotification(
                                context,
                                m.title,
                                m.message,
                                m.status
                        );
                        else{
                         NotificationExtras.whenIamSuspect(repository.getMyService(), context, m);
                        }
                    } if (connected) getMessageIfAny(); }}

            @Override
            public void onFailure(Call<List<Message>> call, Throwable t) {
                super.onFailure(call, t); }});
    }








    public void sendCurrentLocation(MyLocation myLocation){
        updateMyDevice();
        if(connected) {
            Retro.sendCurrentLocation(myDevice.id, myLocation.accuracy, myLocation.longitude, myLocation.altitude, myLocation.latitude)
                    .enqueue(new CallbackWithRetry<Message>(context) {
                        @Override
                        public void onResponse(Call<Message> call, Response<Message> response) {
                            super.onResponse(call, response);

                            Message message = response.body();
                            if (message != null && message.status != null && message.title != null && message.message != null) {
                                if (!message.status.equals("unknown")) {
                                    NotificationExtras.whenLocationSuspectFound(repository.getMyService(), context, message);
                                } else
                                    NotificationExtras.whenLocationNoSuspect(repository.getMyService(), context);
                            } else
                                NotificationExtras.whenLocationNoSuspect(repository.getMyService(), context);

                            Log.d(Util.TAG, "onResponse: sending current connections");
                        }

                        @Override
                        public void onFailure(Call<Message> call, Throwable t) {
                            super.onFailure(call, t);
                            Log.d(Util.TAG, "onFailure: location not updated !!!");
                        }
                    });
        }

    }



    public void onNoBTDevice() {
        NotificationExtras.whenNoSuspect(repository.getMyService(), context);
       }




   public void getSuspects(MyLocation myLocation){
       updateMyDevice();
       Log.d(Util.TAG, "getSuspects: getting suspects from data sender");
    Retro.getSuspect(myDevice.id, myLocation.accuracy, myLocation.longitude, myLocation.altitude, myLocation.latitude).enqueue(new CallbackWithRetry<List<Suspect>>(context) {
        @Override
        public void onResponse(Call<List<Suspect>> call, Response<List<Suspect>> response) {
            super.onResponse(call, response);
            if(response.body() != null &&response.body().size()>0){
                Log.d(Util.TAG, "onResponse: getting suspect returned");
                if(repository.getAllSuspects()!=null)
                    Log.d(Util.TAG, "onResponse: before saved data is : " + repository.getAllSuspects().size());
                repository.addListSuspect(response.body());
                Log.d(Util.TAG, "onResponse: saved all response");
                if(repository.getAllSuspects()!=null)
                Log.d(Util.TAG, "onResponse: after saved data is : " + repository.getAllSuspects().size());

            }else{
                Log.d(Util.TAG, "onResponse: getsuspect returned no data");
            }
        }

        @Override
        public void onFailure(Call<List<Suspect>> call, Throwable t) {
            super.onFailure(call, t);
            Log.d(Util.TAG, "onFailure: getting suspects");
        }
    });

   }



}
