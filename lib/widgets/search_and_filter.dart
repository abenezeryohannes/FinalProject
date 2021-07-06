
import 'dart:core';

import 'package:ethiocare/languages/strings.dart';
import 'package:ethiocare/model/country_data.dart';
import 'package:ethiocare/shared_preference/sort_and_filter_by_shared_preference.dart';
import 'package:ethiocare/widgets/statistic_sort_dialog.dart';
import 'package:flutter/material.dart';

import '../app_theme2.dart';

class SearchAndFilter extends StatefulWidget {
  final List<CountryData> countryData;
  final Function onSearch;
  final Function onFilter;
  String title;
  List<String> filterBy;
  String filterByWhat;

  SearchAndFilter({@required this.title, @required this.countryData, 
  this.onSearch, this.onFilter, this.filterBy, this.filterByWhat});

  void setTitle(String title){
    this.title = title;
  }


  @override
  _SearchAndFilterState createState() => _SearchAndFilterState();

  void setSortByWhat(List<String> sortBy, String sortByWhat) {
    this.filterBy = sortBy;
    this.filterByWhat = sortByWhat;
  }

}

class _SearchAndFilterState extends State<SearchAndFilter> {
 //for search bar
  Widget _isSearchOpen;int selectedFilterIndex =-1;
  Strings strings  = new Strings();

  SortAndFilterbySharedPreference _sortbySharedPreference = new SortAndFilterbySharedPreference();

  final TextEditingController _filter = new TextEditingController();// for http requests
  String _searchText = "";// names we get from API
  List<CountryData> filteredNames = new List(); // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search); 

  

  @override
  Widget build(BuildContext context) {
   _isSearchOpen = onSearchCollapsed();
    return _title();
  }



  Widget _title(){
    return Padding(
      padding: EdgeInsets.only(left:50),
                child: SizedBox(
        height: AppBar().preferredSize.height,
        child: Row(
          children: <Widget>[

               (this._searchIcon.icon != Icons.search)?onSearchExpanded():onSearchCollapsed(),
              InkWell(
                child:Padding(
                  padding: const EdgeInsets.only(left: 10.0, right:10, top:10, bottom: 10),
                  child: _searchIcon,
                ),
                onTap: (){_searchPressed();},
                ),


            ])),
    );

  }



  Widget onSearchExpanded(){
    
    return Expanded(
                child: new TextField(
                controller: _filter,
                decoration: new InputDecoration(
                prefixIcon: new Icon(Icons.search),
                hintText: 'Search...'
              ),
            ),
    );
  }

  Widget onSearchCollapsed(){
  return  Expanded(
        child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Expanded(
        flex: 8,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              widget.title,
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
//      Expanded(
//        flex: 1,
//
//        child: InkWell(
//          child:Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Icon(Icons.sort, size: 24,),
//          ),
//          onTap: (){
//
////           if(widget.filterBy!=null)
////           Navigator.push(context, MaterialPageRoute(builder: (context) => Page2()))
////               .then((string) {
//
//// });
//            print("filter pressed");
//           onFilterPressed();
////            showFilterDialog(context,
////          title: "Sort by",
////          cancelBtnText: "Cancel",
////          filterBy: widget.filterBy,
////          );
//          },
//          ),
//      )
      
      ],), );
  }



        void _searchPressed() {
            setState(() {
              if (this._searchIcon.icon == Icons.search) {
                this._searchIcon = new Icon(Icons.close);
                _isSearchOpen = onSearchExpanded();
            
                listenToTextInputInSearch();
              } else {
                this._searchIcon = new Icon(Icons.search);
                // filteredNames = names;
                _isSearchOpen = onSearchCollapsed();
                _filter.clear();
              }
            });
          }


          void listenToTextInputInSearch() {
              _filter.addListener(() {
                if (_filter.text.isEmpty) {
                  setState(() {
                    _searchText = "";
                    widget.onSearch(null);
                  });
                } else {
                  setState(() {
                    widget.onSearch(_filter.text);
                  });
                }
              });
            }

  void onFilterPressed() {
    showDialog(
        context: context,
        builder: (BuildContext context) => StatisticSortDialog(title: "Filter by", okBtnText: "Ok", sortBy: widget.filterByWhat,)
    ).whenComplete(() async{
      print("complete");
      String changed = await _sortbySharedPreference.getSortBy();
      if(changed!=widget.filterByWhat) {
//               print("changed: "+changed + " filterbywhat: "+widget.filterByWhat);
        widget.onFilter();
      }
    });
  }



  
}