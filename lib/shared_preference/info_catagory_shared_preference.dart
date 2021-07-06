
import 'dart:convert';

import 'package:ethiocare/model/info_category.dart';
import 'package:ethiocare/shared_preference/change_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoCatagorySharedPreference with ChangeObserver{


final String key = "cat";
  SharedPreferences prefs;

  InfoCatagorySharedPreference() {
    loadPreference();
  }

  void loadPreference() async{
       prefs = await SharedPreferences.getInstance();
  }

 void saveListOfCategory(List<InfoCategory> cats) async{
    String json = jsonEncode(cats);
    prefs.setString(key, json);
    onChange();
  }


  Future<List<InfoCategory>> loadListOfCategories() async{
    if(prefs == null) {
      await loadPreference();
    }
    String jsonString = prefs.getString(key);
    List<InfoCategory> cats = new List();
    if(jsonString == null) return new List();
    cats = (json.decode(jsonString) as List).map (
          (i) => InfoCategory.fromJson(i)
      ).toList();
    return cats;
  }

  

 



}