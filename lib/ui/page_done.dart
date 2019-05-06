import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khatam_quran/model/element.dart';
import 'package:khatam_quran/quran/background/background.dart';
import 'package:khatam_quran/ui/page_detail.dart';

class DonePage extends StatefulWidget {
  final FirebaseUser user;

  DonePage({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DonePageState();
}

class _DonePageState extends State<DonePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        Background().buildImageBackground(),
        ListView(
          children: <Widget>[
            buildTitle(),
            buildAddTaskButton(),
            buildList(),
          ],
        )
      ],
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: EdgeInsets.all(50),
      child:
      Column(
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
          Align(
            alignment: Alignment.centerLeft,
            child: Background().buildPrivacyPolicy(),
          )
        ],
      ),
    );
  }

  Widget buildList() {
    return Padding(
      padding: EdgeInsets.only(top: 50.0),
      child: Container(
        height: 360.0,
        padding: EdgeInsets.only(bottom: 25.0),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
          },
          child: buildActualList(),
        ),
      ),
    );
  }

  Widget buildActualList(){
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection(widget.user.uid).orderBy("date", descending: true)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {

          if (!snapshot.hasData)
            return _getLoading();

          if (isEmpty(snapshot)) {
            return _getEmpty();
          }

          return new ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(left: 40.0, right: 40.0),
            scrollDirection: Axis.horizontal,
            children: getExpenseItems(snapshot),
          );
        });
  }

  bool isEmpty(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<ElementTask> listElement = new List();
    snapshot.data.documents.map<List>((f) {
      f.data.forEach((a, b) {
        if (b.runtimeType == bool && b == true) {
          listElement.add(new ElementTask(a, b));
        }
      });
    }).toList();
    return listElement.length == 0;
  }

  Widget buildAddTaskButton() {
    return new Column(
      children: <Widget>[
        new Container(
          width: 80.0,
          height: 80.0,
          decoration: new BoxDecoration(
            color: Color(4279814837),
            shape: BoxShape.circle,
          ),
          child: new IconButton(
            icon: new Icon(Icons.check, color: Colors.white),
            iconSize: 50.0,
          ),
        )
        ,
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<ElementTask> listElement = new List(), listElement2;
    Map<String, List<ElementTask>> userMap = new Map();

    List<String> cardColor = new List();
    if (widget.user.uid.isNotEmpty) {
      cardColor.clear();

      snapshot.data.documents.map<List>((f) {
        f.data.forEach((a, b) {
          if (b.runtimeType == bool) {
            listElement.add(new ElementTask(a, b));
          }
          if (b.runtimeType == String && a == "color") {
            cardColor.add(b);
          }
        });
        listElement2 = new List<ElementTask>.from(listElement);
        userMap[f.documentID] = listElement2;

        for (int i = 0; i < listElement2.length; i++) {
          if (listElement2.elementAt(i).isDone == false) {
            userMap.remove(f.documentID);
            if (cardColor.isNotEmpty) {
              cardColor.removeLast();
            }

            break;
          }
        }
        if (listElement2.length == 0) {
          userMap.remove(f.documentID);
          cardColor.removeLast();
        }
        listElement.clear();
      }).toList();

      return new List.generate(userMap.length, (int index) {
        return new GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              new PageRouteBuilder(
                pageBuilder: (_, __, ___) => new DetailPage(
                      user: widget.user,
                      i: index,
                      currentList: userMap,
                      color: cardColor.elementAt(index),
                    ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        new ScaleTransition(
                          scale: new Tween<double>(
                            begin: 1.5,
                            end: 1.0,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Interval(
                                0.50,
                                1.00,
                                curve: Curves.linear,
                              ),
                            ),
                          ),
                          child: ScaleTransition(
                            scale: Tween<double>(
                              begin: 0.0,
                              end: 1.0,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Interval(
                                  0.00,
                                  0.50,
                                  curve: Curves.linear,
                                ),
                              ),
                            ),
                            child: child,
                          ),
                        ),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            color: Color(int.parse(cardColor.elementAt(index))),
            child: new Container(
              width: 220.0,
              //height: 100.0,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 15.0),
                      child: Container(
                        child: Text(
                          userMap.keys.elementAt(index),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: EdgeInsets.only(left: 50.0),
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 30.0, left: 15.0, right: 5.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 220.0,
                            child: ListView.builder(
                                //physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    userMap.values.elementAt(index).length,
                                itemBuilder: (BuildContext ctxt, int i) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        userMap.values
                                                .elementAt(index)
                                                .elementAt(i)
                                                .isDone
                                            ? FontAwesomeIcons.checkCircle
                                            : FontAwesomeIcons.circle,
                                        color: userMap.values
                                                .elementAt(index)
                                                .elementAt(i)
                                                .isDone
                                            ? Colors.white70
                                            : Colors.white,
                                        size: 14.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                      ),
                                      Flexible(
                                        child: Text(
                                          userMap.values
                                              .elementAt(index)
                                              .elementAt(i)
                                              .name,
                                          style: userMap.values
                                                  .elementAt(index)
                                                  .elementAt(i)
                                                  .isDone
                                              ? TextStyle(
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  color: Colors.white70,
                                                  fontSize: 17.0,
                                                )
                                              : TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17.0,
                                                ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    }
  }

  Widget _getLoading() {
    return new Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.blue,
        ));
  }

  Widget _getEmpty() {
    return new Padding(
      padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
      child:
      new Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        new Container(
          height: 50,
          alignment: Alignment.topCenter,
          decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage("assets/images/quran.png"),
                fit: BoxFit.contain
            ),
          ),
          child: null /* add child content here */,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Align(
            alignment: Alignment.topCenter,
            child: new Text("Belum ada target yang tercapai",
                style: TextStyle(fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: new Text("Cek target harianmu sekarang",
              style: TextStyle(fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
        ),
      ])
    );
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
