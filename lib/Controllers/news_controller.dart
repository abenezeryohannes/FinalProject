import 'dart:convert';
import 'package:ethiocare/model/country_data.dart';
import 'package:ethiocare/model/global_data.dart';
import 'package:ethiocare/model/globalapi.dart';
import 'package:ethiocare/model/news.dart';
import 'package:ethiocare/shared_preference/country_data_shared_preference.dart';
import 'package:ethiocare/shared_preference/news_shared_preference.dart';
import 'package:ethiocare/utils/constants.dart';
import 'package:ethiocare/utils/http_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ethiocare/shared_preference/change_observer.dart';

class NewsController extends ChangeObserver{


  NewsSharedPreference newsSharedPreference;
  final Function onLoadingError;
  final Function onSuccess;
  final Function onFailure;
  final Function onloadingSuccess;
  NewsController({this.newsSharedPreference,this.onloadingSuccess, @required this.onLoadingError,this.onFailure, this.onSuccess});



  void getNewsAfter() async{
    String url = Constants.releaseBaseUrl + "getdata/news";
    int lastNewsId = 0;
    newsSharedPreference.getNewses().then((newses) async{
      if(newses != null && newses.length > 0){
        newses.sort((a,b){return a.id.compareTo(b.id)*-1;});
        lastNewsId = newses.first.id;
      }
      print("getting news after: "+ lastNewsId.toString());
      http.Response response = await new HttpRetry().post(url//);
      , body: {"after": lastNewsId.toString()});

      if(response!=null && response.statusCode == 200){
        print("post " + url + "response success \n "+jsonDecode(response.body).toString());

        // GlobalData globalData = GlobalData.fromJson(jsonDecode(response.body));
        List<News> newsData = GlobalApi.getNewsData(response);

        if(newsData == null || newsData.length == 0){
          onloadingSuccess();
          return;
        }
        else if(newsData.length<20 || (newsData.length==20 && newsData.first.id == lastNewsId+1)){
          print("before save" + newsData.toString());
          newses.addAll(newsData);
          newses.sort((a,b){return a.id.compareTo(b.id)*-1;});
          newsSharedPreference.saveNewses(newses);
        }else{
          print("before save" + newsData.toString());
          newsSharedPreference.removeNewses();
          newsSharedPreference.saveNewses(newsData);
        }

        List<News> fuckDart = await newsSharedPreference.getNewses();
        print("after save" + fuckDart.toString());
        onloadingSuccess();
      }else{
        onLoadingError();
        print( "post " + url + "response error \n response error loading News");
      }
    });
  }


  void getBeforeNewsOf({String filterBy = "", int newsId}) async{

    print("getNews filer by :  "+ filterBy);

//    String url = Constants.releaseBaseUrl + "getnews/";
    String url = Constants.releaseBaseUrl + "getdata/news";

    newsSharedPreference.getNewses().then((newses) async{
      print("getting news before: "+ newsId.toString());
      http.Response response = await new HttpRetry().post(url//);
      , body: {"before": newsId.toString()}).catchError((onError){});

      if(response!=null && response.statusCode == 200){
        print("get " + url + "response success \n "+jsonDecode(response.body).toString());
        List<News> newsData = GlobalApi.getNewsData(response);
        List<News> newses = await newsSharedPreference.getNewses();
        newses.addAll(newsData);
        newsSharedPreference.saveNewses(newses);
        print("all before news $newses");
        if(newses == null || newses.length == 0)
        onSuccess(false);else onSuccess(true);
      }else{
        onFailure();
        print( "post " + url + "response error \n response error loading News");
      }
    });
  }





  void getCountries(CountryDataSharedPreference countryPref ) async{
   
    String url = Constants.releaseBaseUrl + "getdata/countries";
    http.Response response = await http.get(url).catchError((onError){
      //ignore
    });
    if(response!=null && response.statusCode == 200){
      print("get " + url + "response success \n "+jsonDecode(response.body).toString());

      // GlobalData globalData = GlobalData.fromJson(jsonDecode(response.body));
      List<CountryData> countriesData = GlobalApi.getCountries(response);

      countryPref.getCountryDatas().then((onValue){
        if(onValue != countriesData)
          countryPref.saveCountriesData(countriesData);
      });
      onSuccess();
    }else{
      onFailure();
      print( "get " + url + "response error \n response error loading Global Stats");
    }
  }


}