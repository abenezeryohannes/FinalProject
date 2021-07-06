import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ethiocare/model/globalapi.dart';
import 'package:ethiocare/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_theme2.dart';
import 'model/news.dart';

class NewsDetailScreen extends StatelessWidget {

  final News f;
  NewsDetailScreen({@required this.f});


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

    return Scaffold(
            
            backgroundColor: Colors.white,
            body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      leading: IconButton(icon:Icon(Icons.arrow_back, color: Colors.grey[800]),onPressed:() => Navigator.pop(context, false),),

                      backgroundColor: Colors.white,
                      expandedHeight: 400.0,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                          title: Padding(
                            padding: const EdgeInsets.only(left:100.0, right:100),
                            child: Text(f.title,
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                style: AppTheme2.myTitles),
                          ),
                          background: Hero(
                            tag: f.id.toString(),
                            child: (f.image_url.length>0)? CachedNetworkImage(
                                    imageUrl: Constants.releaseBaseUrl+f.image_url,
                                    imageBuilder: (context, imageProvider) => Container(
                                    width: MediaQuery.of(context).size.width-20,
                                    height: ((MediaQuery.of(context).size.width-20)*3)/4,
                                    decoration: BoxDecoration(
                                    image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                    ), ), ),
                                    placeholder: (context, url) => Container(
                                    width: MediaQuery.of(context).size.width-20,
                                    height: ((MediaQuery.of(context).size.width-20)*3)/4,
                                    child: Center(child: CircularProgressIndicator())),
                                    errorWidget: (context, url, error) => Container(
                                    width: MediaQuery.of(context).size.width-20,
                                    height: ((MediaQuery.of(context).size.width-20)*3)/4,child: Center(child: Icon(Icons.error))),
                                    ): SizedBox(height:0)
                            ),
                    ))];
                },
                body: Center(
                    child: ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            padding:
                                const EdgeInsets.only(top: 15.0, bottom: 20),
                            child: Text(
                              f.title,
                              textAlign: TextAlign.start,
                              style: AppTheme2.newsDetailheadline,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Text(
                              f.description,
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.start,
                              style: AppTheme2.newsDeatiltext,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  "source: TIKVAH ETHIOPIA",
                                  style: AppTheme2.caption,
                                )),

                          ],
                        ))
                  ],
                ))));
  }
}
