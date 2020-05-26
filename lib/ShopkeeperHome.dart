import 'package:flutter/material.dart';

class ShopkeeperHomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ShopkeeperHomePage> {
  final String shopClose = "Close";
  final String shopOpen = "Open";

  @override
  Widget build(BuildContext context) {
    bool _shopStatus = true;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Nattupedika'),
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.lime,
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
                  ],
                )
              ],
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Text("No Orders Yet"),
            ),
          )),
    );
  }
}
