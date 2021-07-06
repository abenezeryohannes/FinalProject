import 'dart:async';
import 'dart:io';

import 'package:ethiocare/app_theme.dart';
import 'package:ethiocare/model/setting.dart';
import 'package:ethiocare/shared_preference/setting_shared_preference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:share/share.dart';

import 'app_theme2.dart';
import 'flutter_to_android.dart';
import 'languages/strings.dart';
class InviteFriend extends StatefulWidget {
  @override
  _InviteFriendState createState() => _InviteFriendState();
}

class _InviteFriendState extends State<InviteFriend> {
  Strings strings = new Strings();
  bool showAd = true;
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    padding: EdgeInsets.only(
                        top: 100,
                        left: 16,
                        right: 16),
                    child: Image.asset('assets/images/inviteImage.png'),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      strings.language.invite_friends_title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left:20, right:20,top: 16),
                    child:  Text(
                      strings.language.invite_friends_description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue[900],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.6),
                                  offset: const Offset(4, 4),
                                  blurRadius: 8.0),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                FlutterToAndroid fta = new FlutterToAndroid();
                                fta.tellFriendsOnPlatform();
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.share,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        strings.language.invite_friends_botton_text,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),


              (showAd)?
              Align(
                alignment: Alignment.bottomCenter,
                child: FutureBuilder(
                  future: Future.delayed(Duration(seconds: 4), ()
                  {
                    return Future.value(1);
                  }),
                  initialData: 0,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if(snapshot.data == 1)
                      return _showAd();
                    else
                      return SizedBox(height: 0,);
                  },),
              ):SizedBox(height:0)

            ],
          ),
        ),
      ),
    );
  }


  Widget _showAd(){
        return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
            margin: EdgeInsets.only(bottom: 10),
            color: Colors.grey[100],
            child: InkWell(
              child: Container(
                height: 100,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left:8.0, right:8.0, top:5, bottom:5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 70,
                            height: 70,
                            margin: EdgeInsets.only(left:20, right:20, top:10, bottom:10),
                            decoration: BoxDecoration(
                              image: DecorationImage(image:AssetImage("assets/images/shimmer.png" ), fit: BoxFit.cover),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: AppTheme2.grey.withOpacity(0.2),
                                    offset: Offset(1.1, 1.1),
                                    blurRadius: 10.0),
                              ],),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text("Shimmer", style: AppTheme2.title, textAlign: TextAlign.start,),
                              Text("First Ethiopian and Eritrian Dating App", style: AppTheme2.subtitle, textAlign: TextAlign.start,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  OutlineButton.icon(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                      padding: EdgeInsets.only(right:15, left:10),
                                      onPressed: () async{
                                        SettingSharedPreference ssp = new SettingSharedPreference();Setting s =await ssp.getSetting();s.ad = 1;ssp.saveSetting(s);
                                        launch("https://t.me/shimmerdatingapp");
                                        if(mounted)
                                          setState(() {
                                          showAd =false;
                                        });
                                      }, icon: FaIcon(FontAwesomeIcons.telegram, color: Colors.blue[500], size: 20.0,), label: Text("Join channel", style:AppTheme2.title)),

                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.grey[800],),
                        onPressed: ()async{SettingSharedPreference ssp = new SettingSharedPreference();Setting s =await ssp.getSetting();s.ad = 1;ssp.saveSetting(s);
                        if(mounted)
                          setState(() {
                          showAd = false;
                        });
                        },
                      ),
                    )
                  ],
                ),
              ),
              onTap: () async{
                SettingSharedPreference ssp = new SettingSharedPreference();
                Setting s =await ssp.getSetting();
                s.ad = 1;
                ssp.saveSetting(s);
                launch("https://t.me/shimmerdatingapp");
                if(mounted)
                setState(() {
                  showAd = false;
                });
              },
            ),
          );
  }
  Future<bool> _shouldShowAd() async{
    SettingSharedPreference ssp = new SettingSharedPreference();
    Setting s =await ssp.getSetting();
    if(s.ad == 1) Future.value(false);
    else Future.value(true);
  }
}
