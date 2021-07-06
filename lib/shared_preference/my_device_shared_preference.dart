import 'dart:convert';
import 'package:ethiocare/model/global_data.dart';
import 'package:ethiocare/model/my_device.dart';
import 'package:ethiocare/shared_preference/change_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDeviceSharedPreference extends ChangeObserver{
  
  final String key = "my_device";
  SharedPreferences prefs;

  MyDeviceSharedPreference() {
    loadPreference();
  }

  void loadPreference() async{
       prefs = await SharedPreferences.getInstance();
  }

  void saveMyDevice(MyDevice myDevice) async{
    String json = jsonEncode(myDevice);
    prefs.setString(key, json);
    onChange();
  }

  Future<MyDevice> getMyDevice() async{
    if(prefs == null) {
      await loadPreference();
    }
    String jsonString = prefs.getString(key);
    if(jsonString == null) return new MyDevice();
    Map<String, dynamic> map = jsonDecode(jsonString);
    MyDevice myDevice = MyDevice.fromJson(map);
    return myDevice;
  }



}