import 'package:flutter/material.dart';
import 'file:///E:/covid/nattupedika/lib/Screens/RootPage.dart';
import 'package:nattupedika/services/auth.dart';
import 'package:nattupedika/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      catchError: (_, __) => null,
      value: AuthService().user,
      child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Nattupeedika',
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed
    (
      Duration(seconds: 3),
      ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>RootPage()));
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/bg.jpg"), fit: BoxFit.cover)
                ),
                child: Center(
                  child:Container(
                        height: 300.0,
                        child: SvgPicture.asset(
                          "images/text.svg",
                          color: Colors.green,
                        )),),
    );
  }
}
