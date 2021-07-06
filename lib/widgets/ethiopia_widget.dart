import 'dart:core';

import 'package:ethiocare/languages/strings.dart';
import 'package:ethiocare/model/country_data.dart';
import 'package:ethiocare/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_theme2.dart';
import '../main.dart';

class EthiopiaWidgets {

  static Widget buildAllCountriesStat(List<CountryData> countries,
      Strings strings) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: ClampingScrollPhysics(),
      itemCount:  countries.length,
      itemBuilder: (context, index) {
        CountryData countryData = countries[index];
        return Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            alignment: Alignment.topCenter,
            child: buildStatContainer(countryData, strings)
        );
      },
    );
  }


  static Widget buildStatContainer(CountryData country, Strings strings) {
    return Column(
        children: <Widget>[

          Padding(padding: const EdgeInsets.only(top: 5, left: 10, right: 5),
              child: Row(
                  children: <Widget>[
                    thecountry(country, strings)
                  ]
              )
          ),

          Container(
              margin: const EdgeInsets.only(
                  left: 0, right: 0, top: 5, bottom: 10),

              alignment: Alignment.center,
              padding: EdgeInsets.only( left: 10, right: 10, top:10, bottom: 10),
              decoration: BoxDecoration(
                color: AppTheme2.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: AppTheme2.grey.withOpacity(0.2),
                      offset: Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding:
                        const EdgeInsets.only(top: 5, left: 5, right: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8, top: 4),
                                      child: situationBuilder(
                                          country, strings))
                              ),
                            ]
                        )),
                  ])
          )
        ]);
  }

  static totalCase(CountryData country, Strings strings) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 10),
        child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: country == null ? "0" : country.total_cases.toString(),

                style: TextStyle(

                    fontFamily: AppTheme2.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    letterSpacing: 0.5,
                    color: AppTheme2.nearlyBlack
                ),
                children: <InlineSpan>[
                  TextSpan(
                    text: strings.language.statistics_page_total_cases,
                    style: TextStyle(
                      fontFamily: AppTheme2.fontName,
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                      letterSpacing: 0.5,
                      color: AppTheme2.lightText,
                    ),)
                ])


        ),
      ),
    );
  }


  static Widget thecountry(CountryData country, Strings strings) {
    return
      Text(country.title == null
          ? strings.language.statistics_page_situation
          : country.title,
          style: TextStyle(
            fontFamily: AppTheme2.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: 0.1,
            color: AppTheme2.grey,
          ));
  }


  static Widget situationBuilder(CountryData _globalData, Strings strings) {
    return Column(
      children: <Widget>[

        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              mainItems(color: Constants.blue,
                  mainTitle: strings.language.statistics_page_total_cases,
                  count: _globalData == null ? 0 : _globalData.total_cases,
                  total: _globalData == null ? 1 : _globalData.total_cases),
              mainItems(color: Constants.red2,
                  mainTitle: strings.language.statistics_page_total_deaths,
                  count: _globalData == null ? 0 : _globalData.total_deaths,
                  total: _globalData == null ? 1 : _globalData.total_cases),
              mainItems(color: Constants.green,
                  mainTitle: strings.language.statistics_page_recovered,
                  count: _globalData == null ? 0 : _globalData.total_recovered,
                  total: _globalData == null ? 1 : _globalData.total_cases),

            ],),
        ),

        Container(

          padding: EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              mainItems(color: Constants.blue,
                  mainTitle: strings.language.statistics_page_active_cases,
                  count: _globalData == null ? 0 : _globalData
                      .total_active_cases,
                  total: _globalData == null ? 1 : _globalData.total_cases),
              // _mainItems(color: Constants.orange, mainTitle:"Serious cases",
              // count:_globalData==null? 0: _globalData.total_serious_cases,
              //   total:_globalData==null? 1: _globalData.total_active_cases),
              mainItems(
                  color: Constants.blue,
                  mainTitle: strings.language.statistics_page_total_new_cases,
                  count: _globalData == null ? 0 : _globalData
                      .total_new_cases_today,
                  total: _globalData == null ? 1 : _globalData
                      .total_active_cases
              ),
              mainItems(
                  color: Constants.red2,
                  mainTitle: strings.language.statistics_page_deaths,
                  count: _globalData == null ? 0 : _globalData
                      .total_new_deaths_today,
                  total: _globalData == null ? 1 : _globalData.total_deaths),


            ],),
        ),

        // Padding(
        //     padding: EdgeInsets.only(bottom:10),
        //         child: Row(children: <Widget>[
        //        _crossItems(
        //             color1: Constants.red2,
        //             crossTitle:"Today deaths",
        //             count:_globalData==null? 0: _globalData.total_new_deaths_today,
        //             total:_globalData==null? 1: _globalData.total_deaths),
        //         ]),
        //   ),


      ],
    );
  }


  static Widget mainItems({String color, String mainTitle, int count, int total}) {
    return Expanded(

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0, bottom: 0),
                  child: Text(
                    mainTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily:
                      AppTheme2.fontName,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      letterSpacing: -0.1,
                      color: AppTheme2.grey,
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.all(10),
                  child: Text(
                    '$count',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily:
                      AppTheme2
                          .fontName,
                      fontWeight:
                      FontWeight.w700,
                      fontSize: 26,
                      color: HexColor(color),
                    ),
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }


  static crossItems(
      {String color1, String color2, String color3, String crossTitle, int count, int total}) {
    return Expanded(
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
                fontSize: 12,
                letterSpacing: -0.2,
                color: AppTheme2.darkText,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                '$count',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTheme2.fontName,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: HexColor(color1),
                ),
              ),
            ),
          ],
        ));
  }
}
