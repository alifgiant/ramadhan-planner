import 'dart:async';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:khatam_quran/quran/background/background.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:connectivity/connectivity.dart';

class NewTaskPage extends StatefulWidget {
  final FirebaseUser user;

  NewTaskPage({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  TextEditingController listNameController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Color pickerColor = Color(0xff6633ff);
  Color currentColor = Color(0xff6633ff);

  ValueChanged<Color> onColorChanged;

  bool _saving = false;

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = new Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<Null> initConnectivity() async {
    String connectionStatus;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
    } on PlatformException catch (e) {
      print(e.toString());
      connectionStatus = 'Failed to get connectivity.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _connectionStatus = connectionStatus;
    });
  }

  void addToFirebase() async {
    setState(() {
      _saving = true;
    });

    print(_connectionStatus);

    if(_connectionStatus == "ConnectivityResult.none"){
      showInSnackBar("No internet connection currently available");
      setState(() {
        _saving = false;
      });
    } else {

      bool isExist = false;

      QuerySnapshot query =
      await Firestore.instance.collection(widget.user.uid).getDocuments();

      query.documents.forEach((doc) {
        if (listNameController.text.toString() == doc.documentID) {
          isExist = true;
        }
      });

      if (isExist == false && listNameController.text.isNotEmpty) {
        await Firestore.instance
            .collection(widget.user.uid)
            .document(listNameController.text.toString().trim())
            .setData({
          "color": currentColor.value.toString(),
          "date": DateTime.now().millisecondsSinceEpoch
        });

        listNameController.clear();

        pickerColor = Color(0xff6633ff);
        currentColor = Color(0xff6633ff);

        showInSnackBar("Target baru berhasil terbuat");
        
        Navigator.of(context).pop();
      }
      if (isExist == true) {
        showInSnackBar("Target sudah ada");
        setState(() {
          _saving = false;
        });
      }
      if (listNameController.text.isEmpty) {
        showInSnackBar("Nama tidak boleh kosong");
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ModalProgressHUD(
          child: new Stack(
            children: <Widget>[
              Background().buildImageBackground(),
              _getToolbar(context),
              buildBody()
            ],
          ),
          inAsyncCall: _saving),
    );
  }

  Widget buildBody(){
    return  Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 130, left: 20),
            alignment: Alignment.topLeft,
              child: Text('Target baru',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold))
          ),
          Padding(
            padding:
            EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0),
            child: new Column(
              children: <Widget>[
                new TextFormField(
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide:
                          new BorderSide(color: Colors.teal)),
                      hintText: "Tulis nama target baru",
                      labelText: "Nama",
                      contentPadding: EdgeInsets.only(
                          left: 16.0,
                          top: 20.0,
                          right: 16.0,
                          bottom: 5.0)),
                  controller: listNameController,
                  autofocus: true,
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 20,
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.topLeft,
                  child: RaisedButton(
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
                                  setState(() =>
                                  currentColor = pickerColor);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Ganti warna target'),
                    color: currentColor,
                    textColor: const Color(0xffffffff),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 20,right: 20),
            child: new Column(
              children: <Widget>[
                ButtonTheme(
                  minWidth: double.infinity,
                  child: new RaisedButton(
                    child: const Text(
                      'Tambahkan',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    elevation: 4.0,
                    splashColor: Colors.deepPurple,
                    onPressed: addToFirebase,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void dispose() {
    _scaffoldKey.currentState?.dispose();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          setState(() {
            _connectionStatus = result.toString();
          });
        });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState?.removeCurrentSnackBar();

    _scaffoldKey.currentState?.showSnackBar(new SnackBar(
      content: new Text(value, textAlign: TextAlign.center),
      backgroundColor: currentColor,
      duration: Duration(seconds: 3),
    ));
  }

  Container _getToolbar(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(left: 10.0, top: 40.0),
      child: new BackButton(color: Colors.black),
    );
  }
}
