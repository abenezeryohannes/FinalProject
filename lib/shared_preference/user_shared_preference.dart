import 'dart:convert';

import 'package:ethiocare/Model/user.dart';
import 'package:ethiocare/shared_preference/change_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreference extends ChangeObserver{
  
  final String key = "user";
  final String key2 = "users";
  SharedPreferences prefs;

  UserSharedPreference() {
    loadPreference();
  }

  void loadPreference() async{
       prefs = await SharedPreferences.getInstance();
  }

  void saveUser(User user) async{
    String json = jsonEncode(user);
    prefs.setString(key, json);
    onChange();
  }

  Future<User> loadUser() async{
    if(prefs == null) {
      await loadPreference();
    }
    String jsonString = prefs.getString(key);
    Map userMap = jsonDecode(jsonString);
    User user = User.fromJson(userMap);
    return user;
  }

  
  void saveListOfUser(List<User> users) async{
    String json = jsonEncode(users);
    prefs.setString(key2, json);
    onChange();
  }

  Future<List<User>> loadListOfUser() async{
    if(prefs == null) {
      await loadPreference();
    }
    String jsonString = prefs.getString(key2);
    List<User> users = new List();

    users = (json.decode(jsonString) as List).map (
          (i) => User.fromJson(i)
      ).toList();
    return users;
  }

 

}