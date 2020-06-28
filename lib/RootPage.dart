import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nattupedika/Screens/ShopkeeperHome.dart';
import 'package:provider/provider.dart';

import 'Authentication/UserType.dart';
import 'Screens/CustomerHome.dart';
import 'models/user.dart';

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

  Future<String> getUserType(String uid) async{
    await Firestore.instance.collection("users").document(uid).get().then((value){
      return value.data['userType'];
    });
  }
}
