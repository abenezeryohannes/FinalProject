import 'dart:convert';
import 'package:ethiocare/model/country_data.dart';
import 'package:ethiocare/model/global_data.dart';
import 'package:ethiocare/model/globalapi.dart';
import 'package:ethiocare/shared_preference/country_data_shared_preference.dart';
import 'package:ethiocare/shared_preference/global_data_shared_preference.dart';
import 'package:ethiocare/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:ethiocare/Utils/http_retry.dart';
import 'package:ethiocare/shared_preference/change_observer.dart';

class StatisticsController extends ChangeObserver{

  Function success;
  Function failure;
  GlobalDataSharedPreference globalPref = new GlobalDataSharedPreference();
  CountryDataSharedPreference countryPref = new CountryDataSharedPreference();
  StatisticsController({this.globalPref, this.countryPref, this.success, this.failure});
  

  void getGlobalStats() async{
    String url = Constants.releaseBaseUrl + "getdata/global";
    http.Response response = await new HttpRetry().get(url).catchError((onError){
      //ignore
    });
    if(response!=null && response.statusCode == 200){
      print("get " + url + "response success \n "+jsonDecode(response.body).toString());
      
      // GlobalData globalData = GlobalData.fromJson(jsonDecode(response.body));
      GlobalData globalData = GlobalApi.getGlobalData(response);

      globalPref.getGlobalData().then((onValue){
      if(globalData != onValue)
          globalPref.saveGlobalData(globalData);
      });
      success();
    }else{
      failure();
      print( "get " + url + "response error \n response error loading Global Stats");
    }
  }



  void getCountriesStats() async{
    String url = Constants.releaseBaseUrl + "getdata/countries";
    http.Response response = await new HttpRetry().get(url);
    if(response!=null && response.statusCode == 200){
      print("get " + url + "response success \n "+jsonDecode(response.body).toString());
      
      // GlobalData globalData = GlobalData.fromJson(jsonDecode(response.body));
      List<CountryData> countriesData = GlobalApi.getCountries(response);

      countryPref.getCountryDatas().then((onValue){
      if(onValue != countriesData)
          countryPref.saveCountriesData(countriesData);
      });
    }else{
      failure();
      print( "get " + url + "response error \n response error loading Global Stats");
    }
  }



  void getCountryStats(CountryData countryData) async{
    String url = "https://thevirustracker.com/free-api?global=stats";
    http.Response response = await http.get(url).catchError((onError){
      //ignore
    });
    if(response!=null && response.statusCode == 200){
      print("get " + url + "response success \n "+jsonDecode(response.body).toString());
      
      // GlobalData globalData = GlobalData.fromJson(jsonDecode(response.body));
      CountryData countryData = GlobalApi.getCountry(response);
    countryPref.saveCountryData(countryData);
    }else{
      print( "get " + url + "response error \n response error loading Global Stats");
    }
  }


  void postJson() async{
    String url = "postTester";
    http.Response response = await new HttpRetry().post(url, body:{"macAddress":"dum", "phoneNumber":"dum"});
    
    if(response != null && response.statusCode == 200){
      print("post " + url + " response success \n "+jsonDecode(response.body).toString());
      // User user = User.fromJson(jsonDecode(response.body));
      // userSharedPreference.saveUser(user);
      onChange();
    }else{
      print("post " + url + "response error \n response error loading post request after retry");
    }
  }

 
}