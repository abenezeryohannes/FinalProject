

import 'dart:convert';
import 'package:ethiocare/model/mini_device.dart';
import 'package:ethiocare/utils/constants.dart';
import 'package:location/location.dart';
import 'package:ethiocare/model/globalapi.dart';
import 'package:ethiocare/model/suspect.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ethiocare/Utils/http_retry.dart';
import 'package:ethiocare/shared_preference/change_observer.dart';

class SuspectController extends ChangeObserver{
  final Function onConnectionError;
  final Function onConnectionSuccessButNoData;
  final Function onResponseSent;
  final String language;

  SuspectController({@required this.onConnectionError, this.onConnectionSuccessButNoData,
    this.onResponseSent, @required this.language});

  void getSuspect(LocationData location, List<MiniDevice> devices) async{
    String url = Constants.releaseBaseUrl+"user/mystatus";
    http.Response response = await new HttpRetry().post( url
    , body:{
      "lang":language,
      "latitude":location.latitude.toString(),
      "longitude":location.longitude.toString(),
      "altitude":location.altitude.toString(),
      "lang":language,
      "language":language,
//     "bluetooth_devices":jsonEncode(devices)
    });
    
    if(response != null && response.statusCode == 200){
      print("post " + url + " response success \n "+jsonDecode(response.body).toString());
      Suspect sus = Suspect.fromJson(jsonDecode(response.body));
      onResponseSent(sus);
//      List<Suspect> suss = GlobalApi.getSuspect(response);
//      onResponseSent(new Suspect(title: "Danger", message: "This is a message section which is sent from server like the title.", status: "red"));

    }else{
      print("post " + url + " response error  \n response error loading post request after retry");
      onConnectionError();
    }
  }

 
}