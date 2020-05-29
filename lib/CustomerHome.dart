import 'package:flutter/material.dart';

import 'EmergencyTab.dart';
import 'HealthcareTab.dart';
import 'PharmacyTab.dart';
import 'StoresTab.dart';

class HomePage extends StatefulWidget {
  final String email;

  HomePage({Key key, @required this.email}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(email: email);
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String email;

  _HomePageState({Key key, @required this.email});

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final List<Widget> _widgetOptions = <Widget>[
    Stores(),
    Pharmacy(),
    HealthCare(),
    Emergency(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage("images/emergency_avatar.jpg"),
                        radius: 60.0,
                      ),
                      Text(email),
                    ],
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  ListTile(
                    title:Text("About"),
                    leading:Icon(Icons.info_outline) ,
                  ),
                  ListTile(
                    title:Text("Help"),
                    leading:Icon(Icons.help) ,
                  ),
                  ListTile(
                    title:Text("Settings"),
                    leading:Icon(Icons.settings) ,
                  ),
                ],
              )
            ],
          ),
        ),
        body: _widgetOptions[_selectedIndex],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.green,
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.green,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.store),
                title: Text('Stores'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_pharmacy),
                title: Text('Pharmacy'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_hospital),
                title: Text('HealthCentre'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.call),
                title: Text('Emergency'),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.white,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
