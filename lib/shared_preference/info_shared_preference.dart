
import 'dart:convert';

import 'package:ethiocare/model/info.dart';
import 'package:ethiocare/Model/info_category.dart';
import 'package:ethiocare/shared_preference/change_observer.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoSharedPreference with ChangeObserver{

final String key = "info";
  SharedPreferences prefs;

  InfoSharedPreference() {
    loadPreference();
  }

  void loadPreference() async{
       prefs = await SharedPreferences.getInstance();
  }

 void saveListOfInfos(List<Info> info) async{
    String json = jsonEncode(info);
    prefs.setString(key, json);
    onChange();
  }

  Future<List<Info>> loadListOfInfos() async{
    if(prefs == null) {
      await loadPreference();
    }
    String jsonString = prefs.getString(key);
    List<Info> infos = new List();
    if(jsonString == null) return new List();
    infos = (json.decode(jsonString) as List).map (
          (i) => Info.fromJson(i)
      ).toList();
    return infos;
  }



}