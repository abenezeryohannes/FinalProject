import 'package:ethiocare/Controllers/news_controller.dart';
import 'package:ethiocare/app_theme2.dart';
import 'package:ethiocare/model/country_data.dart';
import 'package:ethiocare/shared_preference/change_subscriber.dart';
import 'package:ethiocare/shared_preference/country_data_shared_preference.dart';
import 'package:ethiocare/shared_preference/sort_and_filter_by_shared_preference.dart';
import 'package:flutter/material.dart';

import 'loading.dart';
class NewsFilterDialog extends StatelessWidget {
  final String title, cancelBtnText, okBtnText;
   FilterByThis _ff = FilterByThis();
  NewsFilterDialog({@required this.title,this.cancelBtnText, this.okBtnText});

  @override
  Widget build(BuildContext context) {
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























class FilterByThis extends StatefulWidget {
  String filter;

  void save(){

    SortAndFilterbySharedPreference sf = new SortAndFilterbySharedPreference();
    sf.savefilterBy(filter);
  }
  @override
  _FilterByThisState createState() => _FilterByThisState();
}

class _FilterByThisState extends State<FilterByThis> implements ChangeSubscriber {
  List<CountryData> countries;
  String filter;  CountryDataSharedPreference cpf;
  Widget loading = Loading.loading();



  @override
  void initState() {
     runInit();
    super.initState();
  }

  void runInit() async{
    filter = await SortAndFilterbySharedPreference().getFilterBy();
    widget.filter = filter;
    cpf = new CountryDataSharedPreference();cpf.addSubs(this);
    print("filter by in dialog: "+filter.toString());
    if(filter==null) filter = "ethiopia";

    cpf.getCountryDatas().then((countries){
      setState(() {
        this.countries = countries;
      });
    });
    if(countries == null || countries.length == 0){print("countries is not null");}


    new NewsController(onLoadingError: onLoadingError).getCountries(cpf);

  }

  void onLoadingError(){
    loading = Loading.loadingErrorWithRetry(callback: onRetry);
  }
  void onRetry(){
    runInit();
    setState(() => loading = Loading.loading());
  }



  @override
  Widget build(BuildContext context) {
    return (countries == null || countries.length == 0)?
    Center(child: loading)
    :
        ListView.builder(
          padding: EdgeInsets.only(top:20, bottom:20),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: countries.length,
          itemBuilder: (context, index){
           return _buildListItem(index);
          },
        );
  }

  Widget _buildListItem(int index){
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
        elevation: 0.0,
      color: (countries[index].title.toLowerCase() == filter.toLowerCase())? Colors.blue[800]: Colors.white,
      child: InkWell(
          child: Padding(
            padding: const EdgeInsets.only(top:10, bottom:10, left:10),
            child: Text(countries[index].title, style: TextStyle(
              fontFamily: AppTheme2.fontName,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              letterSpacing: 0.18,
              color: (countries[index].title.toLowerCase() == filter.toLowerCase())? Colors.white: Colors.grey[800],
            )
            ),
          ),
          onTap: (){ setState(() {
            setState(() {
              filter = countries[index].title.toLowerCase();
              widget.filter = filter;
            });
          });},
      )
    );
  }

  @override
  void onDataChange() async{
    List<CountryData> temp = await cpf.getCountryDatas();
    setState(() {
      countries = temp;
    });
  }

}

