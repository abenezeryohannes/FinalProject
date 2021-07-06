import 'package:ethiocare/app_theme2.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  static DialogUtils _instance = new DialogUtils.internal();

  DialogUtils.internal();
  static int selectedIndex;

  factory DialogUtils() => _instance;

  static void showFilterDialog(BuildContext context,
      {@required String title,
      List<String> filterBy,
      String okBtnText = "Ok",
      String cancelBtnText = "Cancel",
      @required Function okBtnFunction}) {
        if(!filterBy.last.toLowerCase().endsWith("none"))
            filterBy.add("none");
    selectedIndex = filterBy.length - 1;
    print(filterBy.toList().toString());
    
   showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(title),
            content: _prepareTheList(filterBy, okBtnFunction, context),
            /* Here add your custom widget  */
            actions: <Widget>[
              FlatButton(
                child: Text(okBtnText),
                onPressed: okBtnFunction(filterBy[selectedIndex]),
              ),
              FlatButton(
                  child: Text(cancelBtnText),
                  onPressed: () => Navigator.pop(context))
            ],
          );
        }).then((onValue){print(onValue);});
  }

  static Widget _prepareTheList(
      List<String> filterBy, Function okBtnFunction, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: filterBy.map((f) {
          if (filterBy.indexOf(f) == filterBy.length - 1)
            return SizedBox(
              height: 0,
            );
          return FlatButton(
            onPressed: () {
              selectedIndex = filterBy.indexOf(f);
              Navigator.pop(context);
              okBtnFunction(filterBy[selectedIndex]);
            },
            color: AppTheme2.nearlyWhite,
            child: Container(
              width: 300,
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child:
                  Text(f[0].toUpperCase() + f.replaceAll("_", ' ').substring(1),
                      style: TextStyle(
                        fontFamily: AppTheme2.fontName,
                        fontSize: 16,
                      )),
            ),
          );
        }).toList(),
      ),
    );
  }
}
