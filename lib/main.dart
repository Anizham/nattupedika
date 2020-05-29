import 'package:flutter/material.dart';
import 'package:nattupedika/SignIn.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Nattupedika',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: SignInPage(),);
  }
}
