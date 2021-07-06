
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:ethiocare/flutter_to_android.dart';
import 'package:ethiocare/help_screen.dart';
import 'package:ethiocare/languages/strings.dart';
import 'package:ethiocare/model/my_device.dart';
import 'package:ethiocare/tracker/TrackAnim.dart';
import 'package:ethiocare/tracker/trait_tracker.dart';
import 'package:ethiocare/widgets/loading.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme2.dart';
import 'model/suspect.dart';
class TrackerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return TrackerPage();
  }
}


class TrackerPage extends StatefulWidget {
  @override
  _TrackerPageState createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
 
  Widget trackingAnimation;
  BuildContext context;
  TraitTracker traitTracker;
  Strings strings;

  Widget _title;
  Widget _bottom;
  bool isSupported = true;
  // Stream _suspectStream; 

  @override
  initState() {
    checkIfSupported();
    strings = new Strings();
      traitTracker = new TraitTracker(
          connectionChange: connectionChange,
          onTraitFound: onSuspectResponse,
          onBluetoothChange: BluetoothOnOff,
          strings: strings
      );

    // _suspectStream = traitTracker.stream;
    
    prepareTrackerAnimation(TrackAnim.connected, strings.language.title_tracking, strings.language.tracker_page_description);
   super.initState();
  }

  void checkIfSupported() async{

  FlutterToAndroid fta = new FlutterToAndroid();
  bool support = await fta.checkIfDeviceSupported();
  if(mounted)
    setState(() {
      isSupported = support;
    });
}

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return  Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            alignment: Alignment.center,
            child: Column(

              children: <Widget>[
              _title,
                (isSupported)?
                Expanded(
                                  child: Column(
                  
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                  
                    SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width,
                            child: trackingAnimation),
                   
                      _bottom
                  
                    ]),
                ):

                    Loading.loadingError(text: strings.language.notSupported)

              ],
            ));
  }

  void BluetoothOnOff(bool isOn){
    if(!isOn){
      prepareTrackerAnimation(TrackAnim.bluetooth_off, strings.language.waiting_for_bluetooth_to_turn_on,
          strings.language.waiting_for_bluetooth_to_turn_on_desc);
    }
  }

  void prepareTitle(TrackAnim anim, String title, String message){
    _title = Padding(
      padding: EdgeInsets.only(left:50, top:4),
                child: SizedBox(
        height: AppBar().preferredSize.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
               Expanded(
                
                                child: Text(
                     title, 
                     textAlign: TextAlign.center,
                      style: AppTheme2.myTitles,
                   ),
               ),
                InkWell(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(Icons.help_outline, size: 24.0, color: Colors.black,),
                ),
                onTap: () async{
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return HelpScreen();}));

//                  FlutterToAndroid fta = new FlutterToAndroid();
//                  MyDevice device = await fta.getDeviceDataFromAndroid();
//                  print("myDevice is ${device.toString()}");
//                  Scaffold.of(context).showSnackBar(SnackBar(content:Text("myDevice is ${device.toString()}")));
                },
                ),
                SizedBox(width: 20)

            ])),
    );

  }


  void connectionChange(bool isConnected){
    if(isConnected){
      prepareTrackerAnimation(TrackAnim.connected, strings.language.title_tracking, strings.language.tracker_page_description);


    }else{
      prepareTrackerAnimation(
          TrackAnim.not_connected,
          strings.language.tracker_page_error_title,
          strings.language.tracker_page_error_description);
    }
  }


  void onSuspectResponse(TrackAnim animation, String title, String desc){
    prepareTrackerAnimation(animation, title, desc);
    print("Updated View");
  }


  void prepareBottomView(TrackAnim anim, String top, String bottom){
    _bottom = ListView(
      padding: EdgeInsets.only(top:20, left:20,right:20,  bottom: 10),
      shrinkWrap: true,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom:10),
                  child: Text(
                   top, 
                   textAlign: TextAlign.center,
                    style: AppTheme2.headline,
                  )
        ),
               Text(
                 bottom, 
                   textAlign: TextAlign.center,
                  style: AppTheme2.body1
               )

    ],);
  }


  void prepareTrackerAnimation(TrackAnim trackAnim, String title, String message){
    String filePath = "assets/animations/";
    String animationName;
    if(!mounted) return;
      prepareTitle(trackAnim, title, message);
      prepareBottomView(trackAnim, title, message);
    switch(trackAnim){
      case TrackAnim.not_connected:
        filePath+="tracker_noconnection.flr";
        animationName = "Record2";
        break;
      case TrackAnim.connected:
        animationName = "Record2";
        filePath+="tracker_animation.flr";
        break;
      case TrackAnim.green_zone:
        animationName = "Record2";
        filePath+="tracker_unknown2.flr";
        break;
      case TrackAnim.yellow_zone:
        animationName = "record";
        filePath+="tracker_warning.flr";
        break;
      case TrackAnim.red_zone:
        animationName = "record";
        filePath+="tracker_danger.flr";
        break;
      case TrackAnim.danger_zone:
        filePath+="danger.gif";
        break;
      case TrackAnim.bluetooth_off:
        filePath+="tracker_noconnection.flr";
        break;
    }
    setState(() {
      print("tracker animation state changed "+filePath);
      if(trackAnim == TrackAnim.danger_zone) {
      trackingAnimation = Image.asset(
                              filePath, 
                              alignment:Alignment.center,
                              width: MediaQuery.of(this.context).size.width,
                              height: MediaQuery.of(this.context).size.width      
                              );
      }else
      trackingAnimation = FlareActor(filePath, 
                    alignment:Alignment.center, 
                    isPaused: false,
                    fit:BoxFit.contain,
                    animation:animationName);
    });
  }

  // Be sure to cancel subscription after you are done
  @override
  dispose() {
    super.dispose();

    traitTracker.onDisponse();
  }


}


