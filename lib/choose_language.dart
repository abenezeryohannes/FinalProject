import 'package:ethiocare/flutter_to_android.dart';
import 'package:ethiocare/model/setting.dart';
import 'package:ethiocare/shared_preference/setting_shared_preference.dart';
import 'package:ethiocare/sign_up_screen.dart';
import 'package:ethiocare/walkthrough.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_theme2.dart';



class ChooseLanguage extends StatefulWidget {
  @override
  _ChooseLanguageState createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {

  BuildContext _buildContext;
  @override
  void initState() {
   amh = _buildButton(backColor: Colors.grey[100], textColor: Colors.grey[800], text: "Amharic",whatToDoWhenPressed: amharicPressed);
   eng = _buildButton(backColor: Colors.grey[100], textColor: Colors.grey[800], text: "English",whatToDoWhenPressed: englishPressed);
   next = nextState(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(

          children: <Widget>[

          Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height:MediaQuery.of(context).size.height / 4),
                Row(
                  children: <Widget> [ Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left:30, bottom:30),
                      child: _title("Choose Language"),
                    ),
                  ),
        ]
                ),

 Row(
   mainAxisAlignment:MainAxisAlignment.center,
   mainAxisSize: MainAxisSize.max,

   children: <Widget>[
         Expanded(
           child: Container(

             margin: EdgeInsets.only(left:MediaQuery.of(context).size.width/4, right:MediaQuery.of(context).size.width/4, top:10, bottom:20),
             child: eng,
           ),
         )
     ,
   ],
 ),

 Row(
   children: <Widget>[
         Expanded(
           child: Container(
             margin: EdgeInsets.only(left:MediaQuery.of(context).size.width/4, right:MediaQuery.of(context).size.width/4, top:10),
             child: amh
           ),
         ),
   ],
 )
            ],
          )),
          Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: EdgeInsets.only( right:30, bottom:20),
                  child: next
              ),
            )
          ],
        ),
    );
  }

  Widget _title(String title){
    return  Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20 , bottom: 20),
        child:Text( title,
            style: TextStyle(
              fontFamily: AppTheme2.fontName,
              fontWeight: FontWeight.w500,
              fontSize: 30,
              letterSpacing: 0.27,
              color: Colors.grey[800],
            )
        )
    );
  }

  String language;
  Widget next;
  Widget amh;
  Widget eng;

  SettingSharedPreference _settingSharedPreference = new SettingSharedPreference();
  void nextPressed(){


    _settingSharedPreference.getSetting().then((onValue) async{
      if(onValue==null){
        Setting setting = new Setting(language: language);
        _settingSharedPreference.saveSetting(setting);
        print("walkthrough"+setting.walkthrough.toString());
        bool supported = await new FlutterToAndroid().checkIfDeviceSupported();
        if(!supported){
          setting.walkthrough = 1;
          _settingSharedPreference.saveSetting(setting);
          Navigator.pushReplacement(_buildContext, MaterialPageRoute(builder:(context) => SignUpScreen()));
        }else
        Navigator.pushReplacement(_buildContext, MaterialPageRoute(builder:(context) => Walkthrough()));
      }else{
          onValue.language = language;
          _settingSharedPreference.saveSetting(onValue);
          if(onValue.walkthrough == null){
            print("walkthrough");

            bool supported = await new FlutterToAndroid().checkIfDeviceSupported();
            if(!supported){
              onValue.walkthrough = 1;
              _settingSharedPreference.saveSetting(onValue);
              Navigator.pushReplacement(_buildContext, MaterialPageRoute(builder:(context) => SignUpScreen()));
            }else
              Navigator.pushReplacement(_buildContext, MaterialPageRoute(builder:(context) => Walkthrough()));
          }else if(onValue.signup == null){
            print("signup");
            Navigator.pushReplacement(_buildContext, MaterialPageRoute(builder:(context) => SignUpScreen()));
          }else{
            if(Navigator.canPop(_buildContext))
            Navigator.pop(_buildContext);
          }
      }
    });

  }


  void amharicPressed(){
    language = "AM";
    setState(() {
      amh = _buildButton(backColor: Colors.blue[600], textColor: Colors.white, text: "Amharic",whatToDoWhenPressed: amharicPressed);
      eng = _buildButton(backColor: Colors.grey[100], textColor: Colors.grey[800], text: "English",whatToDoWhenPressed: englishPressed);
      next = nextState(true);
    }); }
  void englishPressed(){
    language = "EN";
    setState(() {
      eng = _buildButton(backColor: Colors.blue[600], textColor: Colors.white, text: "English",whatToDoWhenPressed: englishPressed);
      amh = _buildButton(backColor: Colors.grey[100], textColor: Colors.grey[800], text: "Amharic",whatToDoWhenPressed: amharicPressed);
      next = nextState(true);
    });
    
  }

  Widget nextState(bool enabled){
    return  InkWell(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  "Next",
                  style: TextStyle(
                      fontSize: 20,
                      color: enabled?Colors.black:Colors.grey[600],
                      fontFamily: AppTheme2.fontName,
                      fontWeight: FontWeight.w500),
                ),
                Icon(Icons.navigate_next, size: 24.0, color: Colors.grey[600],),
              ],
            ),
          ],
        ),
      ),
      onTap: (){ if(enabled) nextPressed();       }
    );
  }


  Widget _buildButton({ Color backColor, textColor, String text, Function whatToDoWhenPressed }){
   return  RaisedButton(
               shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
              padding: EdgeInsets.only(top: 10, bottom: 10),
              color: backColor,
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 20,
                    color: textColor,
                    fontFamily: AppTheme2.fontName,
                    fontWeight: FontWeight.w400),
              ),
              onPressed: () {
                whatToDoWhenPressed();
              }
   );
  }





}