import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ethiocare/shared_preference/setting_shared_preference.dart';
import 'package:ethiocare/widgets/ethiopia_widget.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:connectivity/connectivity.dart';
import 'package:ethiocare/Controllers/statistics_controller.dart';

import 'package:ethiocare/Widgets/loading.dart';
import 'package:ethiocare/Widgets/statistic_widgets.dart';
import 'package:ethiocare/model/country_data.dart';

import 'package:ethiocare/model/global_data.dart';
import 'package:ethiocare/languages/strings.dart';
import 'package:ethiocare/shared_preference/change_observer.dart';
import 'package:ethiocare/shared_preference/change_subscriber.dart';
import 'package:ethiocare/shared_preference/country_data_shared_preference.dart';

import 'package:ethiocare/shared_preference/global_data_shared_preference.dart';
import 'package:ethiocare/shared_preference/sort_and_filter_by_shared_preference.dart';
import 'package:ethiocare/widgets/statistic_sort_dialog.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/setting.dart';
import 'widgets/countries_widgets.dart';
import 'widgets/search_and_filter.dart';

import 'app_theme.dart';
import 'app_theme2.dart';



class StatisticScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppTheme.white,

        child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: StatisticPage()));

  }

}

class StatisticPage extends StatefulWidget  with ChangeObserver{
  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage>
    with TickerProviderStateMixin
    implements ChangeSubscriber {
  ///
  Strings strings;
  static String sortByWhat;
  bool successfullyFetched =false;
  Widget _loading;
  bool showAd = true;
  bool adClosed = true;
  //
  GlobalDataSharedPreference _globalDataSharedPreference =
      new GlobalDataSharedPreference();
  SortAndFilterbySharedPreference _sortbySharedPreference = new SortAndFilterbySharedPreference();

  CountryDataSharedPreference _countryDataSharedPreference =
      new CountryDataSharedPreference();
  SearchAndFilter searchAndFilter;
  bool isSearchOpen = false;
  int desired_selected_number_of_country = 10;
  int add_this_more = 20;

  GlobalData _globalData;
  CountryData _globalCountryData;
  List<CountryData> _countryDatas = new List();
  List<CountryData> _selectedCountryList = new List();
  StatisticsController _statsController;
  Widget countryPrevew = Loading.loading();
  List<CountryData> searchedCountry = new List();
  List<String> sortBy = new List();

  AnimationController animationController;
  Animation animation;
  StreamSubscription<ConnectivityResult> subscription;
  List<CountryData> showedCountries = new List();
  bool isLoadingMore = true;


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
  _loading = Loading.loading();
  _shouldShowAd();
    //filter by


  initialize();
  subscription = Connectivity().onConnectivityChanged.listen((result){
    checkIfConnection(result);
  });
    super.initState();
    //for animation purpose;

  }

