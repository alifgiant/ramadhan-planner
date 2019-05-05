import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khatam_quran/model/element.dart';

class DetailPage extends StatefulWidget {
  final FirebaseUser user;
  final int i;
  final Map<String, List<ElementTask>> currentList;
  final String color;

  DetailPage({Key key, this.user, this.i, this.currentList, this.color})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController itemController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: new Stack(
        children: <Widget>[
          _buildBackground(),
          _getToolbar(context),
          _buildBody(),
        ],
      ),
      floatingActionButton: buildAddTaskButton(),
    );
  }

  Widget _buildBackground(){
    return Container(
      color: currentColor,
      height: 250,
      width: double.infinity,
    );
  }

  Widget buildAddTaskButton() {
    return new Container(
      alignment: Alignment.center,
      width: 70.0,
      height: 70.0,
      decoration: new BoxDecoration(
          color: Color(4283326968),
          border: new Border.all(color: Color(4283326968)),
          borderRadius: BorderRadius.all(Radius.circular(7.0))
      ),
      child: new IconButton(
        icon: new Icon(Icons.add, color: Colors.white),
        iconSize: 50.0,
        onPressed: _addActivityPressed,
      ),
    );
  }

  void _addActivityPressed(){

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: <Widget>[
              Expanded(
                child: new TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: currentColor)),
                      labelText: "Aktifitas Baru",
                      hintText: "Nama",
                      contentPadding: EdgeInsets.only(
                          left: 16.0,
                          top: 20.0,
                          right: 16.0,
                          bottom: 5.0)),
                  controller: itemController,
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                ),
              )
            ],
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: RaisedButton(
                elevation: 3.0,
                onPressed: () {
                  if (itemController.text.isNotEmpty &&
                      !widget.currentList.values
                          .contains(itemController.text.toString())) {
                    Firestore.instance
                        .collection(widget.user.uid)
                        .document(
                        widget.currentList.keys.elementAt(widget.i))
                        .updateData(
                        {itemController.text.toString(): false});

                    itemController.clear();
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Tambahkan'),
                color: currentColor,
                textColor: const Color(0xffffffff),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildBody(){
    return Container(
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: new StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection(widget.user.uid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return new Center(
                    child: CircularProgressIndicator(
                      backgroundColor: currentColor,
                    ));
              return new Container(
                child: getExpenseItems(snapshot),
              );
            }),
      ),
    );
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<ElementTask> listElement = new List();
    int nbIsDone = 0;

    if (widget.user.uid.isNotEmpty) {
      snapshot.data.documents.map<Column>((f) {
        if (f.documentID == widget.currentList.keys.elementAt(widget.i)) {
          f.data.forEach((a, b) {
            if (b.runtimeType == bool) {
              listElement.add(new ElementTask(a, b));
            }
          });
        }
      }).toList();

      listElement.forEach((i) {
        if (i.isDone) {
          nbIsDone++;
        }
      });

      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 120.0),
            child: new Column(
              children: <Widget>[
                getTaskDetailDeleteTitle(),
                getTaskDetailLineSeparator(),
                _buildColorChangerButton(),
                getTaskDetailTitle(nbIsDone,listElement),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Column(
                    children: <Widget>[
                      Container(color: Colors.white,child:
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 350,
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: listElement.length,
                            itemBuilder: (BuildContext ctxt, int i) {
                              return new Slidable(
                                delegate: new SlidableBehindDelegate(),
                                actionExtentRatio: 0.25,
                                child: GestureDetector(
                                  onTap: () {
                                    Firestore.instance
                                        .collection(widget.user.uid)
                                        .document(widget.currentList.keys
                                            .elementAt(widget.i))
                                        .updateData({
                                      listElement.elementAt(i).name:
                                          !listElement.elementAt(i).isDone
                                    });
                                  },
                                  child: Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 50.0, top: 10, right: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            listElement.elementAt(i).isDone
                                                ? FontAwesomeIcons.checkSquare
                                                : FontAwesomeIcons.square,
                                            color: listElement
                                                    .elementAt(i)
                                                    .isDone
                                                ? currentColor
                                                : Colors.black,
                                            size: 20.0,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 30.0),
                                          ),
                                          Flexible(
                                            child: Text(
                                              listElement.elementAt(i).name,
                                              style: listElement
                                                      .elementAt(i)
                                                      .isDone
                                                  ? TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: currentColor,
                                                      fontSize: 27.0,
                                                    )
                                                  : TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 27.0,
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                secondaryActions: <Widget>[
                                  new IconSlideAction(
                                    caption: 'Delete',
                                    color: Colors.red,
                                    icon: Icons.delete,
                                    onTap: () {
                                        Firestore.instance
                                            .collection(widget.user.uid)
                                            .document(widget.currentList.keys
                                            .elementAt(widget.i))
                                            .updateData({
                                          listElement.elementAt(i).name:
                                          ""
                                        });
                                    },
                                  ),
                                ],
                              );
                            }),
                      ),),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    pickerColor = Color(int.parse(widget.color));
    currentColor = Color(int.parse(widget.color));
  }

  Color pickerColor;
  Color currentColor;

  ValueChanged<Color> onColorChanged;

  changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Padding _getToolbar(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.only(top: 50.0, right: 20),
      child:
          Container(
            alignment: Alignment.topRight,
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: new Icon(
                Icons.close,
                size: 40.0,
                color: Colors.white,
              ),
            ),
          )
    );
  }

  Widget getTaskDetailDeleteTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, left: 50.0, right: 28.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              widget.currentList.keys.elementAt(widget.i),
              softWrap: true,
              overflow: TextOverflow.fade,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 35.0, color: Colors.white),
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return new AlertDialog(
                    title: Text("Hapus: " + widget.currentList.keys.elementAt(widget.i).toString()),
                    content: Text(
                      "Kamu yakin ingin menghapus aktifitas ini ?", style: TextStyle(fontWeight: FontWeight.w400),),
                    actions: <Widget>[
                      ButtonTheme(
                        //minWidth: double.infinity,
                        child: RaisedButton(
                          elevation: 3.0,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Tidak'),
                          color: currentColor,
                          textColor: const Color(0xffffffff),
                        ),
                      ),
                      ButtonTheme(
                        //minWidth: double.infinity,
                        child: RaisedButton(
                          elevation: 3.0,
                          onPressed: () {
                            Firestore.instance
                                .collection(widget.user.uid)
                                .document(widget.currentList.keys
                                .elementAt(widget.i))
                                .delete();
                            Navigator.pop(context);
                            Navigator.of(context).pop();
                          },
                          child: Text('Ya'),
                          color: currentColor,
                          textColor: const Color(0xffffffff),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Icon(
              FontAwesomeIcons.trash,
              size: 25.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorChangerButton(){
    return Container(
      padding: EdgeInsets.only(left: 50, top: 10),
      alignment: Alignment.topLeft,
      child: RaisedButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.white, width: 2)),
        child: Text('Ganti warna'),
        color: currentColor,
        textColor: const Color(0xffffffff),
        elevation: 3.0,
        onPressed: () {
          pickerColor = currentColor;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Pilih warna!'),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: pickerColor,
                    onColorChanged: changeColor,
                    enableLabel: true,
                    colorPickerWidth: 1000.0,
                    pickerAreaHeightPercent: 0.7,
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {

                      Firestore.instance
                          .collection(widget.user.uid)
                          .document(
                          widget.currentList.keys.elementAt(widget.i))
                          .updateData(
                          {"color": pickerColor.value.toString()});

                      setState(
                              () => currentColor = pickerColor);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget getTaskDetailTitle(int nbIsDone, List<ElementTask> listElement) {
    return Padding(
      padding: EdgeInsets.only(top: 50.0, left: 50.0),
      child: Row(
        children: <Widget>[
          new Text(
            nbIsDone.toString() +
                " dari " +
                listElement.length.toString() +
                " aktifitas",
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget getTaskDetailLineSeparator() {
    return Padding(
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
    );
  }
}