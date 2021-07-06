import 'package:ethiocare/app_theme.dart';
import 'package:ethiocare/app_theme2.dart';
import 'package:flutter/material.dart';

import 'languages/strings.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  Strings strings = new Strings();

  @override
  void initState() {
    strings = new Strings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _title(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(bottom: 30.0),
                shrinkWrap: true,
                children: <Widget>[
                  Image.asset("assets/images/appicon2.png", width: double.infinity, height: 300.0,),
                  _text(strings.language.help_page_title1, strings.language.help_page_description1),
                  _text(strings.language.help_page_title2, strings.language.help_page_description2),
                  _text(strings.language.help_page_title3, strings.language.help_page_description3),
                  _text(strings.language.help_page_title4, strings.language.help_page_description4),
                  _text(strings.language.help_page_title5, strings.language.help_page_description5),
                ],
              ),
            )
          ],
        ),
      )
    );
  }

  Widget _text(String title, String description){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10.0, right:10.0, top:30.0, bottom: 10.0),
              child: Text(title,
                textAlign: TextAlign.start,
                style: AppTheme2.headline,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right:10.0, top:10.0, bottom: 10.0),
              child: Text(description,
                textAlign: TextAlign.start,
                style: AppTheme2.body1,
              ),
            ),
          ],
        );
  }


  Widget _title(){
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Icon(Icons.arrow_back),
            ),
            onTap: (){
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 6, right:64),
                child: Text(
                  strings.language.nav_help,
                  style: AppTheme2.myTitles
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
