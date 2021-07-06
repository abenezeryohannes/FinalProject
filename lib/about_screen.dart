import 'dart:io';

import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import './app_theme.dart';
import './app_theme2.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'languages/strings.dart';

class Devs{ String image; String full_name; String role; String desc; String tg; Devs({this.full_name, this.image, this.role, this.desc, this.tg});}


class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  Strings strings = new Strings();
  List<Devs> devs  = [
    new Devs(full_name: "Abenezer Yohannes",image: "assets/images/abenezer.jpg", role: "Mobile app development",tg: "https://t.me/Abenezer_yab"),
    new Devs(full_name: "Kibru Demeke",image: "assets/images/kibru.jpg",  role: "System management", tg: "https://t.me/qwerty1000238664792"),
    new Devs(full_name: "Nebiyu Adem",image: "assets/images/nebiyu.jpg",  role: "backend development", tg: "https://t.me/NebiyuAdem"),
    new Devs(full_name: "Hawi Kaba", image: "assets/images/hawi2.jpg",  role: null, tg: "https://t.me/abcy12"),
    new Devs(full_name: "Yiwosin Dagne", image: "assets/images/yiwosin.jpg",  role: null, tg: "https://t.me/yiwosin")
  ];


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

    strings = new Strings();
    super.initState();
  }

  _launchUrl(url) async {
    if(await canLaunch(url)){
      await launch(url);
    }else {
      throw 'Could not perform the action';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _title(),



              Expanded(
               child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(strings.language.developers, style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          letterSpacing: 0.27,
                          color: Colors.grey[800],
                      ),),
                    ),

                ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemCount: devs.length - 2,
                    itemBuilder: (context, item){
                      return _developersCard(item);
                    }),

                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(strings.language.contributors, style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        letterSpacing: 0.27,
                        color: Colors.grey[800],
                      ),),
                    ),

                    ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        itemCount: 2,
                        itemBuilder: (context, item){
                          return _developersCard(item+3);
                        }),
                    SizedBox(height: 20,)
                  ],
                )
              )

            ],
          ),
        ));
  }

  Widget _developersCard(int item){
    return Card(
      margin: EdgeInsets.only(left:30, right:30, bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),

        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(backgroundImage: AssetImage(devs[item].image),
                  backgroundColor: Colors.blue[800], radius: 15,),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.only(top:10.0, left:10),
                    child: Text(devs[item].full_name, style: AppTheme2.NotBold,),
                  ),

                  (devs[item].role == null)? SizedBox(height: 0):
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:5, horizontal:10),
                    child: Text(devs[item].role , style: AppTheme2.body2,),
                  ),



                  (devs[item].tg == null)? SizedBox(height: 0):
                  OutlineButton.icon(
                    color: Colors.blue[900],
                    icon: FaIcon(FontAwesomeIcons.telegram, color: Colors.grey[500],),
                   label: Text("Telegram account", style: AppTheme2.body1,),
                   onPressed: (){
                     _launchURL(devs[item].tg);
                   },
                  )


                ],
              ),
            ],
          ),
        ),
    );
  }

  _launchURL(String urlString) async{
    if(await canLaunch(urlString)){
      await launch(urlString);
    }else {
      throw 'Couldnot launch $urlString';
    }
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
                          strings.language.nav_developers,
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
                SizedBox(width: 40,)

              ])),
    );
  }
}
