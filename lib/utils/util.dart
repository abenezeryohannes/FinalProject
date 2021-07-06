
import 'dart:math';

import 'package:ethiocare/Tracker/TrackAnim.dart';
import 'package:ethiocare/model/country_data.dart';
import 'package:ethiocare/model/suspect.dart';
import 'package:ethiocare/model/location.dart' as myLocation;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class Util{



// // Start scanning
// flutterBlue.scan(scanMode:ScanMode.lowPower, timeout: new Duration(seconds: 10)).listen((onData){
//        print(""+
//       "device name: @{onData.name.toString()}"+
//       "Rssi: @{f.rssi.toString()}"+
//       "advertismentdata: @{onData.advertisementData.toString()}"+
//       "device id: @{onData.id.toString()}"+
//       "device type: @{onData.type.toString()}"+
//       "device state: @{onData.state.toString()}"+
//       "device manufacturer data: @{onData.advertisementData.manufacturerData.keys.toList().toString()}"+ 
//       "\n\n\n");
  
//    // print('${device.name} found! rssi: ${device.}');
// });
static String getShownNameOfCountryProperty(CountryData cd, int index){
  String f = cd.toJson().keys.toList()[index];
  return getNameOfProperty(f);
  }

  
static String getNameOfCountryProperty(CountryData cd, int index){
  String f = cd.toJson().keys.toList()[index];
  return f;
}
  
static String getNameOfProperty(String x){
  if(x == null) return "";
  return x.toUpperCase()[0] + x.replaceAll("_", ' ').substring(1);
}


static int dayDifference(DateTime fromNow){
    DateTime now =  DateTime.now();
    return fromNow.difference(now).inDays;
  }
static int hourDifference(DateTime fromNow){
    DateTime now =  DateTime.now();
    return fromNow.difference(now).inHours;
  }
static int minutDifference(DateTime fromNow){
  DateTime now =  DateTime.now();
  return fromNow.difference(now).inMinutes;
  }

  
static String readTimestamp(int timestamp) {
  DateTime now = DateTime.now();
  var format = DateFormat('HH:mm a');
  DateTime date =  DateTime.fromMillisecondsSinceEpoch(timestamp.toInt());
  return format.format(date);
  }

static int currentTimeInSeconds() {
  var ms = (new DateTime.now()).millisecondsSinceEpoch;
  return (ms ).round();
}



static double calculatedistance(LocationData loc1, loc2){
  double lat1 = loc1.latitude;
  double lon1 = loc1.longitude;
  double lat2 = loc2.latitude;
  double lon2 = loc2.longitude;
  return calculatedistance3(lat1, lon1, lat2, lon2);
  }

static double calculatedistance2(myLocation.Location loc1,LocationData loc2){
  double lat1 = loc1.latitude;
  double lon1 = loc1.longitude;
  double lat2 = loc2.latitude;
  double lon2 = loc2.longitude;
  return calculatedistance3(lat1, lon1, lat2, lon2);
  }

static double calculatedistance3(double lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 + 
          c(lat1 * p) * c(lat2 * p) * 
          (1 - c((lon2 - lon1) * p))/2;
    return  12742 * asin(sqrt(a));
  }



  static List<Widget> showPoints(Size size, List<Suspect> suspects){
    int i = 0;
    return suspects.map((f){
      return Positioned(
        height: 10,
        width: 10,
        left: (i+10)/1, right: (i+5)/1,
        child: Icon(Icons.ac_unit),
      
      );
    
    }).toList();
  }



  static bool checkIFDanger(List<Suspect> suspects, LocationData currentLocation) {
    print("need to implement Util.checkIfDanger(List<suspect>, LocationData)");
    return false;
  }



}