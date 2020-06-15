import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nattupedika/services/auth.dart';

class ShopkeeperHomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ShopkeeperHomePage> {
  final AuthService _auth = AuthService();

  final String shopClose = "Close";
  final String shopOpen = "Open";

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
                        await _auth.signOut();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: SvgPicture.asset("images/no_chats.svg"),
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
          )),
    );
  }
}
