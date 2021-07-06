import 'package:ethiocare/app_theme.dart';
import 'package:ethiocare/app_theme2.dart';
import 'package:ethiocare/languages/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer(
      {Key key,
      this.screenIndex,
      this.iconAnimationController,
      this.callBackIndex})
      : super(key: key);

  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  double screenHeight, screenWidth;
  Strings strings;
  List<DrawerList> drawerList;
  @override
  void initState() {
    strings = new Strings();
    setdDrawerListArray();
    super.initState();
  }

  void setdDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.Tracker,
        labelName: strings.language.nav_tracker,
        icon: Icon(Icons.person_outline),
      ),
       DrawerList(
        index: DrawerIndex.News,
        labelName:  strings.language.nav_news,
        icon: Icon(Icons.new_releases),
      ),
      DrawerList(
        index: DrawerIndex.Statistics,
        labelName:  strings.language.nav_statistics,
        icon: Icon(Icons.data_usage)
      ),
      DrawerList(
        index: DrawerIndex.AboutCorona,
        labelName:  strings.language.nav_about_corona,
        icon: Icon(Icons.blur_circular)
      ),
      DrawerList(
        index: DrawerIndex.PhoneNumbers,
        labelName: strings.language.phone_numbers,
        icon: Icon(Icons.phone)
      ),
      // DrawerList(
      //   index: DrawerIndex.FeedBack,
      //   labelName: 'FeedBack',
      //   icon: Icon(Icons.chat_bubble_outline),
      // ),
      DrawerList(
        index: DrawerIndex.Invite,
        labelName: strings.language.nav_invite_friend,
        icon: Icon(Icons.people_outline),
      ),
//       DrawerList(
//         index: DrawerIndex.Share,
//         labelName: 'Take a test',
//         icon: Icon(Icons.star_border),
//       ),
      DrawerList(
        index: DrawerIndex.About,
        labelName: strings.language.nav_developers,
        icon: Icon(Icons.info_outline),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,//AppTheme.notWhite.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50.0),//was 40
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return ScaleTransition(
                        scale: AlwaysStoppedAnimation<double>(
                            1.0 - (widget.iconAnimationController.value) * 0.2),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation<double>(Tween<double>(
                                      begin: 0.0, end: 24.0)
                                  .animate(CurvedAnimation(
                                      parent: widget.iconAnimationController,
                                      curve: Curves.fastOutSlowIn))
                                  .value /
                              360),
                          child: Container(
                            height: 80,
                            width: 80,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50)),
                              child: Image.asset('assets/images/appicon2.png'),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 4),
                    child:

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    Text(
                     strings.language.nav_title,
                        textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: AppTheme2.fontName,
                        fontWeight: FontWeight.bold,
                        color:Colors.black,
                        letterSpacing: 0,
                        fontSize: 20,
                      )),
                        SizedBox(height:2),
//                        Text(
//                             strings.language.nav_sub_title,
//                            textAlign: TextAlign.start,
//                            style: TextStyle(
//                                fontFamily: AppTheme2.fontName,
//                                fontWeight: FontWeight.bold,
//                                color: Colors.grey[900],
//                                letterSpacing: 0.2,
//                                fontSize: 16
//                            )
//                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Divider(
            height: 1,
            color: Colors.grey[800].withOpacity(0.6),
          ),
          const SizedBox(
            height: 2,
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList[index]);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.blue[800].withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 36.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName,
                              color: widget.screenIndex == listData.index
                                  ? Colors.blue[900]
                                  : AppTheme.nearlyWhite),
                        )
                      : Icon(listData.icon.icon,
                          color: widget.screenIndex == listData.index
                              ? Colors.blue[900]
                              : Colors.black,
                    size: widget.screenIndex == listData.index
                        ? 28.0
                        : 24.0,


                  ),
                  const Padding(
                    padding: EdgeInsets.all(6.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontSize: widget.screenIndex == listData.index
                          ? 18
                          : 16,
                      color: widget.screenIndex == listData.index
                          ? Colors.blue[900]
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.left,

                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) *
                                (1.0 -
                                    widget.iconAnimationController.value -
                                    1.0),
                            0.0,
                            0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.blue[900].withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }
}

enum DrawerIndex {
  Tracker,
  News,
  Statistics,
  AboutCorona,
  FeedBack,
  Help,
  Share,
  About,
  Invite,
  Testing,
  PhoneNumbers,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}
