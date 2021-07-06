import 'package:ethiocare/Controllers/suspect_controller.dart';
import 'package:ethiocare/Tracker/location_tracker.dart';
import 'package:connectivity/connectivity.dart';
import 'package:ethiocare/flutter_to_android.dart';
import 'package:ethiocare/languages/strings.dart';
import 'package:ethiocare/model/mini_device.dart';
import 'package:ethiocare/model/suspect.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:async';

import 'TrackAnim.dart';

class TraitTracker{


  final Function connectionChange;
  final Function onTraitFound;
  final Function onDanger;
  final Function onBluetoothChange;
  Strings strings;
  StreamSubscription<ConnectivityResult> subscription;
  // Stream stream;

  // StreamController<List<Suspect> > controller;

  TraitTracker({@required this.connectionChange, this.onDanger, this.onTraitFound, this.onBluetoothChange,@required this.strings}){
      //  controller = StreamController<List<Suspect>>();  
      //  stream = controller.stream;

       checkIfBluetoothOn();
       getLocationAndInitialize();
       subscription = Connectivity().onConnectivityChanged.listen((result){
         checkIfConnection();
       });

  }
  void onDisponse(){subscription.cancel();}

 bool connected = true;
 BuildContext context;
 SuspectController suspectController;
 LocationData currentLocation;
 LocationTracker locationTracker;


  FlutterToAndroid flutterToAndroid  = new FlutterToAndroid();


    void checkIfBluetoothOn() async{

      FlutterToAndroid flutterToAndroid = new FlutterToAndroid();
      bool isBluetoothon = await flutterToAndroid.turnBluetoothOnInPlatform();


    }

    

      void checkIfConnection() async{
        // ask for bluetooth device list;

        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          print("noConnection");
          whenNoConnectionOrConnectionError();
        }else{
          print("connection");
          print("post request to get suspects in current location");
          this.connectionChange(true);

         // flutterToAndroid = new FlutterToAndroid();
          LocationData userLocation = await locationTracker.getLocation();
         // bool bluetoothOn = await flutterToAndroid.turnBluetoothOnInPlatform();
//          if(bluetoothOn) {
//            List<MiniDevice> miniDevices = await flutterToAndroid.getNearByBluetoothDevice();
//            suspectController.getSuspect(userLocation, miniDevices);
//          }else
          suspectController.getSuspect(userLocation,null);
        }
    
      }
  
    
      void whenNoConnectionOrConnectionError() async{
        print("when on No Connection");
        this.connectionChange(false);
      }
    

      void getLocationAndInitialize() {
        print("getting location from location tracker");
        locationTracker = new LocationTracker(
          onLocationChanged: locationChanged
        );

        suspectController = new SuspectController(
          onConnectionError: whenNoConnectionOrConnectionError,
          onConnectionSuccessButNoData: noSuspectDetected,
          onResponseSent: onResponseSent,
          language: strings.lang
        );
      }


      void onResponseSent(Suspect response){
        print("response sent was "+ response.toString());
        switch(response.status.toLowerCase()){
          case "danger":
            this.onTraitFound(TrackAnim.red_zone, response.title, response.message);
            break;
          case "yellow":
            this.onTraitFound(TrackAnim.yellow_zone, response.title, response.message);
            break;
          case "red":
            this.onTraitFound(TrackAnim.red_zone, response.title, response.message);
            break;
          case "unknown":
            this.onTraitFound(TrackAnim.green_zone, response.title, response.message);
            break;
          case "bluetooth":
            this.onTraitFound(TrackAnim.not_connected, response.title, response.message);
            break;
        }
      }

      void locationChanged(LocationData location)async{
        this.currentLocation = location;
        checkIfConnection();
      }



      void noSuspectDetected(){
        print("no suspect detected online");
        this.onTraitFound(TrackAnim.green_zone);
//        suspectSharedPreference.getSuspects().then((onValue){
//            if(onValue == null || onValue.length == 0){
//              this.onTraitFound(null, Util.checkifSuspectInTheArea(locationTracker.getLocation(), null));
//              print("no saved suspect found");
//
//            }else{
//              print("checking if saved suspects are in the area");
//              this.onTraitFound(onValue, Util.checkifSuspectInTheArea(locationTracker.getLocation(), onValue));
//            }
//            });
      }









}