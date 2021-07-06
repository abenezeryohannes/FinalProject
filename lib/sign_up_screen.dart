import 'dart:io';

import 'package:ethiocare/flutter_to_android.dart';
import 'package:ethiocare/model/my_device.dart';
import 'package:ethiocare/model/setting.dart';
import 'package:ethiocare/navigation_home_screen.dart';
import 'package:ethiocare/shared_preference/change_subscriber.dart';
import 'package:ethiocare/shared_preference/my_device_shared_preference.dart';
import 'package:ethiocare/shared_preference/setting_shared_preference.dart';
import 'package:ethiocare/utils/constants.dart';
import 'package:ethiocare/widgets/loading.dart';
import 'package:ethiocare/Controllers/sign_up_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_theme2.dart';
import 'languages/strings.dart';



class SignUpScreen extends StatefulWidget{
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  SettingSharedPreference _settingSharedPreference;
  MyDeviceSharedPreference myDeviceSharedPreference;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  SignUpController _signUpController;
  Strings strings;
  MyDevice myDevice = new MyDevice();
  Widget _loadingResult ;
  bool checkboxValue = true;
  FlutterToAndroid flutterToAndroid = new FlutterToAndroid();


  double phone_number_anim = 0,
      full_name = 0,
      _loadingValue = 0;
  final _formKey = GlobalKey<FormState>();
  String response = null;

