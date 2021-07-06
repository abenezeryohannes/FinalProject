import 'package:ethiocare/languages/strings.dart';
import 'package:ethiocare/walkthroughs/walks.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:ethiocare/walkthroughs/assset_type.dart';
import 'package:flutter/material.dart';

import '../app_theme2.dart';

class InfoWalks{

  final List<String> walkTitles;
  final List<String> walkDesc;
  final List<AssetType> assetTypes;
  final List<String> assets;
  final BuildContext context;
  final Strings strings;
  InfoWalks({@required this.strings, this.walkDesc,this.walkTitles,this.assetTypes, this.assets, this.context});
  
  Widget info(int index) {
    return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
//                      color:Colors.red,
                      margin: EdgeInsets.only(bottom:20),
                        width: MediaQuery.of(context).size.width*2/2,
                        height: MediaQuery.of(context).size.width*2/3,
                        child: (assetTypes[index] == AssetType.image)
                            ? Image.asset(
                                "assets/images/${assets[index]}",
                                alignment: Alignment.center,
                        )
                            : FlareActor(
                                "assets/animations/bluetooth_walkthrough.flr",
                                alignment: Alignment.center,
                                isPaused: false,
                                fit: BoxFit.contain,
                                animation: "pulse")),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child: Text(
                            walkTitles[index],
                            textAlign: TextAlign.center,
                            style:  TextStyle(
                                fontSize: 20,
                                color: Colors.grey[800],
                                fontFamily: AppTheme2.fontName,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5),
                          ),
                        ),
                        Text(
                          walkDesc[index],//walkDesc[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                          fontFamily: AppTheme2.fontName,
                          letterSpacing: -0.5),
                    )
                      ],
                    ),
                    
                  ]),
            ),
          ],
        ));
  }
}