

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ethiocare/Model/user.dart';
import 'package:ethiocare/Utils/http_retry.dart';
import 'package:ethiocare/shared_preference/change_observer.dart';
import 'package:ethiocare/shared_preference/user_shared_preference.dart';

class TestController extends ChangeObserver{
  
  UserSharedPreference userSharedPreference = new UserSharedPreference();


  

  void getJson() async{
    String url = "getTester";
    http.Response response = await new HttpRetry().get(url);
    if(response!=null && response.statusCode == 200){
      print("get " + url + "response success \n "+jsonDecode(response.body).toString());
      User user = User.fromJson(jsonDecode(response.body));
      userSharedPreference.saveUser(user);
      onChange();
    }else{
      print( "get " + url + "response error \n response error loading post request after retry");
    }
  }


  void postJson() async{
    String url = "postTester";
    http.Response response = await new HttpRetry().post(url, body:{"macAddress":"dum", "phoneNumber":"dum"});
    
    if(response != null && response.statusCode == 200){
      print("post " + url + " response success \n "+jsonDecode(response.body).toString());
      User user = User.fromJson(jsonDecode(response.body));
      userSharedPreference.saveUser(user);
      onChange();
    }else{
      print("post " + url + "response error \n response error loading post request after retry");
    }
  }

 
}