import 'dart:convert';
import 'dart:io';

import 'package:ethiocare/Controllers/phone_number_controller.dart';
import 'package:ethiocare/flutter_to_android.dart';
import 'package:ethiocare/languages/strings.dart';
import 'package:ethiocare/model/phone_numbers.dart';
import 'package:ethiocare/shared_preference/change_subscriber.dart';
import 'package:ethiocare/shared_preference/phone_numbers_shared_preference.dart';
import 'package:ethiocare/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_theme2.dart';

class PhoneNumbersScreen extends StatefulWidget {
  @override
  _PhoneNumbersScreenState createState() => _PhoneNumbersScreenState();
}

class _PhoneNumbersScreenState extends State<PhoneNumbersScreen> implements ChangeSubscriber {
  PhoneNumbersSharedPreference _phoneNumbersSharedPreference;
  Strings _strings;
  List<PhoneNumbers> _phoneNumbers = new List();
  PhoneNumberController phoneNumberController;

  @override
  void initState() {


    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));


    _strings = new Strings();
    _phoneNumbersSharedPreference = new PhoneNumbersSharedPreference();
    phoneNumberController = new PhoneNumberController(
        phoneNumbersSharedPreference: _phoneNumbersSharedPreference);
    _phoneNumbersSharedPreference.addSubs(this);
    loadPhoneNumbers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _title(),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  _please_call_one_of_this_numbers(),

                  Padding(
                    padding: EdgeInsets.only(left:20, right:20, top:20, bottom: 10),
                    child: Text(_strings.language.healthCenters,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        letterSpacing: 0.27,
                        color: Colors.grey[800],
                      ),),
                  ),
                  (_phoneNumbers==null|| _phoneNumbers.length==0) ? Loading.loading():
                  GridView.count(
                    padding: EdgeInsets.only(left:10, right:10),
                    scrollDirection: Axis.vertical,
                    physics: ClampingScrollPhysics(),
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    children: List.generate(_phoneNumbers.length, (index){
                      return _buildPhoneCard(_phoneNumbers[index]);
                    }),)

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildPhoneCard(PhoneNumbers ph){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),),
      elevation: 2,
//        margin: EdgeInsets.only(bottom:10),
      margin: EdgeInsets.only(top:20, left:10, right:10, bottom: (_phoneNumbers.contains(ph))?( _phoneNumbers.indexOf(ph) == _phoneNumbers.length-1)?30.0:10:10),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ((ph.region_name == null))?SizedBox(height: 0,):Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(ph.region_name, style: AppTheme2.NotBold,),
          ),
          ((ph.region_name == null))?SizedBox(height: 0,):Padding(
            padding: const EdgeInsets.all(3),
            child: Text(_strings.language.phone_number, style: AppTheme2.body2,),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(ph.phone_number, style: AppTheme2.headline,),
          ),

          OutlineButton.icon(
            icon: Icon(Icons.phone, color: (_phoneNumbers.contains(ph))?Colors.blue[900]:Colors.red[500],),
            color: Colors.blue[900],
            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
            label: Text(
                _strings.language.call,
                style: AppTheme2.Call,
              ),
            onPressed: (){
              FlutterToAndroid ftoA = new FlutterToAndroid();
              ftoA.call(ph.phone_number);
            },
          )

        ],
      ),
    );
  }

  @override
  void onDataChange() {
    loadPhoneNumbers();
  }

  void loadPhoneNumbers() async {
    print("loading phone numbers ...");
    List<PhoneNumbers> val = await _phoneNumbersSharedPreference
        .getPhoneNumberss();
    if (val == null || val.length == 0) {
      print("not saved in shared preference so loading from asset ...");
      String json = await DefaultAssetBundle.of(context).loadString("assets/json/phones${_strings.lang.toLowerCase()}.json");
      Map<String, dynamic> jsond = jsonDecode(json);
      var phonumbs = jsond["phone_numbers"];
      List<PhoneNumbers> phoneNumbers = (phonumbs as List).map((e)=> new PhoneNumbers.fromJson(e)).toList();
      _phoneNumbersSharedPreference.savePhoneNumbers(phoneNumbers);
      return;
    }
    if (mounted)
      setState(() {
        print("updating view...");
        _phoneNumbers = val;
      });
  }


  Widget _title() {
    return Container(
      padding: EdgeInsets.only(left: 50),
      child: SizedBox(
          height: AppBar().preferredSize.height,
          child: Row(
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: 1,
                        child: Text(
                          _strings.language.phone_numbers,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            color: AppTheme2.darkText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
//                InkWell(
//                  child: Padding(
//                    padding: const EdgeInsets.all(5.0),
//                    child: Icon(Icons.filter_list, size: 24.0, color: Colors.grey[800],),
//                  ),
//                  onTap: (){_filterPressed();},
//                ),
                SizedBox(width: 40,)

              ])),
    );
  }

  Widget _please_call_one_of_this_numbers() {
    PhoneNumbers ph1 = new PhoneNumbers(id: -100000, region_name: null,phone_number: "0920407025");
    PhoneNumbers ph2 = new PhoneNumbers(id: -100002, region_name: null,phone_number: "0925287357");
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left:20, right:20, top:20, bottom: 10),
          child: Text(_strings.language.callOneOfthisNumbersIfYouAreDiagnosed,
            textAlign:TextAlign.center, style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            letterSpacing: 0.27,
            color: Colors.grey[800],
          ),),
        ),
        Row(
          children: <Widget>[Expanded(child: _buildPhoneCard(ph1)), Expanded(child: _buildPhoneCard(ph2))],
        )
      ],
    );
  }
}