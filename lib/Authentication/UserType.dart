import 'package:flutter/material.dart';
import 'package:nattupedika/Authentication/ShopkeeperSignIn.dart';
import 'CustomerSignIn.dart';

class UserType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  height: 350.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/start.png"),
                    ),
                  )),
              SizedBox(height: 50.0),
              Container(
                margin: EdgeInsets.only(right: 50, left: 50),
                height: 60.0,
                child: Material(
                  borderRadius: BorderRadius.circular(70.0),
                  shadowColor: Colors.greenAccent,
                  color: Colors.green,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,MaterialPageRoute(
                          builder:(context)=>CustomerSignInPage()));
                    },
                    child: Center(
                      child: Text(
                        'CUSTOMER',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.only(right: 50, left: 50),
                height: 60.0,
                child: Material(
                  borderRadius: BorderRadius.circular(90.0),
                  shadowColor: Colors.greenAccent,
                  color: Colors.green,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,MaterialPageRoute(
                          builder:(context)=>ShopkeeperSignInPage()));
                    },
                    child: Center(
                      child: Text(
                        'SHOP KEEPER',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
