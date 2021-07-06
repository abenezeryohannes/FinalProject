import 'package:ethiocare/app_theme.dart';
import 'package:flutter/material.dart';

class Loading{
  static final String loadingTxt = "loading please wait...";
  static final String loadingErrorTxt = "Error loading. try again later...";

  static Widget loading({Size size, String text}){
    if(text == null) text = loadingTxt;
    return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left:50, right:50),
          child: Container(
          decoration: BoxDecoration( color: Colors.transparent, borderRadius: new BorderRadius.circular(20.0)),
          alignment: Alignment.center,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: <Widget>[
          Padding(padding: EdgeInsets.only(top:30),
          child: CircularProgressIndicator(value: null, strokeWidth:5.0),
          ),
          Container(margin: const EdgeInsets.only(top:25.0),
          padding: EdgeInsets.only(top:10, bottom:30),
          child:  Center(
            child: Text(text,style: TextStyle(color: Colors.grey)
              ),
          ))]
        ,)
      ),
    );
  }

  static Widget loadingError({String text}){
    if(text==null) text = loadingErrorTxt;
    return  Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left:50, right:50),
          child: Container(
          decoration: BoxDecoration( color: Colors.white, borderRadius: new BorderRadius.circular(20.0)),
          alignment: Alignment.center,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: <Widget>[
          Padding(padding: EdgeInsets.only(top:30),
          child: Icon(Icons.error_outline, color: AppTheme.grey, size: 100,)
          ),
          Container(margin: const EdgeInsets.only(top:25.0),
          padding: EdgeInsets.only(top:10, bottom:30),
          child:  Center(
            child: Text(text,style: TextStyle(color: Colors.grey)
              ),
          ))]
        ,)
      ),
    );
  }

  static Widget loadingErrorWithRetry({String text, Function callback}){
    if(text==null) text = loadingErrorTxt;
    return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left:50, right:50),
          child: Container(
          decoration: BoxDecoration( color: Colors.white, borderRadius: new BorderRadius.circular(20.0)),
          alignment: Alignment.center,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: <Widget>[
          Padding(padding: EdgeInsets.only(top:30),
          child: Icon(Icons.error_outline, color: AppTheme.grey, size: 100,)
          ),
          Container(margin: const EdgeInsets.only(top:25.0, bottom: 20.0),
          
            child:  Center(
              child: RaisedButton(
                    child:Text("Retry", textAlign: TextAlign.center,),
                    onPressed: (){ callback(); },

                ),
            ))
        ]
        ,)
      ),
    );
  }
}