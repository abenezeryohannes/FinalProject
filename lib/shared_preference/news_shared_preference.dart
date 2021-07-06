import 'dart:convert';
import 'package:ethiocare/model/news.dart';
import 'package:ethiocare/model/news.dart';
import 'package:ethiocare/shared_preference/change_observer.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsSharedPreference extends ChangeObserver{

  String key = "all";
  SharedPreferences prefs;

  NewsSharedPreference({@required this.key}) {this.key = "all";loadPreference();}

  void setWhoseNews(String key){
    this.key = key;
    key = "all";
  }

  void loadPreference() async{
    prefs = await SharedPreferences.getInstance();
  }

  void _sNews(News news) async{
    String json = jsonEncode(news);
    prefs.setString(key, json);

  }

  Future<List<News>> getNewses() async{
    if(prefs == null) {
      await loadPreference();
    }
    String jsonString = prefs.getString(key);
    if(jsonString == null) return new List();
    if(json.decode(jsonString) == null) return new List();
    List<News> sus = new List();
    sus = (json.decode(jsonString) as List).map (
            (i) => News.fromJson(i)
    ).toList();
    return sus;
  }

  void _sNewses(List<News> newses) async{
    if(prefs == null ) {
      prefs = await SharedPreferences.getInstance();
    }
    String json = jsonEncode(newses);
    prefs.setString(key, json);
  }

  void saveNewses(List<News> newses){

    getNewses().then((onValue){

      if(onValue == null || onValue.length == 0)
      {
        print("newses : " + newses.toString());
        _sNewses(newses);
        onChange();
        return;
      }

      for (News sus in newses) {
        int present = 0;
        for(News ns in onValue){
          if(ns.id == (sus.id)){
            onValue[onValue.indexOf(ns)] = sus;
            present = 1;
            break;
          }
        }
        if(present == 0) onValue.add(sus);
      }

      print("before sort: "+onValue.toString());
      onValue.sort((a, b){
        return a.id.compareTo(b.id)*-1;
      });
      print("after sort: "+onValue.toString());

      _sNewses(onValue);
      onChange();
    });

  }

  void saveSuspect(News ns){

    getNewses().then((onValue){

      if(onValue == null || onValue.length == 0)
      {
        _sNews(ns);
        onChange();return;
      }

      int present = 0;
      for(News s in onValue){
        if(s.id == (ns.id)){
          onValue[onValue.indexOf(s)] = ns;
          present = 1;
          break;
        }
      }

      if(present == 0) onValue.add(ns);

      _sNewses(onValue);
      onChange();
    });
  }

  void removeNewses() async{
    _sNewses(new List());
  }










}