

import 'dart:convert';

import 'package:ethiocare/model/phone_numbers.dart';
import 'package:ethiocare/shared_preference/phone_numbers_shared_preference.dart';
import 'package:ethiocare/utils/constants.dart';
import 'package:ethiocare/utils/http_retry.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


class PhoneNumberController{
    final PhoneNumbersSharedPreference phoneNumbersSharedPreference;


    PhoneNumberController({@required this.phoneNumbersSharedPreference});

    void  getPhoneNumbers() async{
      String url = Constants.releaseBaseUrl + "phone_numbers";
      http.Response response = await new HttpRetry().get(url);
      if(response!=null && response.statusCode == 200){
        print("get " + url + "response success \n "+jsonDecode(response.body).toString());

        Map<String, dynamic> json = jsonDecode(response.body);
        var phonumbs = json["phone_numbers"];

        List<PhoneNumbers> phoneNumbers = (phonumbs as List).map((e)=> new PhoneNumbers.fromJson(e)).toList();
        phoneNumbersSharedPreference.savePhoneNumbers(phoneNumbers);

      }else{
        print( "get " + url + "response error \n response error loading phone numbers request after retry");
      }
    }
}