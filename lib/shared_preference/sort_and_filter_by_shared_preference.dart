import 'dart:convert';
import 'package:ethiocare/model/global_data.dart';
import 'package:ethiocare/shared_preference/change_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SortAndFilterbySharedPreference extends ChangeObserver{
  
  final String key = "sortby";
  final String key2 = "filterby";
  SharedPreferences prefs;

  SortAndFilterbySharedPreference() {
    loadPreference();
  }

  void loadPreference() async{
       prefs = await SharedPreferences.getInstance();
  }

  void saveSortBy(String sortBy) async{
    prefs = await SharedPreferences.getInstance();
    prefs.setString(key, sortBy);
    onChange();
  }

  Future<String> getSortBy() async{
    if(prefs == null) {
      await loadPreference();
    }
    return prefs.getString(key);
  }

  void savefilterBy(String filterBy) async{
    prefs = await SharedPreferences.getInstance();
    prefs.setString(key2, filterBy);
    onChange();
  }

  Future<String> getFilterBy() async{
    if(prefs == null) {
      await loadPreference();
    }
    return prefs.getString(key2);
  }

  

 

}