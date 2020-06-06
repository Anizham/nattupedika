import 'package:flutter/material.dart';
import 'package:nattupedika/Authentication/SignIn.dart';
import 'package:nattupedika/RootPage.dart';
import 'package:nattupedika/services/auth.dart';
import 'package:nattupedika/user.dart';
import 'package:provider/provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Nattupeedika',
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            home: RootPage(),
      ),
    );
  }
}
