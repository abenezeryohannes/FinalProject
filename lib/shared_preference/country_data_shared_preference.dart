import 'dart:convert';
import 'package:ethiocare/model/country_data.dart';
import 'package:ethiocare/shared_preference/change_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountryDataSharedPreference extends ChangeObserver{
  
  final String key = "country_data";
  SharedPreferences prefs;

  CountryDataSharedPreference() {
    loadPreference();
  }

  void loadPreference() async{
       prefs = await SharedPreferences.getInstance();
  }

  void saveCountryData(CountryData countryData) async{
    getCountryDatas().then((onValue){

      //if nothing saved create list with only one country and save that list
      if(onValue == null){
        List<CountryData> newCountryDatas = new List();
        newCountryDatas.add(countryData);
        saveCountriesData(newCountryDatas);
      }else{  
        CountryData savedCountry = onValue.firstWhere((test){return test.title == countryData.title;});

      //if saved previous and country is not saved in the list;
      if(savedCountry == null){
        //save as new
        onValue.add(countryData);
        saveCountriesData(onValue);
      }else{
        //if saved previous and country is not same with new one
        if(savedCountry != countryData){
          onValue.remove((value){return value.title == countryData.title;});
          onValue.add(countryData);
          saveCountriesData(onValue);
        }
      }
      
      }

    });





    String json = jsonEncode(countryData);
    prefs.setString(key, json);
    onChange();
  }


  
  void saveCountriesData(List<CountryData> countryData) async{
    String json = jsonEncode(countryData);
    prefs.setString(key, json);
    onChange();
  }

  
  Future<List<CountryData>> getCountryDatas() async{
    if(prefs == null) {
      await loadPreference();
    }
    String jsonString = prefs.getString(key);
    if(jsonString == null) return new List();
    List<CountryData> countryDatas = new List();
    countryDatas = (json.decode(jsonString) as List).map (
          (i) => CountryData.fromJson(i)
      ).toList();
    return countryDatas;
  }

  

 

}