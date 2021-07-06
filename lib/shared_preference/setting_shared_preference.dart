import 'dart:convert';
import 'package:ethiocare/model/setting.dart';
import 'package:ethiocare/shared_preference/change_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingSharedPreference extends ChangeObserver{
  
  final String key = "setting";
  SharedPreferences prefs;

  SettingSharedPreference() {
    loadPreference();
  }

  void loadPreference() async{
       prefs = await SharedPreferences.getInstance();
  }

  void saveSetting(Setting setting) async{
    String json = jsonEncode(setting);
    prefs.setString(key, json);
    onChange();
  }

  Future<Setting> getSetting() async{
    if(prefs == null) {
      await loadPreference();
    }
    String jsonString = prefs.getString(key);
    if(jsonString == null) return new Setting();
    Map<String, dynamic> userMap = jsonDecode(jsonString);
    Setting setting = Setting.fromJson(userMap);
    return setting;
  }

  

 

}