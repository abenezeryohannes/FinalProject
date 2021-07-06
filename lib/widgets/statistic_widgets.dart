import 'package:ethiocare/Utils/constants.dart';
import 'package:ethiocare/languages/strings.dart';
import 'package:ethiocare/model/country_data.dart';
import 'package:flutter/material.dart';
import '../app_theme2.dart';
import '../main.dart';


class StatisticsWidgets extends StatefulWidget {
  final CountryData globalData;

  StatisticsWidgets({@required this.globalData});
  
  @override
  _StatisticsWidgetsState createState() => _StatisticsWidgetsState();
}

class _StatisticsWidgetsState extends State<StatisticsWidgets> {
  Strings strings = new Strings();
  @override
  Widget build(BuildContext context) {
    strings = new Strings();
    return _buildStatContainer(widget.globalData, strings);
  }
}
  

  Widget _buildStatContainer(CountryData country, Strings strings){
      return  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                 _country(country, strings),
                 Container(

                      decoration: BoxDecoration(
                        color: AppTheme2.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                            topRight: Radius.circular(68.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: AppTheme2.grey.withOpacity(0.2),
                              offset: Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),

                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10, left: 16, right: 16),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, top: 4),
                                    child:   _situationBuilder(country, strings))
                                  ),
                              ]
                        )),







                        ])

                    ),
        
                ]);

  }



  Widget _country(CountryData country, Strings strings){
    return Padding(
              padding: EdgeInsets.only(left:5, top: 0, bottom: 10),
              child: Text(country==null? strings.language.statistics_page_total_cases : country.title,
                      style: TextStyle(
                        fontFamily: AppTheme2.fontName,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        letterSpacing: 0.5,
                        color: AppTheme2.lightText,
                      ))
            );
  }
  

  
   Widget _situationBuilder(CountryData _globalData, Strings strings){
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left:0),
            child: Container(
              padding: EdgeInsets.only(bottom:10),
                          child: RichText(

                  text: TextSpan(
                    text: _globalData == null ||  _globalData.total_cases == null? "0" : _globalData.total_cases.toString(),
                    style: TextStyle(
                        fontFamily: AppTheme2.fontName,
                        fontWeight: FontWeight.w500,
                        fontSize: 25,
                        letterSpacing: 0.5,
                        color: AppTheme2.lightText,
                      ),
                    children: <InlineSpan> [
                  TextSpan(
                  text: strings.language.statistics_page_total_cases,
                  style: TextStyle(
                      fontFamily: AppTheme2.fontName,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      letterSpacing: 0.5,
                      color: AppTheme2.lightText,
                    ),)
                ])



              ),
            )
          ),
          Padding(
            padding: EdgeInsets.only(bottom:10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                  _mainItems(color: Constants.blue,mainTitle:strings.language.statistics_page_active_cases,
                  count:_globalData==null ||  _globalData.total_active_cases == null? 0: _globalData.total_active_cases,
                    total:_globalData==null || _globalData.total_cases == null? 1: _globalData.total_cases),
                  _mainItems(color: Constants.orange, mainTitle:strings.language.statistics_page_serious_cases,
                  count:_globalData==null || _globalData.total_serious_cases== null? 0: _globalData.total_serious_cases,
                    total:_globalData==null || _globalData.total_active_cases == null? 1: _globalData.total_active_cases),

            ],),
          ),

          Padding(
            padding: EdgeInsets.only(bottom:0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                  _mainItems(color: Constants.red2, mainTitle:strings.language.statistics_page_total_deaths,
                  count:_globalData==null||_globalData.total_deaths==null? 0: _globalData.total_deaths,
                    total:_globalData==null|| _globalData.total_cases==null? 1: _globalData.total_cases),
                  _mainItems(color: Constants.green, mainTitle:strings.language.statistics_page_recovered,
                   count:_globalData==null||_globalData.total_recovered==null? 0: _globalData.total_recovered,
                    total:_globalData==null||_globalData.total_cases==null? 1: _globalData.total_cases),
            ],),
          ),

        Padding(padding: EdgeInsets.only(top:8, bottom:8),
        child: Divider(
          color: Colors.grey.withAlpha(30),
          thickness: 1,
        ),
        ),
        Padding(
            padding: EdgeInsets.only(bottom:10),
                child: Row(children: <Widget>[
               _crossItems(
                    color1: Constants.blue,
                    crossTitle:strings.language.statistics_page_total_new_cases,
                    count:_globalData==null||_globalData.total_new_cases_today==null? 0: _globalData.total_new_cases_today,
                    total:_globalData==null||_globalData.total_active_cases==null? 1: _globalData.total_active_cases
                    ),
               _crossItems(
                    color1: Constants.red,
                    crossTitle:strings.language.statistics_page_deaths,
                    count:_globalData==null||_globalData.total_new_deaths_today==null? 0: _globalData.total_new_deaths_today,
                    total:_globalData==null||_globalData.total_deaths==null? 1: _globalData.total_deaths),
                ]),
          ),


        ],
      );
  }




   Widget _mainItems({String color, String mainTitle, int count,int total}){
    return Expanded(

          child: Row(
              children: <Widget>[
                Container(
                        height: 48,
                        width: 3,
                        decoration: BoxDecoration(
                          color:
                              HexColor(color).withOpacity(0.2),
                          borderRadius: BorderRadius.all(
                              Radius.circular(4.0)),
                        ),
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 3,
                              height: ((48)*((count)/total)),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  HexColor(color),
                                  HexColor(color)
                                      .withOpacity(0.5),
                                ]),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0)),
                              ),
                            )
                          ],
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 0, bottom: 2),
                        child: Text(
                          mainTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily:
                                AppTheme2.fontName,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            letterSpacing: -0.1,
                            color: AppTheme2.grey,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        crossAxisAlignment:
                            CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(
                                    left: 4, bottom: 3),
                            child: Text(
                              '$count',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily:
                                    AppTheme2
                                        .fontName,
                                fontWeight:
                                    FontWeight.w600,
                                fontSize: 16,
                                color: AppTheme2
                                    .darkerText,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
    );                                  
  }

  
   _crossItems({String color1, String color2, String color3, String crossTitle,int count, int total}){
    return   Expanded(
      child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    crossTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppTheme2.fontName,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      letterSpacing: -0.2,
                      color: AppTheme2.darkText,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Container(
                      height: 4,
                      width: 70,
                      decoration: BoxDecoration(
                        color:
                            HexColor(color1).withOpacity(0.2),
                        borderRadius: BorderRadius.all(
                            Radius.circular(4.0)),
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: ((70)*(count/total)),
                            height: 4,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                HexColor(color1),
                                HexColor(color1)
                                    .withOpacity(0.5),
                              ]),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4.0)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '$count',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppTheme2.fontName,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: AppTheme2.grey
                            .withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ));
            
  }

