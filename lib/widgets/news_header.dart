import 'package:ethiocare/languages/strings.dart';
import 'package:ethiocare/shared_preference/setting_shared_preference.dart';
import 'package:ethiocare/shared_preference/sort_and_filter_by_shared_preference.dart';
import 'package:ethiocare/widgets/news_filter_dialog.dart';
import 'package:flutter/material.dart';

import '../app_theme2.dart';

class NewsHeader extends StatefulWidget {
  final Function onFilter;

  NewsHeader({@required this.onFilter});

  @override
  _NewsHeaderState createState() => _NewsHeaderState();
}

class _NewsHeaderState extends State<NewsHeader> {
  SettingSharedPreference setting = new SettingSharedPreference();
  SortAndFilterbySharedPreference filter = new SortAndFilterbySharedPreference();
  String filterBy = "ethiopia";double isTitleKnown = 0;
  Widget header;Strings strings;


  @override
  void initState() {
    strings = new Strings();
    filterBy  = "ethiopia"; isTitleKnown = 0;
    header = _title();
    loadFilterBy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return header;
  }




  Widget _title(){
    return Container(
      padding: EdgeInsets.only(left:50),
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
                        opacity: isTitleKnown,
                        child: Text(
                          strings.language.news_title,
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
//                InkWell(
//                  child: Padding(
//                    padding: const EdgeInsets.all(5.0),
//                    child: Icon(Icons.filter_list, size: 24.0, color: Colors.grey[800],),
//                  ),
//                  onTap: (){_filterPressed();},
//                ),
                SizedBox(width: 40,)


              ])),
    );

  }

  void _filterPressed() {
    print("filter pressed");
    showDialog(
        context: context,
        builder: (BuildContext context) => NewsFilterDialog(title: "Sort by", okBtnText: "Ok", cancelBtnText: "Cancel")
    ).whenComplete(() async{
      print("complete");
      widget.onFilter();
    });
  }

  void loadFilterBy() {
   filter.getFilterBy().then((value){
     if(value==null) filterBy = "ethiopia";
     else filterBy = value;

     setState(() {
       isTitleKnown = 1;
       header = _title();
     });
   });


  }

}
