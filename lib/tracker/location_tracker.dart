import 'package:ethiocare/Utils/util.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';



class LocationTracker {
  final Function onLocationChanged;

  LocationTracker({@required this.onLocationChanged}){
    _initialize();
  }

  Location location = new Location();
  LocationData userLocation;
  LocationData startingLocation;


   void _initialize(){
    print("location tracker initialized");

      location.onLocationChanged.listen((value) {
        // print("location tracker location changed"+ value.toString());
      if(userLocation == null) {
        print("got first location" + value.toString());
        userLocation = value;
         onLocationChanged(value);
      }else{
        if(Util.calculatedistance(value, userLocation)>=1){
          print("one km change detected");
          userLocation = value;
          onLocationChanged(userLocation);
        }
      }
    });
    }
  





  Future<LocationData> getLocation() async{
   userLocation = await  _getLocation();
   return userLocation;

  }

  
  Future<LocationData> _getLocation() async {
    location.changeSettings(accuracy: LocationAccuracy.high);
    try {
      return await location.getLocation();
    } catch (e) {
    }
  }

  

}