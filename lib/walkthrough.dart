import 'package:ethiocare/navigation_home_screen.dart';
import 'package:ethiocare/shared_preference/setting_shared_preference.dart';
import 'package:ethiocare/sign_up_screen.dart';
import 'package:ethiocare/walkthroughs/info_walk.dart';
import 'package:ethiocare/walkthroughs/walks.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ethiocare/walkthroughs/assset_type.dart';
import 'package:ethiocare/flutter_to_android.dart';

import 'app_theme2.dart';
import 'languages/strings.dart';

class Walkthrough extends StatefulWidget {
  @override
  _WalkthroughState createState() => _WalkthroughState();
}

class _WalkthroughState extends State<Walkthrough> {
  Strings string = new Strings();
  double isBack = 0;

  List<String> walkTitles = new List();
  List<String> walkDesc = new List();
  List<AssetType> walkAssetType= new List();
  List<String> walkAssets = new List();

  final controller = PageController(initialPage: 0);

  InfoWalks infoWalks;

  void prepareWalks() {
    string = new Strings();
    print(string.language.walkthrough_titles.toString());
    walkTitles = string.language.walkthrough_titles;
    walkDesc = string.language.walkthrough_descriptions;
    walkAssets = ["walkthrough_togethor.png", "bluetooth_walkthrough.flr",
      "walkthrough_notification.png",  "call_us.png",  "walkthrough_dont_send_setting.png", "disclaimer.png"];
    walkAssetType = [AssetType.image, AssetType.flare, AssetType.image, AssetType.image, AssetType.image, AssetType.image];
    _totalDots = walkTitles.length;
  }

  int _totalDots;
  int _currentPosition = 0;
  int _validPosition(int position) {
    if (position >= _totalDots) return 0;
    if (position < 0) return _totalDots - 1;
    return position;
  }


  @override
  void initState() {
    prepareWalks();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    infoWalks = InfoWalks(strings: string, walkTitles: walkTitles,walkDesc: walkDesc,assetTypes: walkAssetType,assets: walkAssets, context: context);
    return  Scaffold(
            backgroundColor: Colors.white,
              body: Stack(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(bottom: 120, left:20, right:20),
              child: PageView.builder(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  itemCount: walkTitles.length,
                  onPageChanged: (index) {
                    onPageChange(index);
                  },
                  itemBuilder: (context, index) {
                    return _buildPageViews(index);
                  })),


           Align(
            alignment: Alignment.bottomCenter,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(bottom:100),
                        child: DotsIndicator(
                        dotsCount: walkTitles.length,
                        position: double.parse(_validPosition(_currentPosition).toString()),
                        decorator: DotsDecorator(
                          color: Colors.grey[100],
                          activeColor: Colors.blueAccent,
                        ),
                    ),
                      ),
           ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(bottom:10),
              padding: EdgeInsets.only(left:10, right:10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      opacity: isBack,
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(Icons.navigate_before, size: 24.0, color: Colors.grey[600],),
                                  Text(
                                    "Back",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.grey[600],
                                        fontFamily: AppTheme2.fontName,
                                        fontWeight: FontWeight.w500),
                                  ),
                                 ],
                              ),

                            ],
                          ),
                        ),
                        onTap: (){onBackPressed();},
                      ),
                    ),

                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "Next",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey[600],
                                      fontFamily: AppTheme2.fontName,
                                      fontWeight: FontWeight.w500),
                                ),
                                Icon(Icons.navigate_next, size: 24.0, color: Colors.grey[600],)
                              ],
                            ),
                          ],
                        ),
                      ),
                      onTap: (){onNextPressed();},
                    ),
                  ],
                ),
            ),
          )
        ],
    ));
  }


  Widget _buildPageViews(int index) {
    return infoWalks.info(index);
  }


  void onPageChange(int index) async {
    if(index == 0) isBack = 0;else isBack = 1;
    if(index == 2){
      FlutterToAndroid fta = new FlutterToAndroid();
      bool response = await fta.turnBluetoothOnInPlatform();

      if(!response) {
        controller.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        return;
      }
    }
    setState(() => _currentPosition = _validPosition(index));
  }


  void onBackPressed(){
      controller.previousPage(duration: new Duration(milliseconds: 300), curve: Curves.easeIn);
  }


  void onNextPressed() async{
    if(_currentPosition == 1){
      //check for bluetooth connection and if bluetooth is not on don't continue
      FlutterToAndroid fta = new FlutterToAndroid();
      bool response = await fta.turnBluetoothOnInPlatform();
      if(!response) return;
    }
    if(_currentPosition!=walkTitles.length-1) {
      controller.nextPage(
          duration: new Duration(milliseconds: 300), curve: Curves.easeIn);
      return;
    }
        SettingSharedPreference _setting = new SettingSharedPreference();
        _setting.getSetting().then((onValue){

          onValue.walkthrough = 1;
          _setting.saveSetting(onValue);



          Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => SignUpScreen()));


        });
      }

  }

