import 'dart:async';

import 'package:ethiocare/about_corona.dart';
import 'package:ethiocare/about_screen.dart';
import 'package:ethiocare/app_theme.dart';
import 'package:ethiocare/custom_drawer/drawer_user_controller.dart';
import 'package:ethiocare/custom_drawer/home_drawer.dart';
import 'package:ethiocare/feedback_screen.dart';
import 'package:ethiocare/help_screen.dart';
import 'package:ethiocare/invite_friend_screen.dart';
import 'package:ethiocare/languages/strings.dart';
import 'package:ethiocare/news_detail_screen.dart';
import 'package:ethiocare/news_screen.dart';
import 'package:ethiocare/phone_numbers_screen.dart';
import 'package:ethiocare/shared_preference/setting_shared_preference.dart';
import 'package:ethiocare/sign_up_screen.dart';
import 'package:ethiocare/statistic_screen.dart';
import 'package:ethiocare/tracker_screen.dart';
import 'package:ethiocare/walkthrough.dart';
import 'package:ethiocare/choose_language.dart';
import 'package:ethiocare/model/setting.dart';
import 'package:flutter/material.dart';

import 'choose_language.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {

  Widget screenView;
  DrawerIndex drawerIndex;
  AnimationController sliderAnimationController;

  SettingSharedPreference _settingSharedPreference;
  Strings strings;
  Widget _home = null;
  @override
  void initState() {
    strings = new Strings();
    drawerIndex = DrawerIndex.Tracker;
    _settingSharedPreference = new SettingSharedPreference();
    routTo();
    screenView = TrackerScreen();
    super.initState();
  }

  routTo(){
    _settingSharedPreference.getSetting().then((onValue){
      if(onValue == null || onValue.language == null){
        _home = ChooseLanguage();
        // Setting setting = new Setting();
        // if(onValue!=null) setting = onValue;
        // setting.language = "EN";
        // _settingSharedPreference.saveSetting(setting);
        // onValue = setting;
      }

      else if(onValue.walkthrough == null){
        _home = Walkthrough();
      }else if(onValue.signup == null){
        _home = null;
      }else
        _home = null;
      if(_home!=null){
        if(Navigator.canPop(context)) Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => _home));
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            animationController: (AnimationController animationController) {
              sliderAnimationController = animationController;
            },
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
            },
            screenView: screenView,
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.Tracker) {
        setState(() {
          screenView =  TrackerScreen();
        });
      }else if (drawerIndex == DrawerIndex.News) {
        setState(() {
          screenView = NewsScreen();
        });
      } 
      
      else if (drawerIndex == DrawerIndex.Statistics) {
        setState(() {
          screenView = StatisticScreen();
        });
      } 
      
      else if (drawerIndex == DrawerIndex.AboutCorona) {
        setState(() {
          screenView = AboutCorona();
        });
      } 
       else if (drawerIndex == DrawerIndex.Help) {
        setState(() {
          screenView = HelpScreen();
        });
      } else if (drawerIndex == DrawerIndex.FeedBack) {
        setState(() {
          screenView = FeedbackScreen();
        });
      } else if (drawerIndex == DrawerIndex.Invite) {
        setState(() {
          screenView = InviteFriend();
        });
      } else if(drawerIndex == DrawerIndex.About){
         setState(() {
           screenView = AboutScreen();
         });
      }
       else if(drawerIndex == DrawerIndex.PhoneNumbers){
        setState(() {
          screenView = PhoneNumbersScreen();
        });
      }
    }
  }


}
