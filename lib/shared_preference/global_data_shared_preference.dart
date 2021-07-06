import 'dart:convert';
import 'package:ethiocare/model/global_data.dart';
import 'package:ethiocare/shared_preference/change_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalDataSharedPreference extends ChangeObserver{
  
  final String key = "global_data";
  SharedPreferences prefs;

  GlobalDataSharedPreference() {
    loadPreference();
  }

  void loadPreference() async{
       prefs = await SharedPreferences.getInstance();
  }

  void saveGlobalData(GlobalData globalData) async{
    String json = jsonEncode(globalData);
    prefs.setString(key, json);
    onChange();
  }

  Future<GlobalData> getGlobalData() async{
    if(prefs == null) {
      await loadPreference();
    }
    String jsonString = prefs.getString(key);
    if(jsonString == null) return new GlobalData();
    Map<String, dynamic> userMap = jsonDecode(jsonString);
    GlobalData globalData = GlobalData.fromJson(userMap);
    return globalData;
  }

  

 

}