import 'dart:async';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:function_types/function_types.dart';
import 'package:khatam_quran/quran/events/change_language_event.dart';
import 'package:khatam_quran/quran/helpers/my_event_bus.dart';
import 'package:khatam_quran/quran/localizations/app_localizations.dart';
import 'package:khatam_quran/quran/screens/quran_list_screen.dart';
import 'package:khatam_quran/quran/background/background.dart';

class QuranScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QuranQuranScreenState();
  }
}

class _QuranQuranScreenState extends State<QuranScreen>
    with TickerProviderStateMixin {
  TabController tabController;

  double sliverAppBarChildrenHeight = 50;
  int currentTabBarChildren = 0;
  CustomTabBar customTabBar;

  TabController quranListTabController;
  int quranListCurrentTabIndex = 0;
  bool loadedQuranListScreen = false;

  StreamSubscription changeLocaleSubsciption;

  @override
  void initState() {
    tabController = TabController(
      vsync: this,
      length: 3,
    );
    tabController.addListener(() {
      void c() {
        sliverAppBarChildrenHeight =
            customTabBar.tabBarHeight[tabController.index];
        currentTabBarChildren = tabController.index;
      }

      if (tabController.indexIsChanging) {
        c();
      } else {
        c();
      }
      setState(() {});
    });

    quranListTabController = TabController(
      vsync: this,
      length: 3,
    );
    quranListTabController.addListener(() {
      if (quranListTabController.indexIsChanging) {
        setState(() {
          quranListCurrentTabIndex = quranListTabController.index;
        });
      }
    });

    changeLocaleSubsciption =
        MyEventBus.instance.eventBus.on<ChangeLanguageEvent>().listen(
      (v) async {
        // Refresh current
        setState(() {
          loadedQuranListScreen = true;
        });
        await Future.delayed(Duration(milliseconds: 400));
        setState(() {
          loadedQuranListScreen = false;
        });
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    tabController?.dispose();
    quranListTabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Background().buildImageBackground(),
        buildMain()
      ],
    );
  }

  Widget buildMain(){
    var tabBarChildrens = <Widget>[
      Container(
        height: 50,
        child: Container(
          child: Scaffold(
            body: TabBar(
              controller: quranListTabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BubbleTabIndicator(
                indicatorHeight: 40.0,
                indicatorColor: Color(4283326968),
                tabBarIndicatorSize: TabBarIndicatorSize.tab,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: <Widget>[
                Tab(
                  text: AppLocalizations.of(context).suraText,
                ),
                Tab(
                  text: AppLocalizations.of(context).juzText,
                ),Tab(
                  text: "Bookmark",
                ),
              ],
            ),
          ),
        ),
      ),
      Container(),
    ];

    return Container(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              flexibleSpace: FlexibleSpaceBar(
                background:
                Padding(
                    padding: EdgeInsets.only(left: 50, right: 50, top: 75),
                    child: buildTitle()
                ),
              ),
              expandedHeight: 300,
              backgroundColor: Colors.white10,
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(sliverAppBarChildrenHeight),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      tabBarChildrens[currentTabBarChildren],
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: <Widget>[
            loadedQuranListScreen == false
                ? QuranListScreen(
              currentTabIndex: quranListCurrentTabIndex,
            )
                : Container()
          ],
        ),
      ),
    );
  }
}

Widget buildTitle() {
  return new Column(
    children: <Widget>[
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Khatam Alquran',
          style: new TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 5.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Daftar Aktifitas Selesai',
            style: new TextStyle(
                color: Color(4283326968),
                fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ],
  );
}

class CustomTabBar {
  List<Widget> tabBar;
  Func0<List<Widget>> tabBarChildrens;
  List<double> tabBarHeight;
  CustomTabBar({
    @required this.tabBarChildrens,
    @required this.tabBar,
    @required this.tabBarHeight,
  });
}
