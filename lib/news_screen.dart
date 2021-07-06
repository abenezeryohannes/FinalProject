import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:ethiocare/Controllers/news_controller.dart';
import 'package:ethiocare/app_theme2.dart';
import 'package:ethiocare/languages/strings.dart';
import 'package:ethiocare/news_detail_screen.dart';
import 'package:ethiocare/shared_preference/change_subscriber.dart';
import 'package:ethiocare/shared_preference/news_shared_preference.dart';
import 'package:ethiocare/shared_preference/setting_shared_preference.dart';
import 'package:ethiocare/shared_preference/sort_and_filter_by_shared_preference.dart';
import 'package:ethiocare/tracker/TrackAnim.dart';
import 'package:ethiocare/utils/constants.dart';
import 'package:ethiocare/widgets/loading.dart';
import 'package:ethiocare/widgets/news_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/news.dart';
import 'model/setting.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}



class _NewsScreenState extends State<NewsScreen> implements ChangeSubscriber {

  bool isLoadingMore = false;
  List<News> newses;
  NewsHeader newsHeader;
  BuildContext buildContext;
  Strings strings;
  String filterBy = "ethiopia";
  SortAndFilterbySharedPreference _sortAndFilterbySharedPreference = new SortAndFilterbySharedPreference();
  NewsSharedPreference _newsSharedPreference;
  NewsController _newsController;
  Widget whatTOShow = Loading.loading();
  StreamSubscription<ConnectivityResult> subscription;
  bool connected = true;
  bool showAd = true;
  bool adClosed = false;

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
    newsHeader = NewsHeader(onFilter: loadFilterAndNews);
    Future.delayed(const Duration(seconds: 1),loadFilterAndNews);
    subscription = Connectivity().onConnectivityChanged.listen((result){
      checkIfConnection();
    });
    _shouldShowAd();
    super.initState();
  }




  void checkIfConnection() async {
    // ask for bluetooth device list;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      print("noConnection");
      if(mounted)
      setState(() {
        connected = false;
      });
    } else {
      if(mounted)
        setState(() {
      connected = true;
    });
      _newsController.getNewsAfter();
      print("connection");
    }
  }


  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    _newsController.getNewsAfter();
  }

  void _onLoading() async{
  }



  @override
  Widget build(BuildContext context) {
    buildContext = context;

    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  newsHeader,
                  Expanded(
                    child: Container(
                      child: Center(
                        child: (newses == null || newses.length==0)? (connected)?Loading.loading():Loading.loading(text:"Waiting for connection..."):
                        NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (!isLoadingMore && scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent) {

                              setState(() {
                                isLoadingMore = true;
                              });
                              if(newses!=null && newses.length>0)
                              _newsController.getBeforeNewsOf(filterBy: this.filterBy, newsId: newses.last.id);
                              }
                            return true;
                          },

                          child: SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            header: WaterDropHeader(),
                            controller: _refreshController,
                            onRefresh: _onRefresh,
                            onLoading: _onLoading,
                            child: ListView.builder(

                              itemCount: newses.length,

                              itemBuilder: (context, index) {

                                return  _listOfNewses(newses[index]);

                              },
                            ),
                          ),

                        ),
                      ),
                    ),
                  ),

                ],
              ),






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
        )

    );
  }

  void onLoadingError(){

    print("onLoading error");

    setState(() {
      if(newses==null||newses.length==0){
        whatTOShow = Loading.loading(text:strings.language.waiting_for_connection);
      }
      connected = false;
      _refreshController.refreshFailed();
    });

  }
  void onLoading(){
    _refreshController.refreshCompleted();
    print("loading");
  }

  void loadFilterAndNews() async{

    filterBy = await _sortAndFilterbySharedPreference.getFilterBy();
    if(filterBy == null) filterBy = "ethiopia";
    _newsSharedPreference = new NewsSharedPreference(key: this.filterBy);
    _newsSharedPreference.addSubs(this);
    _newsController = new NewsController(
        onLoadingError: onLoadingError,
        onFailure:onFailureLoading ,
        onloadingSuccess:onLoading,
        onSuccess: onSuccessLoading,
        newsSharedPreference: _newsSharedPreference);
    _newsController.getNewsAfter();

    List<News> tempNewses = await _newsSharedPreference.getNewses();
    if(mounted)
      setState(() {
      newses = tempNewses;
      print("fuck dart:${tempNewses.toString()}");
    });
  }

  @override
  void onDataChange() async{
//    String filter = await _sortAndFilterbySharedPreference.getFilterBy();
//    _newsSharedPreference.setWhoseNews(filter);

    List<News> tempNews = await _newsSharedPreference.getNewses();

      if(this.newses == null || this.newses.length == 0 || (this.newses.first.id < tempNews.last.id)
      || (this.newses.last.id == tempNews.last.id && this.newses.first.id < tempNews.first.id)
      )
        {
          print("new news found");
          if(mounted)
            setState(() {newses = tempNews;});
        }
      else{
        print("before update: " +newses.toString() );
        if(newses.last.id == tempNews.last.id){
          onLoadingEnd();
          return;
        }
        if(mounted)
          setState(() { newses.addAll(tempNews.sublist(newses.indexOf(newses.last)));});
        print("after update: ${newses.toString()}");
      }
  }

  void onLoadingEnd(){
    if(mounted)
      setState(() {
      _refreshController.loadNoData();
      isLoadingMore = false;
    });
  }



  void onSuccessLoading(bool tord){
    if(tord){
      if(mounted)setState(() {
                isLoadingMore = false;
              });}
      else{
      if(mounted)setState(() {
        isLoadingMore = true;
      });
      _refreshController.loadNoData();
      }
  }



  void onFailureLoading(){
    if(mounted)
      setState(() {
      isLoadingMore = false;
    });

  }








  Widget _listOfNewses(News f) {
   return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),),
        elevation: 10,
