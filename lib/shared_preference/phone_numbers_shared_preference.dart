import 'dart:convert';
import 'package:ethiocare/model/phone_numbers.dart';
import 'package:ethiocare/shared_preference/change_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneNumbersSharedPreference extends ChangeObserver{

  final String key = "phone_numbers";
  SharedPreferences prefs;

  PhoneNumbersSharedPreference() {
    loadPreference();
  }

  void loadPreference() async{
    prefs = await SharedPreferences.getInstance();
  }

  void savePhoneNumber(PhoneNumbers phoneNumber) async{
    getPhoneNumberss().then((onValue){

      //if nothing saved create list with only one country and save that list
      if(onValue == null){
        List<PhoneNumbers> newPhoneNumberss = new List();
        newPhoneNumberss.add(phoneNumber);
        savePhoneNumbers(newPhoneNumberss);
      }else{
        PhoneNumbers savedCountry = onValue.firstWhere((test){return test.region_name == phoneNumber.region_name &&  test.phone_number == phoneNumber.phone_number;});

        //if saved previous and country is not saved in the list;
        if(savedCountry == null){
          //save as new
          onValue.add(phoneNumber);
          savePhoneNumbers(onValue);
        }else{ //if saved previous and country is not same with new one
          if(savedCountry != phoneNumber){
            onValue.remove((value){return value.title == phoneNumber.phone_number;});
            onValue.add(phoneNumber);
            savePhoneNumbers(onValue);
          }
        }
      }
    });

    String json = jsonEncode(phoneNumber);
    prefs.setString(key, json);
    onChange();
  }



  void savePhoneNumbers(List<PhoneNumbers> countryData) async{
    String json = jsonEncode(countryData);
    prefs.setString(key, json);
    onChange();
  }


  Future<List<PhoneNumbers>> getPhoneNumberss() async{
    if(prefs == null) {
      await loadPreference();
    }
    String jsonString = prefs.getString(key);
    if(jsonString == null) return new List();
    List<PhoneNumbers> phoneNumbers = new List();
    phoneNumbers = (json.decode(jsonString) as List).map (
            (i) => PhoneNumbers.fromJson(i)
    ).toList();
    return phoneNumbers;
  }





}