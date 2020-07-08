import 'package:flutter/material.dart';
import 'package:nattupedika/Loading.dart';
import 'package:nattupedika/Screens/ShopkeeperHome.dart';
import 'package:nattupedika/services/db.dart';
import 'package:provider/provider.dart';

import 'Authentication/UserType.dart';
import 'Screens/CustomerHome.dart';
import 'models/user.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return UserType();
    } else {
      return FutureBuilder<String>(
        future: _db.getUserType(user.uid),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == 'customer') {
              return CustomerHomePage(user: user);
            } else {
              return ShopkeeperHomePage(user: user);
            }
          } else {
            return Loading();
          }
        },
      );
    }
  }
}

//_db.getUserType(user.uid).then((value){
//final userType=value.toString();
//if (userType == 'customer') {
//return CustomerHomePage(user: user);
//} else {
//return ShopkeeperHomePage(user: user);
//}
//});
