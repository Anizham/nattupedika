import 'package:flutter/material.dart';
import 'package:nattupedika/Authentication/UserType.dart';
import 'package:nattupedika/Screens/ShopkeeperHome.dart';
import 'package:nattupedika/models/user.dart';
import 'package:provider/provider.dart';

import 'CustomerHome.dart';


class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    String userType;
    if (user == null)  {
      return UserType();
    } else {
      if( userType=='customer'){
        return CustomerHomePage(user:user);
      }else{
        return ShopkeeperHomePage(user: user);
      }
    }
  }


}