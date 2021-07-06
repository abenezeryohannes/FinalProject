import 'dart:convert';
import 'dart:io';

import 'package:ethiocare/Controllers/about_corona_controller.dart';
import 'package:ethiocare/model/info.dart';
import 'package:ethiocare/model/info_category.dart';
import 'package:ethiocare/Widgets/info_category_selector.dart';
import 'package:ethiocare/Widgets/loading.dart';
import 'package:ethiocare/shared_preference/change_subscriber.dart';
import 'package:ethiocare/shared_preference/info_shared_preference.dart';
import 'package:ethiocare/shared_preference/setting_shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Widgets/info_card.dart';
import 'app_theme.dart';
import 'app_theme2.dart';
import 'languages/strings.dart';
import 'model/globalapi.dart';
import 'model/setting.dart';
import 'shared_preference/info_catagory_shared_preference.dart';


enum Show{loading,error,data}

class AboutCorona extends StatefulWidget {
  @override
  _AboutCoronaState createState() => _AboutCoronaState();
}

class _AboutCoronaState extends State<AboutCorona> {

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

    return Container(
      color: AppTheme.white,
      child:  Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child:Content()
            )
    );

  }
      
}



class Content extends StatefulWidget {
  
  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> implements ChangeSubscriber{
  Strings strings = new Strings();
  InfoCatagorySharedPreference catPrefs = new InfoCatagorySharedPreference();
  InfoSharedPreference infoPrefs = new InfoSharedPreference();
  AboutCoronaController _controller;
  bool showAd = true;
  bool adClosed = true;
  List<InfoCategory> infoCategories = new List();
  List<Info> infos = new List();
  List<Info> selectedInfos = new List();
  ScrollController _infosScrollController = new ScrollController();
  Show show;
  Widget whatIsShowed = Loading.loading();

  static const int catagory_size = 10, info_size_in_catagory = 10;

  @override
  void initState() {
    show = Show.loading;
    catPrefs.addSubs(this);
    infoPrefs.addSubs(this);
    _shouldShowAd();

    _controller = new AboutCoronaController(catPrefs, infoPrefs);
    _controller.addSubs(this);
    super.initState();
   
    
    loadAsync();
  
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    
    return  Scaffold(
        backgroundColor: Colors.white,

        body: Stack(
          children: <Widget>[
            Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _title(),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        height: (size.height*9)/10,
                        alignment: Alignment.center,
                      child: AnimatedSwitcher(duration: new Duration(milliseconds: 500),
                      transitionBuilder: (Widget child, Animation<double> animation){
                        return FadeTransition(opacity: animation, child:child);
                      },
                      child: whatIsShowed,


                      )),
                    )
                ],),


    (!adClosed)?
        Align(
          alignment: Alignment.bottomCenter,
          child: FutureBuilder(
            future: Future.delayed(Duration(seconds: (showAd)?5:15), ()
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
      );
  }

  void _showAppropriate(){
    if(show == Show.data){whatIsShowed =  _showData();}
    else if(show == Show.loading){whatIsShowed =  Loading.loading();}
    else whatIsShowed = Loading.loadingErrorWithRetry(callback:loadAsync);
  }

  void loadAsync() async{
    Future.delayed(new Duration(seconds: 0), () async {
      _controller.getInfo(strings);

      infoCategories = await catPrefs.loadListOfCategories();
      infos = await infoPrefs.loadListOfInfos();

      if (infoCategories.length > 0 && infos.length > 0) {
        if(mounted) setState(() {
          selectedInfos = infos.where((test){return test.category_id== infoCategories[0].id;}).toList();
          show = Show.data; _showAppropriate();});
      } else {
        String json = await DefaultAssetBundle.of(context).loadString("assets/json/aboutcorona${strings.lang.toLowerCase()}.json");
        if (json != null) {
          infoCategories = GlobalApi.getCategoriesFromFile(json);
          infos = GlobalApi.getInfosFromFile(json);
         if (mounted)
            setState(() {
              selectedInfos = infos.where((test){return test.category_id== infoCategories[0].id;}).toList();
              show = Show.data;
              _showAppropriate();
            });
        }
      }
    });
  }


//    else
//      if(onValue!=null&&onValue.length>0){
//            setState(() {
//              infos = onValue;
//              show = Show.loading;
//              _showAppropriate();
//            });
//          }
//    });




  Widget _showData(){
    Size size = MediaQuery.of(context).size;
    return Column(children: <Widget>[ 
      SizedBox(height: size.height/10,
                  
        child: Container(
          child: InfoCategorySelector(notifyParent: refresh, infoCats: infoCategories, size: size),
        )
      ),

        SizedBox(height: 10),

        SizedBox(
          height: (size.height*7)/10,
          child: ListView.builder(
            controller: _infosScrollController,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount:  selectedInfos.length ,
            itemBuilder: (context, index){
              Info info = selectedInfos[index];
              return Container(
                width: (size.width*8)/10,
                padding: EdgeInsets.only(
                  left: (30),
                  top: (size.height/95),
                  bottom: (size.height/95),
                  right: (selectedInfos.length==index+1)?30:0
                ),
                alignment: Alignment.center,
                child: InfoCard(
                  info: info,
                  cardNum: index
                )
              );
            },
          )
        )],);
  }

  void refresh(InfoCategory infoCategory){
    setState(() {
      selectedInfos = infos.where((test){return test.category_id== infoCategory.id;}).toList();
      _infosScrollController.animateTo(0.0, duration: new Duration(milliseconds:200), curve: Curves.easeOut);
     _showAppropriate();
     });
  }



   Widget _title(){
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  strings.language.about_corona_title,
                  style: TextStyle(
                    fontSize: 22,
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  void onDataChange() async{

    List<InfoCategory> tempInfosCats = await catPrefs.loadListOfCategories();
    List<Info> tempInfos = await infoPrefs.loadListOfInfos();

    if(tempInfosCats.length ==0||tempInfos.length==0) {
      if(infoCategories.length==0||infos.length==0)
        {show = Show.error;if(mounted) setState(() {_showAppropriate();});}
    }else{
      infos = tempInfos; infoCategories = tempInfosCats;
      List<Info> temp = new List();
      infos = tempInfos;
      if(selectedInfos == null || selectedInfos.length == 0)
        temp = infos.where((test){return test.category_id== infoCategories[0].id;}).toList();
      else
        temp = infos.where((test){return test.category_id== selectedInfos[0].category_id;}).toList();

      if(mounted)
        setState(() {
          selectedInfos = temp;
          print("selectedInfos: "+selectedInfos.toString());
          show = Show.data;
          _showAppropriate();
        });
    }

    print("data recieved");
  }










  Widget _showAd(){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
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
                                      adClosed = true;
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
                      adClosed = true;
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
              adClosed = true;
            });
        },
      ),
    );
  }
  Future<bool> _shouldShowAd() async{
    SettingSharedPreference ssp = new SettingSharedPreference();
    Setting s =await ssp.getSetting();
    if(s.ad == 1) {
      showAd = false;
      Future.value(false);
    }
    else {
      showAd = true;
      Future.value(true);
    }
  }
}
