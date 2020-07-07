import 'dart:io';
import 'package:provider/provider.dart';
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
  final NotificationService _notification = NotificationService();

  final String shopClose = "Close";
  final String shopOpen = "Open";

  bool _shopStatus = true;

  Future updateStatus(String uid, String status) async {
    await Firestore.instance
        .collection("users")
        .document(uid)
        .get()
        .then((value) {
      Firestore.instance
          .collection('data')
          .document(value.data['phoneNo'])
          .updateData({'status': status});
    });
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(40)),
                child: Center(
                  child: Text(document.data["username"].substring(0, 1),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w300)),
                ),
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text('Username: ${document.data["username"]}'),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(peerUid: document.data["uid"])));
          },
          color: Color(0xffE8E8E8),
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
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
    final user = Provider.of<User>(context);
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
                      onChanged: (bool value) {
                        setState(() {
                          _shopStatus = value;
                          if (_shopStatus == true) {
                            updateStatus(user.uid, 'open');
                          } else {
                            updateStatus(user.uid, 'closed');
                          }
                        });
                      },
                      value: _shopStatus,
                      secondary: Icon(Icons.store),
                    ),
                    Divider(),
                    ListTile(
                      title: Text("About"),
                      onTap: () {
                        showAboutDialog(
                            context: context,
                            applicationVersion: '1.1.1',
                            applicationIcon: Image.asset('images/app_icon.png'),
                            applicationName: 'Nattupedika',
                            applicationLegalese:
                                'An app to connect local businesses with local people which enables people to buy groceries from them.');
                      },
                      leading: Icon(Icons.info_outline),
                    ),
                    ListTile(
                      title: Text("Help"),
                      leading: Icon(Icons.help),
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
                      // if (snapshot.hasData) {
                      return snapshot.hasData &&
                              snapshot.data.documents.length > 0
                          ? ListView.builder(
                              padding: EdgeInsets.all(10.0),
                              itemBuilder: (context, index) => buildItem(
                                  context, snapshot.data.documents[index]),
                              itemCount: snapshot.data.documents.length,
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 300,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: SvgPicture.asset(
                                          "images/no_chats.svg"),
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
                      // }

                      // if (!snapshot.hasData) {
                      //   return Container(
                      //       child: Center(
                      //     child: CircularProgressIndicator(),
                      //   ));
                      // } else {
                      //   return snapshot.hasData
                      //       ? ListView.builder(
                      //           padding: EdgeInsets.all(10.0),
                      //           itemBuilder: (context, index) => buildItem(
                      //               context, snapshot.data.documents[index]),
                      //           itemCount: snapshot.data.documents.length,
                      //         )
                      //       : Container(
                      //           height: MediaQuery.of(context).size.height,
                      //           child: Center(
                      //             child: Column(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: <Widget>[
                      //                 Container(
                      //                   height: 300,
                      //                   width:
                      //                       MediaQuery.of(context).size.width *
                      //                           0.9,
                      //                   child: SvgPicture.asset(
                      //                       "images/no_chats.svg"),
                      //                 ),
                      //                 Text(
                      //                   "No Orders Yet",
                      //                   style: TextStyle(
                      //                       fontFamily: 'Montserrat',
                      //                       fontSize: 18.0,
                      //                       color: Colors.grey),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         );
                      // }
                    })),
          )),
    );
  }
}