//        margin: EdgeInsets.only(bottom:10),
        margin: EdgeInsets.only(bottom:20, left:10, right:10),
        color: Colors.grey[100],
        child: InkWell(
          onTap: ()async{
            final result = await Navigator.push(buildContext,MaterialPageRoute(builder: (context) => NewsDetailScreen(f:f)));

            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
              systemNavigationBarColor: Colors.white,
              systemNavigationBarDividerColor: Colors.grey,
              systemNavigationBarIconBrightness: Brightness.dark,
            ));

          },
          child: Column(
            children: <Widget>[
//            Image.network(Constants.basePhotoUrl + "betty1.jpg")
            Hero(
              tag: f.id.toString(),
              child:(f.image_url.length>0)? CachedNetworkImage(
                imageUrl: Constants.releaseBaseUrl+f.image_url,
                imageBuilder: (context, imageProvider) => Container(
                  width: MediaQuery.of(buildContext).size.width-20,
                  height: ((MediaQuery.of(buildContext).size.width-20)*3)/4,
               decoration: BoxDecoration(
               image: DecorationImage(
                   image: imageProvider,
                   fit: BoxFit.cover,
               ), ), ),
                placeholder: (context, url) => Container(
                    width: MediaQuery.of(buildContext).size.width-20,
                height: ((MediaQuery.of(buildContext).size.width-20)*3)/4,
                    child: Center(child: CircularProgressIndicator())),
                errorWidget: (context, url, error) => Container(
                    width: MediaQuery.of(buildContext).size.width-20,
                    height: ((MediaQuery.of(buildContext).size.width-20)*3)/4,child: Center(child: Icon(Icons.error))),
              ): SizedBox(height:0)
            ),
              Container(
                padding: EdgeInsets.only(left:10, right:10),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top:15.0, bottom:10),
                      child: Text( f.title, textAlign: TextAlign.start, style: AppTheme2.newsTitle,),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom:10.0),
                      child: Text(f.description,
                        maxLines: 5,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.start, style: AppTheme2.body1,),
                    )
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(left:10, right:10, bottom:5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text("source: TIKVAH ETHIOPIA",
                        style: AppTheme2.caption,)
                    ),
                    InkWell(
                      child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text("Read more >>",
                            style: TextStyle(
                            fontFamily: AppTheme2.fontName,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            letterSpacing: 0.2,
                            color: Colors.blue[800],
                          ))
                      ),
                      onTap: () async{
                        final result = await Navigator.push(buildContext,MaterialPageRoute(builder: (context) => NewsDetailScreen(f:f)));

                        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                          statusBarColor: Colors.transparent,
                          statusBarIconBrightness: Brightness.dark,
                          statusBarBrightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
                          systemNavigationBarColor: Colors.white,
                          systemNavigationBarDividerColor: Colors.grey,
                          systemNavigationBarIconBrightness: Brightness.dark,
                        ));

                        },
                    ),
                  ],
                )
              )
      ],
      ),
        ),
      );
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
                                      adClosed = true;
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
      adClosed = true;
      Future.value(false);
    }
    else {
      showAd = true;
      Future.value(true);
    }
  }


}
