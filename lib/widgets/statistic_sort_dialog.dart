import 'package:ethiocare/app_theme2.dart';
import 'package:ethiocare/shared_preference/sort_and_filter_by_shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:ethiocare/languages/strings.dart';


class StatisticSortDialog extends StatelessWidget {
  final String title, okBtnText;
  final String sortBy;
  StatisticSortDialog({@required this.title,this.okBtnText, this.sortBy});

  @override
  Widget build(BuildContext context) {
    SortByThis _ff = SortByThis(sortBy: this.sortBy);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 10.0,
      backgroundColor: Colors.white,
      child: Container(
          height: (MediaQuery.of(context).size.width*3)/2,
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:10.0, top:10.0),
                    child: Text(title, style: AppTheme2.headline,),
                  ),
                ],
              ),
              Expanded(child: _ff),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom:8.0),
                    child: FlatButton(
                        child: Text(okBtnText, style:AppTheme2.title),
                        onPressed: () {
                          _ff.save();
                          Navigator.pop(context);
                        }),
                  ),
                ],
              )
            ],
          )
      ),
    );
  }
}























class SortByThis extends StatefulWidget {
  String sortBy;
  SortByThis({this.sortBy});

  void save(){
    SortAndFilterbySharedPreference sf = new SortAndFilterbySharedPreference();
    sf.saveSortBy(sortBy);
    print("saved sortBy as: "+ sortBy);
  }
  @override
  _SortByThisState createState() => _SortByThisState();
}

class _SortByThisState extends State<SortByThis> {
  Strings strings;


  @override
  void initState() {
    strings = new Strings();
//    print("at start "+widget.sortBy);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return
    ListView.builder(
      padding: EdgeInsets.only(top:20, bottom:20),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: strings.countrySortBy.length-1,
      itemBuilder: (context, index){
        return _buildListItem(index);
      },
    );
  }


  Widget _buildListItem(int index){
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
        elevation: 0.0,
        color: (index == strings.countrySortBy.indexOf(widget.sortBy))? Colors.blue[800]: Colors.white,
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.only(top:10, bottom:10, left:10),
            child: Text(strings.countrySortBy[index], style: TextStyle(
              fontFamily: AppTheme2.fontName,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              letterSpacing: 0.18,
              color: (index == strings.countrySortBy.indexOf(widget.sortBy))? Colors.white: Colors.grey[800],
            )
            ),
          ),
          onTap: (){ setState(() {
            setState(() {
              widget.sortBy = strings.countrySortBy[index];
            });
          });},
        )
    );
  }
}


