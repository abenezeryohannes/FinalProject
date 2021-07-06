

import 'dart:convert';
import 'dart:io';

import 'package:ethiocare/model/mini_device.dart';
import 'package:ethiocare/model/my_device.dart';
import 'package:flutter/services.dart';

import 'model/mini_device.dart';

class FlutterToAndroid{

   static const String method= "com.askual.ethiocare";
   static const String startService = "startService";
   static const String turnBluetoothOn = "turnBluetoothOn";
   static const String checkIfSupported = "checkIfSupported";
   static const String isBluetoothOn = "isBluetoothOn";
   static const String tellFriends = "tellFriends";
   static const String getDeviceInfo = "getDeviceInfo";
   static const String getNearbyBluetoothDevices = "getNearbyBluetoothDevices";
   static const String saveMyDevice = "saveMyDevice";
   static const String subject = "Ethio Care";
   static const String started = "started";
   static const String text = "Check out the Ethiopian app for COVID-19 disease protection designed for users to identify those who have been exposed to the virus."
       "\n\nYou can download it from the official telegram channel https://t.me/ethiocare"
       "\nor from playstore https://play.google.com/store/apps/details?id=com.askual.ethiocare.\n\n";
   static const String phone_number = "phone_number";
   static const String calls = "call";
   static const String called = "called";
   static const String device = "device";
  void startSeviceInPlatform() async {
    if(Platform.isAndroid){
      var methodChannel = MethodChannel(method);
      String data = await  methodChannel.invokeMethod(startService);
      print(data);
    }
  }

  Future<bool> turnBluetoothOnInPlatform() async {
    String data = "not answared";
    if(Platform.isAndroid){
      var methodChannel = MethodChannel(method);
      data = await  methodChannel.invokeMethod(turnBluetoothOn);
      print(data);
    }
    if(data.endsWith(started))return true;
    return false;
  }
Future<bool> checkIfDeviceSupported() async {
    String data = "yes";
    if(Platform.isAndroid){
      var methodChannel = MethodChannel(method);
      data = await  methodChannel.invokeMethod(checkIfSupported);
      print(data);
    }
    if(data.endsWith("yes"))return true;
    return false;
  }

  void isBluetoothOnPlatform() async {
    if(Platform.isAndroid){
      var methodChannel = MethodChannel(method);
      String data = await  methodChannel.invokeMethod(isBluetoothOn);
      print(data);
    }
  }

  void tellFriendsOnPlatform() async{
    if(Platform.isAndroid){
      var methodChannel = MethodChannel(method);
      String result = await methodChannel.invokeMethod(tellFriends, {"subject": subject, "text":text});
      print("result of platform sharing text is $result");
    }
  }


  Future<List<MiniDevice>> getNearByBluetoothDevice() async{
    String data = "not answared";
    if(Platform.isAndroid){

      var methodChannel = MethodChannel(method);
      data = await  methodChannel.invokeMethod(getNearbyBluetoothDevices);

      print("nearby devices $data");
      if(data == "off"){
        return null;
//        turnBluetoothOnInPlatform();
      }else {
        var miniDeviceArray = jsonDecode(data);
        List<MiniDevice> miniDevices = (miniDeviceArray as List).map((
            e) => new MiniDevice.fromJson(e)).toList();
        print("ok ok ok ok ok ok ${miniDevices.toString()}");
      return miniDevices;
      }
    }
  }


  Future<MyDevice> getDeviceDataFromAndroid() async{
    String data = "not answared";
    if(Platform.isAndroid){
      var methodChannel = MethodChannel(method);
      data = await  methodChannel.invokeMethod(getDeviceInfo);
//      print("nearby devices $data");
      Map<String, dynamic> json = jsonDecode(data);
      MyDevice myDevice = MyDevice.fromJson(json);
      print("Flutter getting this data $myDevice");
      myDevice.device_type = "android";
      return myDevice;
    }
  }

  Future<bool> saveDeviceDataToAndroid(MyDevice myDevice) async{
    String data;
    if(Platform.isAndroid){
      var methodChannel = MethodChannel(method);
      data = await  methodChannel.invokeMethod(saveMyDevice, {"device": jsonEncode( myDevice)});
      print("Flutter recieved this data after saving: "+ data);
      if(data == "successfull") return true;
      else return false;
    }else return true;
  }

  void call(String phone_number) async{
    String data;
    if(Platform.isAndroid) {
      var methodChannel = MethodChannel(method);
      data = await methodChannel.invokeMethod(
          calls, {"phone_number": phone_number});
      print("Flutter calling response: " + data);
    }
  }

}