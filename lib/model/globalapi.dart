import 'dart:convert';

import 'package:ethiocare/Tracker/location_tracker.dart';
import 'package:ethiocare/model/country_data.dart';
import 'package:ethiocare/model/info.dart';
import 'package:ethiocare/model/info_category.dart';
import 'package:ethiocare/model/my_device.dart';
import 'package:ethiocare/model/news.dart';
import 'package:ethiocare/model/suspect.dart';
import 'package:http/http.dart' as http;
import 'package:ethiocare/model/global_data.dart';
import 'package:location/location.dart';

class GlobalApi{

  static GlobalData getGlobalData(http.Response response){
      Map<String, dynamic> json = jsonDecode(response.body);
      print(json.toString());
      GlobalData globals = GlobalData.fromJson(json);
      // print(globals);
      return globals;
  }


  static List<InfoCategory> getCategories(http.Response response){
      Map<String, dynamic> json = jsonDecode(response.body);
      //print(json['results'][0]);
      var catArray = json['categories'];
      var infoArray = json['infos'];
      List<InfoCategory> categories = (catArray as List).map((e)=> new InfoCategory.fromJson(e)).toList();
      List<Info> infos = (infoArray as List).map((e)=> new Info.fromJson(e)).toList();
//      print(categories.toString());
//      print(infos.toString());
//    List<InfoCategory> categories = new List();
//    for(int i =0;i<10;i++){
//      categories.add(new InfoCategory(id:i, description: "description", title: "title $i"));
//    }

    // print(globals);
      return categories;
  }


  static List<InfoCategory> getCategoriesFromFile(String file){
    Map<String, dynamic> json = jsonDecode(file);
    var catArray = json['categories'];
    var infoArray = json['infos'];
    List<InfoCategory> categories = (catArray as List).map((e)=> new InfoCategory.fromJson(e)).toList();
    List<Info> infos = (infoArray as List).map((e)=> new Info.fromJson(e)).toList();
    return categories;
  }

  static List<Info> getInfosFromFile(String file){
    Map<String, dynamic> json = jsonDecode(file);
    var infoArray = json['infos'];
    List<Info> infos = (infoArray as List).map((e)=> new Info.fromJson(e)).toList();
    return infos;
  }


  static List<Info> getInfos(http.Response response){
      Map<String, dynamic> json = jsonDecode(response.body);
      //print(json['results'][0]);
      var infoArray = json['infos'];
      List<Info> infos = (infoArray as List).map((e)=> new Info.fromJson(e)).toList();
//      print(infos.toString());
      // print(infos.toString());
//    List<Info> infos = new List();
//    for(int i =0;i<10;i++){
//      for(int j = 0;j<10;j++){
//        infos.add(new Info(id: j, category_id: i, title: "title$j", description: "des$j"));
//      }
//    }
      return infos;
  }



  static List<CountryData> getCountries(http.Response response){
      Map<String, dynamic> json = jsonDecode(response.body);
      var countriesArray = json["countries"];
      List<CountryData>  countries =  (countriesArray as List).map((e)=> new CountryData.fromJson(e)).toList();
      return countries;
  }


  static List<CountryData> getFakeCountries(http.Response response){
    List<CountryData> countries = new List();
    for(int i =0;i<20;i++){
      countries.add(new CountryData(title: "country $i", ));
    }
    return countries;
  }



  static CountryData getCountry(http.Response response){
      Map<String, dynamic> json = jsonDecode(response.body);
      CountryData countryData = CountryData.fromJson(json);
      return countryData;
  }

  static List<Suspect> getSuspect(http.Response response) {
  Map<String, dynamic> json = jsonDecode(response.body);
      var suspectArray = json["suspects"];
      print(suspectArray);
      List<Suspect>  suspects =new List();//  (suspectArray as List).map((e)=> new Suspect.fromJson(e)).toList();
      
//
//      for(int i=0;i<20;i++){
//        suspects.add(new Suspect(latitude: 8.5336557, longitude:39.2562123, suspection:0));
//      }
//
      return suspects;
   
  }

  static List<News> getNewsData(http.Response response) {

//    List<News> newses = new List();
    var  json = jsonDecode(response.body);
    List<News>  news =  (json as List).map((e)=> new News.fromJson(e)).toList();
//    for(int i=start+1;i<start+11;i++){
//      newses.add(
//        new News(id:i, title: "Title Number $i", description: "This is probably the highr number of text "
//            "art will be visible becouse i am a geneious and u can't find any one with controlling issue of what can and"
//            "can't be displayed in the front page of the master mind mega person of the motive of doning it to make her cum"
//            "like a pro of the general data is dum ok why are you still reading this it makes no sense i am just tired and want"
//            "to go to sleep but can i no i can't since you are reading these i can't stop typing please quite reading you dum mother"
//            "fucker i am tired of your ass",
//            time: "2 hours ago",
//            source: "from TIK-VAH ethiopia",
//            image_url: "source.unsplash.com/random",)
//      );}
    return news;
  }

  static MyDevice getMyDevice(http.Response response) {
//    return MyDevice.fromJson(jsonDecode(response.body));
    MyDevice myDevice = MyDevice.fromJson(jsonDecode(response.body));
    return myDevice;
  }


}