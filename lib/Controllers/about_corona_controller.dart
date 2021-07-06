import 'dart:convert';
import 'package:ethiocare/languages/strings.dart';
import 'package:ethiocare/model/info.dart';
import 'package:ethiocare/model/info_category.dart';
import 'package:ethiocare/model/globalapi.dart';
import 'package:ethiocare/shared_preference/change_observer.dart';
import 'package:ethiocare/shared_preference/info_catagory_shared_preference.dart';
import 'package:ethiocare/shared_preference/info_shared_preference.dart';
import 'package:ethiocare/utils/constants.dart';
import 'package:http/http.dart' as http;


class AboutCoronaController with ChangeObserver{


  final InfoCatagorySharedPreference catPrefs;
  final InfoSharedPreference infoPrefs;

  AboutCoronaController(this.catPrefs, this.infoPrefs);
  void getInfo(Strings strings) async{
    String url = Constants.releaseBaseUrl+"getdata/infos?lang="+strings.lang;
    http.Response response = await http.get(url).catchError((onError){
      //ignore
    });
    if(response!=null && response.statusCode == 200){
      print("get " + url + "response success \n "+jsonDecode(response.body).toString());
      
      // GlobalData globalData = GlobalData.fromJson(jsonDecode(response.body));
      List<InfoCategory> cats = GlobalApi.getCategories(response);
      List<Info> infos = GlobalApi.getInfos(response);


      // catPrefs.loadListOfCategories().then((onValue){
      //   if(onValue!=cats) {
      //     catPrefs.saveListOfCategory(cats);
      //   }
      // });
      // infoPrefs.loadListOfInfos().then((onValue){
      //   if(onValue!=infos) {
      //     infoPrefs.saveListOfInfos(infos);
      //   }
      // });
    }else{
      onChange();
      print( "get " + url + "response error \n response error loading Global Stats");
    }
  }

}