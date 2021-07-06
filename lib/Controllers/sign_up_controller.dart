

import 'dart:convert';

import 'package:ethiocare/model/globalapi.dart';
import 'package:ethiocare/model/my_device.dart';
import 'package:ethiocare/shared_preference/my_device_shared_preference.dart';
import 'package:ethiocare/utils/constants.dart';
import 'package:ethiocare/utils/http_retry.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class SignUpController{
final  MyDeviceSharedPreference myDeviceSharedPreference;

SignUpController({@required this.myDeviceSharedPreference});



Future<int> sendDevice(MyDevice device) async{
    String url = Constants.releaseBaseUrl + "user/signup";
    Response response = await new HttpRetry().post(url
    , body:{
      "full_name": device.full_name,
      "phone_number_user": device.phone_number_user,
      "device_uuid": device.device_uuid==null?"null":device.device_uuid,
      "mac_address": device.mac_address==null?"null":device.mac_address,
      "blue_name":device.blue_name==null?"null":device.blue_name,
      "device_type":device.device_type==null?"null":device.device_type
          ,
    }
    );

    if(response != null && response.statusCode == 200){
      print("post " + url + " response success \n "+jsonDecode(response.body).toString());
      MyDevice myDevice = GlobalApi.getMyDevice(response);

      if(myDevice.id == -1){
        return -1;
      }else{
        device.id = myDevice.id;
        myDeviceSharedPreference.saveMyDevice(device);
        return device.id;
      }


    }else{
      print("post " + url + " response error \n response error loading post request after retry");
      return -2;
    }
  }


}