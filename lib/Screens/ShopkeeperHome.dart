import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nattupedika/Screens/Chat.dart';
import 'package:nattupedika/models/user.dart';
import 'package:nattupedika/services/auth.dart';
import 'package:nattupedika/services/notification.dart';

class ShopkeeperHomePage extends StatefulWidget {

  final User user;
  ShopkeeperHomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ShopkeeperHomePage> {

  final AuthService _auth = AuthService();
  final NotificationService _notification= NotificationService();
  
  final String shopClose = "Close";
  final String shopOpen = "Open";

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Chat(peerUid: document.data["uid"])));
        },
        child: Container(
          color: Colors.black26,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)),
                child: Text(document.data["username"].substring(0, 1),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w300)),
              ),
              SizedBox(
                width: 12,
              ),
              Text(document.data["username"],
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300))
            ],
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _notification.registerNotification(widget.user.uid);
    _notification.configLocalNotification();
  }

  

  Future<bool> onBackPress() {
    _exitDialog();
    return Future.value(false);
  }

  Future<void> _exitDialog() async {
    switch (await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Exit app'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure to exit app?'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context, 0);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.pop(context, 1);
                },
              ),
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _shopStatus = true;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Nattupeedikaa'),
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                  child: Center(
                    child: CircleAvatar(
                      backgroundImage: AssetImage("images/shop.jpg"),
                      radius: 60.0,
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    SwitchListTile(
                      title: Text("Shop:"),
                      subtitle: _shopStatus ? Text(shopOpen) : Text(shopClose),
                      value: _shopStatus,
                      onChanged: (bool value) {
                        setState(() {
                          _shopStatus = value;
                        });
                      },
                      secondary: Icon(Icons.store),
                    ),
                    Divider(),
                    ListTile(
                      title: Text("About"),
                      leading: Icon(Icons.info_outline),
                    ),
                    ListTile(
                      title: Text("Help"),
                      leading: Icon(Icons.help),
                    ),
                    ListTile(
                      title: Text("Settings"),
                      leading: Icon(Icons.settings),
                    ),
                    ListTile(
                      title: Text("Log Out"),
                      leading: Icon(Icons.power_settings_new),
                      onTap: () async {
                        await _auth.signOut(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          body: WillPopScope(
            onWillPop: onBackPress,
            child: Container(
                child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('users')
                        .document(widget.user.uid)
                        .collection('userchats')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 300,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child:
                                      SvgPicture.asset("images/no_chats.svg"),
                                ),
                                Text(
                                  "No Orders Yet",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 18.0,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          padding: EdgeInsets.all(10.0),
                          itemBuilder: (context, index) => buildItem(
                              context, snapshot.data.documents[index]),
                          itemCount: snapshot.data.documents.length,
                        );
                      }
                    })),
          )),
    );
  }
}
