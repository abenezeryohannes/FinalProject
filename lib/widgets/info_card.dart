import 'package:cached_network_image/cached_network_image.dart';
import 'package:ethiocare/model/info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';

class InfoCard extends StatelessWidget {
  final Info info;
  final int cardNum;

  InfoCard({@required
    this.info, this.cardNum
  });
  
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.white70],
                  begin: Alignment.bottomLeft,
                  end: Alignment.bottomLeft, 
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 8),
                      blurRadius: 8,
                    )
                  ],
                  borderRadius: BorderRadius.circular(30),
              ),
              child: ListView(
                children: <Widget>[
               



                  Container(alignment: Alignment.center,
                  padding: EdgeInsets.only(top: (info.image == null || info.image.length==0)?0:10,
                                                 bottom:10, left:40, right:40),
                  child:(info.image == null || info.image.length==0)?
                  SizedBox(height: 0,width: 0,)
                  :CachedNetworkImage(
                    imageUrl: info.image,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ), ), ),
                    placeholder: (context, url) => Container(
                        width: 200,
                        height: 200,
                        child: Center(child: CircularProgressIndicator())),
                    errorWidget: (context, url, error) => Container(
                        width: 200,
                        height: 200,child: Center(child: Icon(Icons.error))),
                  )
                  ),


                 

                  Container(alignment: Alignment.center,
                    padding: EdgeInsets.only(top:10, left:20, right:20, bottom:10),
                    child: Text(info.title,

                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: AppTheme.fontName)
                
                  )
                  ),
                  

                  Container(alignment: Alignment.center,
                    padding: EdgeInsets.only(top:10, left:20, right:20, bottom:10),
                    child: 
                    Text(info.description,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, fontFamily: AppTheme.fontName)
                  )
                  
                  ),
                  
                ],


              )
          ),
        ),
        
      
      ],
      
      )

    );
  }

  
}
