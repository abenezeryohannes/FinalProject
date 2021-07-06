import 'package:ethiocare/model/info_category.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';

class InfoCategorySelector extends StatefulWidget {
  final List<InfoCategory> infoCats;
  final Size size;
 
  final Function(InfoCategory category) notifyParent;
 
  InfoCategorySelector({@required this.notifyParent, this.infoCats, this.size });

  @override
  _InfoCategorySelectorState createState() => _InfoCategorySelectorState();
}

class _InfoCategorySelectorState extends State<InfoCategorySelector> {
  int _currentIndex = 0;
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _tabController = new TabController(length: widget.infoCats.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(length: widget.infoCats.length,
      

      
      child: TabBar(tabs: _buildTabInfoCategories(),
          controller: _tabController,
          isScrollable: true,
          labelColor: AppTheme.nearlyBlack,
          unselectedLabelColor: Colors.grey,
          indicatorWeight: 0.1,
          onTap: (key){
            setState(() {
            _currentIndex =  key;
             widget.notifyParent(widget.infoCats[_currentIndex]);// DefaultTabController.of(context).index;
            });
          },

      )
    
    );

  }

  List<Widget> _buildTabInfoCategories(){
    return widget.infoCats.map((cat){
      var index = widget.infoCats.indexOf(cat);
      return Tab(child: Text(cat.title,

      style: TextStyle(fontSize: (_currentIndex == index)? 20/MediaQuery.of(context).textScaleFactor : 16/MediaQuery.of(context).textScaleFactor)
      ),);
    }).toList();
  }


}