  @override
  void initState() {
    strings = new Strings();
    _loadingResult = Loading.loading(text: strings.language.loading);
    _settingSharedPreference = new SettingSharedPreference();
    myDeviceSharedPreference = new MyDeviceSharedPreference();
    //TODO: get device data and populate mydevice;
    _signUpController =
    new SignUpController(myDeviceSharedPreference: myDeviceSharedPreference);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                _title(strings.language.sign_up_screen_title),
                _body(strings.language.sign_up_screen_description),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _fullName(strings.language.sign_up_screen_full_name,
                              strings.language.sign_up_phone_not_valid,
                              _nameController),
                          _phoneNumber(strings.language.sign_up_phone_number,
                              strings.language.sign_up_phone_name_required,
                              _phoneController),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _privacyStatment(strings.language.privacy_policy, "privacy_policy"),
                        _privacyStatment(strings.language.terms_of_use, "terms_of_use")
                      ],
                    ),
                    _checkPrivacyRead(),


                    AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: _loadingValue,
                        child: _loadingResult)
                  ],
                ),

              ],
            ),
          ),

          Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(right: 20, bottom: 20),
                      child: _button(strings.language.sign_up_next)
                  ),
                ],
              )
          )
        ],
      ),
    );
  }

  Widget _title(String text) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20, bottom: 20),
        child: Text(text,
            style: TextStyle(
              fontFamily: AppTheme2.fontName,
              fontWeight: FontWeight.bold,
              fontSize: 40,
              letterSpacing: -1,
              color: Colors.grey[800],
            )
        )
    );
  }


  Widget _body(String text) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
        child: Text(text,
          style: AppTheme2.body1,
        )
    );
  }

  Widget _button(String text) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  text,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                      fontFamily: AppTheme2.fontName,
                      fontWeight: FontWeight.w500),
                ),
                Icon(Icons.navigate_next, size: 24.0, color: Colors.grey[600],),
              ],
            ),
          ],
        ),
      ),
      onTap: () async {
        if (_formKey.currentState.validate() && checkboxValue) {
          // If the form is valid, display a snackbar. In the real world,
          // you'd often call a server or save the information in a database.
          if(mounted) setState(() {
            _loadingValue = 1;
            _loadingResult = Loading.loading();});
          //on succesffull device and network connection
          MyDevice md = new MyDevice();
          md.phone_number_user = _phoneController.text;
          md.full_name = _nameController.text;

          bool bluetoothTurned = await flutterToAndroid
              .turnBluetoothOnInPlatform();
          print("is bluetooth on " + bluetoothTurned.toString());
          int response = await _signUpController.sendDevice(myDevice);

//          saveAndContinue();

          if (bluetoothTurned) {
            MyDevice md = await flutterToAndroid.getDeviceDataFromAndroid();
            if (md == null)
              {
                print("i get null device info from android");
                _loadingResult = Loading.loading(text:"Please turn bluetooth on and try again!");
              }
            else {
//              Scaffold.of(context).showSnackBar(SnackBar(content:Text("myDevice is ${md.toString()}")));
              md.phone_number_user = _phoneController.text;
              md.full_name = _nameController.text;
              myDevice = md;
              print("device i recieved is : " + myDevice.toString());
              if (mounted) setState(() {
                _loadingResult = Loading.loading();
              });
              int response = await _signUpController.sendDevice(myDevice);

              if (response == -2) {
                print("server error responded");
                if (mounted)
                  setState(() {
                    _loadingResult = Loading.loadingError(
                        text: strings.language.connection_error);
                  });

              }else if (response == -1){
                print("response is -1");
                if (mounted)
                  setState(() {
                    _loadingResult = Loading.loadingError(
                        text: strings.language.signuperrorfromserver);
                  });

              }else {

                saveAndContinue();

              }
            }
          }else setState(() { _loadingResult = Loading.loadingError(text: strings.language.needbluetoothtocontinue);});


        }
      },
    );
  }

  Widget _phoneNumber(String hint, String validation,
      TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 20.0, bottom: 10.0, left: 20, right: 30),
      child: TextFormField(
        controller: controller,
        decoration: new InputDecoration(
          labelText: hint,
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: new BorderSide(
            ),
          ), //fillColor: Colors.green
        ),
        validator: (val) {
          if (val.length == 0 || val.length < 8) {
            return validation;
          }
          else if (!(val.startsWith("09") || val.startsWith("251") ||
              val.startsWith("+251"))) {
            return validation;
          }
          else
          if (val.startsWith("09") && (val.length < 10 || val.length > 10)) {
            return validation;
          } else
          if (val.startsWith("251") && (val.length < 12 || val.length > 12)) {
            return validation;
          } else
          if (val.startsWith("+251") && (val.length < 13 || val.length > 13)) {
            return validation;
          }
          else {
            return null;
          }
        },
        keyboardType: TextInputType.phone,
        style: new TextStyle(
          fontFamily: "Poppins",
        ),
      ),
    );
  }

  Widget _fullName(String hint, String validation,
      TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 20.0, bottom: 20.0, left: 20, right: 30),
      child: TextFormField(
        controller: controller,
        decoration: new InputDecoration(
          labelText: hint,
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: new BorderSide(
            ),
          ), //fillColor: Colors.green
        ),
        validator: (val) {
          if (val.length == 0) {
            return validation;
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.text,
        style: new TextStyle(
          fontFamily: "Poppins",
        ),
      ),
    );
  }


  void saveAndContinue() async {
    SettingSharedPreference settingSharedPreference = new SettingSharedPreference();
    Setting s = await settingSharedPreference.getSetting();
    s.signup = 1;
    settingSharedPreference.saveSetting(s);
    flutterToAndroid.saveDeviceDataToAndroid(myDevice);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => NavigationHomeScreen()));
  }




  Widget _checkPrivacyRead() {
    return
    CheckboxListTile(
              value: checkboxValue,
              onChanged: (val) {
                if (checkboxValue == false) {
                  setState(() {
                    checkboxValue = true;
                  });
                } else if (checkboxValue == true) {
                  setState(() {
                    checkboxValue = false;
                  });
                }
              },
              subtitle: !checkboxValue
                  ? Text(
                'Required.',
                style: TextStyle(color: Colors.red),
              )
                  : null,
              title: new Text(
                strings.language.doyouagree,
                style: TextStyle(fontSize: 14.0),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Colors.blue[900],
            );
  }

 Widget _privacyStatment(String text, String url) {
    return
        Padding(
          padding: const EdgeInsets.only(right:20.0, bottom: 20),
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.only(top:10.0,bottom: 10.0, right:10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:5.0,right:5.0),
                    child: Icon(Icons.launch, color: Colors.grey[600], size: 14.0,),
                  ),
                  Text(
                    text,
                    style: AppTheme2.body2,
                  ),
                ],
              ),
            ),
            onTap: (){
              launch(Constants.termsBaseUrl + url);
            },
          ),
        );
 }


}