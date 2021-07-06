import 'dart:convert';
import 'package:ethiocare/model/location.dart';
import 'package:ethiocare/shared_preference/change_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationSharedPreference extends ChangeObserver{
  
  final String key = "location";
  SharedPreferences prefs;

  LocationSharedPreference() {
    loadPreference();
  }

  void loadPreference() async{
       prefs = await SharedPreferences.getInstance();
  }

  void saveLocation(Location location) async{
    String json = jsonEncode(location);
    prefs.setString(key, json);
    onChange();
  }

  Future<Location> getLocation() async{
    if(prefs == null) {
      await loadPreference();
    }
    String jsonString = prefs.getString(key);
    if(jsonString == null) return new Location();
    Map<String, dynamic> userMap = jsonDecode(jsonString);
    Location location = Location.fromJson(userMap);
    return location;
  }

  

 

}