  void initialize() {
    successfullyFetched = false;
    countryPrevew = Loading.loading();
    strings = new Strings();
    sortBy = strings.countrySortBy;
    sortByWhat = sortBy[1];
    print("int: sortByWhat: $sortByWhat");
    print("int: sortBy: ${sortBy.toString()}");
    searchAndFilter = new SearchAndFilter(
      title:strings.language.statistics_page_title,
      countryData: _countryDatas,
      onSearch: onSearch,
      onFilter: onFilter,
      filterBy: sortBy,
      filterByWhat: sortByWhat,
    );

    _countryDataSharedPreference.addSubs(this);
    _globalDataSharedPreference.addSubs(this);

    _statsController = new StatisticsController(
        globalPref: _globalDataSharedPreference,
        countryPref: _countryDataSharedPreference,
      success: success,
      failure: failure
    );

    print("sort by is $sortByWhat");
      new Future.delayed(const Duration(milliseconds: 500),() async{
        _globalData = await _globalDataSharedPreference.getGlobalData();
        _countryDatas = await _countryDataSharedPreference.getCountryDatas();
        String temp = await _sortbySharedPreference.getSortBy();
        if(temp ==null){searchAndFilter.setSortByWhat(sortBy, sortByWhat);}
        else {
          sortByWhat = temp;
        }

        if(_globalData!=null){
          updateWorldSituation(_globalData);
        }

        if( _countryDatas!=null &&_countryDatas.length!=0){
           _selectedCountryList = (_countryDatas.take(desired_selected_number_of_country).toList());
           onFilter();
        }

        _statsController.getCountriesStats();
        _statsController.getGlobalStats();

        print("after future sort by is $sortByWhat");

      });

      // createCountryData();
  }




  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  Widget _buildCountriesList(List<CountryData> countries){
    ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: ClampingScrollPhysics(),
      itemCount: countries.length,
      itemBuilder: (context, index) {
        CountryData countryData = countries[index];
        return Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            alignment: Alignment.topCenter,
            child: CountriesWidgets.buildStatContainer(countryData, strings)
        );
      },
    );
  }
  void _onRefresh() async{
    _statsController.getGlobalStats();
    _statsController.getCountriesStats();
  }

  void _onLoading() async{
  }

  void failure() async{
    print("failure");
    if(!successfullyFetched){
      showConnectionError();
    }
    if(_refreshController.isRefresh)
    _refreshController.refreshFailed();
  }
  void success() async{
    print("success");
    successfullyFetched = true;
    if(_refreshController.isRefresh)
      _refreshController.refreshCompleted();
  }

  void checkIfConnection(ConnectivityResult result) async{
    switch(result){
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        //show toastt connected
    if(!successfullyFetched){
      showConnected();
    }

      print("connection");
        _statsController.getGlobalStats();
        _statsController.getCountriesStats();

        break;
      case ConnectivityResult.none:
        //show toast not connected
        print("noconnection");
        if(!successfullyFetched){
          showConnectionError();
        }
        break;
    }


  }

  void showConnected() async{
    setState(() {_loading = Loading.loading(text: "loading please wait ...");});
  }


  void showConnectionError()async{
    setState(() {_loading = Loading.loading(text: "waiting for network ...");});
  }







  @override
  Widget build(BuildContext context) {
    print("on build selected sortby $sortByWhat");
    return Scaffold(
        backgroundColor: Colors.white,
        body:
        Stack(
          children: <Widget>[
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo)  {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent
                ) {
                  if(!isSearchOpen&&!(_countryDatas!=null &&_countryDatas.length > _selectedCountryList.length)){
                    setState(() {isLoadingMore = false;});
                    _refreshController.loadNoData();
                    return true;
                  }
                  print("on groud");
                  Future.delayed(const Duration(seconds: 0),() async{
                    if(_countryDatas!=null && _countryDatas.length>0 && _selectedCountryList.length<_countryDatas.length)
                    {
                      print("country count : " + _countryDatas.length.toString()+ " but selected is "+_selectedCountryList.length.toString());

                      if(desired_selected_number_of_country+_selectedCountryList.length < _countryDatas.length )
                        _selectedCountryList.addAll(_countryDatas.sublist(_selectedCountryList.length, _selectedCountryList.length+desired_selected_number_of_country));
                      else
                        _selectedCountryList.addAll(_countryDatas.sublist(_selectedCountryList.length));

                      print("countries data: "+ _countryDatas.toString());
                      print("sub List starts from: "+ _selectedCountryList.toString());
                      print("prev List ends with: "+ showedCountries.last.toString());

                      setState(() {
                        showedCountries.addAll(_selectedCountryList.sublist(showedCountries.length));
                      });
                    }else{setState(() {isLoadingMore = false;});}
                  }
                  );

                }
                return true;
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                (searchAndFilter == null)?SizedBox(height: 1,):searchAndFilter,

              Expanded(
                  child:
                  (_globalCountryData!=null && _selectedCountryList!=null && _selectedCountryList.length>0 )?

                    SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      header: WaterDropHeader(),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      child:  ListView(
                children: <Widget>[
                    // StatisticsWidgets(globalData: _globalCountryData),
                    Padding(
                      padding:
                          const EdgeInsets.only(top:20,bottom: 30, left: 16, right: 16),
                      child: (isSearchOpen || _globalCountryData == null)
                          ? SizedBox(height: 0,)
                          : StatisticsWidgets(globalData: _globalCountryData),
                    ),
                  Padding(
                      padding:
                          const EdgeInsets.only(top:0,bottom: 30, left: 16, right: 16),
                      child: (isSearchOpen || _globalCountryData == null)
                          ? SizedBox(height: 0,)
                          : EthiopiaWidgets.buildStatContainer(_countryDatas.firstWhere((test){return test.title.toLowerCase() == "ethiopia";}), strings)
                    ),

                  (isSearchOpen || _globalCountryData == null)
                      ? SizedBox(height: 0,) :Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[_selectedFilter()]),

                  (showedCountries.length>0)?
                  ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ClampingScrollPhysics(),
                    itemCount: showedCountries.length,
                    itemBuilder: (context, index) {
                      CountryData countryData = showedCountries[index];
                      return Container(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          alignment: Alignment.topCenter,
                          child: CountriesWidgets.buildStatContainer(countryData, strings)
                      );
                    },
                  ): Center(child:Loading.loading()),
                ],
              ),
                  ):Loading.loading()),
              ]),
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
        ));
  }

  Widget _selectedFilter() {
    return InkWell(
      onTap: (){
        showDialog(
            context: context,
            builder: (BuildContext context) => StatisticSortDialog(title: strings.language.news_dialog_filter, okBtnText: strings.language.news_dialog_ok, sortBy: sortByWhat)
        ).whenComplete(() async{
          print("complete");
          String changed = await _sortbySharedPreference.getSortBy();
          if(changed!=sortByWhat) {
//               print("changed: "+changed + " filterbywhat: "+widget.filterByWhat);
            onFilter();
          }
        });
      },
      child: Container(
          margin: EdgeInsets.only(right: 10),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(colors: [
              Colors.white,
              Colors.white,
            ]),
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: AppTheme2.nearlyBlack.withOpacity(0.2),
                  offset: Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,

            children: <Widget>[
              Icon(
                Icons.sort,
                color: AppTheme2.nearlyDarkBlue,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  sortByWhat,
                  style: TextStyle(
                      fontSize: 10,
                      color: AppTheme2.nearlyBlack,
                      fontFamily: AppTheme2.fontName,
                      letterSpacing: 0.5),
                ),
              ),
            ],
          )),
    );
  }

  @override
  void onDataChange() async {
    _globalDataSharedPreference.getGlobalData().then((onValue) {
      print("onChange from SharedPref: " + onValue.toString());
      updateWorldSituation(onValue);
    });
    _countryDataSharedPreference.getCountryDatas().then((onValue) {
      print("countryDatas from shared pref "+onValue.toString());
      if(mounted)
      setState(() {
        _countryDatas = onValue;
        _selectedCountryList = _countryDatas.sublist(0, (_selectedCountryList.length == 0)? desired_selected_number_of_country: _selectedCountryList.length);
        onFilter();
      });
    });
  }

  void selectWhatToShow() {
    //print("called ${_selectedCountryList.toString()}");
    if (_selectedCountryList != null && _selectedCountryList.length != 0) {
     // print("1");
      if ((isSearchOpen))
        if(mounted)
          setState(() {
          showedCountries = searchedCountry;
        });
      else{
        if(mounted)
        setState(() {
          showedCountries = _selectedCountryList;
        });
      }
    } else {
      countryPrevew = Loading.loading();
    }
  }

  void updateWorldSituation(GlobalData onValue) {
    setState(() {
      _globalData = onValue;
      _globalCountryData = CountryData.fromJson(_globalData.toJson());
      _globalCountryData.title = strings.language.statistics_page_world;
    });
  }

  void updateCountriesSituation(List<CountryData> onValue) {
    _selectedCountryList = onValue;
    setState(() {
      showedCountries = _selectedCountryList;
    });
  }

  void onSearch(String searchText) async {
    if (searchText == null || searchText.length == 0) {
      setState(() {
        isSearchOpen = false;
        searchedCountry = _selectedCountryList;
        selectWhatToShow();
      });
    } else
      setState(() {
        isSearchOpen = true;
        searchedCountry = _countryDatas.where((test) {
          return test.title.toLowerCase().contains(searchText.toLowerCase());
        }).toList();
        selectWhatToShow();
      });
  }

  void onFilter() async{
    String sby = await _sortbySharedPreference.getSortBy();
    int index = strings.countrySortBy.indexOf(sby);
    print("static screen sortIndex = $index sortbywhat = $sortByWhat");

    if(sby == null) {
      if(!mounted) return;
      setState(() {
        showedCountries = _selectedCountryList;
      });
      return;
    }
    sortByWhat = sby;

    if(_selectedCountryList == null || _selectedCountryList.length == 0) return;
      //title
      if (index==0) {
        _countryDatas.sort((a, b) {
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        });
      }

      //total_cases
      else if (index==1) {
        _countryDatas.sort((a, b) {
          return a.total_cases.compareTo(b.total_cases) * -1;
        });
      }
    //total_active_cases_today
    if (index==2) {
    _countryDatas.sort((a, b) {
     // print("a: ${a.title}"+a.total_active_cases.toString() + " b: ${b.title}"+b.total_active_cases.toString());
     // print("returned: "+(a.total_active_cases.compareTo(b.total_active_cases) * -1).toString());
    return a.total_active_cases.compareTo(b.total_active_cases) * -1;
    });
    }
    //total serious cases
    if (index==3) {
      _countryDatas.sort((a, b) {
        return a.total_serious_cases.compareTo(b.total_serious_cases) * -1;
      });}

    //total_deaths
    if (index==4) {
     // print("hhhhh");
    _countryDatas.sort((a, b) {
     // print("a: ${a.title}"+a.total_new_deaths_today.toString() + " b: ${b.title}"+b.total_new_deaths_today.toString());
     // print("returned: "+(a.total_new_deaths_today.compareTo(b.total_new_deaths_today) * -1).toString());
      return a.total_new_deaths_today.compareTo(b.total_new_deaths_today) * -1;
    });
    }
      //total_recovered
      else if (index==5) {
        _countryDatas.sort((a, b) {
          return a.total_recovered.compareTo(b.total_recovered) * -1;
        });
      }
    //total_new_cases_tody
    if (index==6) {
    _countryDatas.sort((a, b) {
    return a.total_new_cases_today.compareTo(b.total_new_cases_today) *
    -1;
    });
    }
    //total_new_deaths_today
    if (index==7) {
    _countryDatas.sort((a, b) {
    return a.total_deaths.compareTo(b.total_deaths) *-1;
    });
    }

      //total_unresolved
      if (index==8) {
        _countryDatas.sort((a, b) {
          return a.total_unresolved.compareTo(b.total_unresolved) * -1;
        });
      }

    //print("coutnriesL ${_countryDatas.toString()}");
    _selectedCountryList = _countryDatas.sublist(0, _selectedCountryList.length);
    print(_countryDatas.toString());
    if(!mounted) return;
      setState(() {
            showedCountries = _selectedCountryList;
    });
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
                      adClosed = true;
                      showAd = false;
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

//title, total_cases,total_recovered,total_unresolved,total_deaths,total_new_cases_tody,total_new_deaths_today
//total_active_cases_today, total_serious_cases
