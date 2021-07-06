import 'package:ethiocare/languages/english.dart';
import 'package:ethiocare/languages/language.dart';
import 'package:ethiocare/languages/amharic.dart';
import 'package:ethiocare/shared_preference/setting_shared_preference.dart';


class Strings {
  Language language = new English();
  SettingSharedPreference languageSharedPreference = new SettingSharedPreference();
  String lang = "EN";
  List<String> countrySortBy;

  Strings() {
    languageSharedPreference.getSetting().then((onValue){
      if(onValue !=null && onValue.language!=null && onValue.language.startsWith("AM")){
        lang = "AM";
        language = new Amharic();
        print("language is "+onValue.language);
      }
      prepareCountrySort();
    });
    prepareCountrySort();
  }

  void prepareCountrySort(){
 countrySortBy = [
    language.statistics_page_sort_by_name,
    language.statistics_page_total_cases,
    language.statistics_page_active_cases,
    language.statistics_page_serious_cases,
    language.statistics_page_deaths,
    language.statistics_page_recovered,
    language.statistics_page_total_new_cases,
    language.statistics_page_total_deaths,
    language.statistics_page_total_unresolved,
  ];
  }






}