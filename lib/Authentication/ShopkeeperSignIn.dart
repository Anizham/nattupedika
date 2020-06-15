import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nattupedika/Loading.dart';
import 'package:nattupedika/services/auth.dart';

class ShopkeeperSignInPage extends StatefulWidget {
//  final String userType;
//  ShopkeeperSignInPage({Key key, @required this.userType}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<ShopkeeperSignInPage> {
  String _phoneNo = "";
  String error = "";
  String _userType = "shopkeeper";

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : SafeArea(
            child: Scaffold(
                body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Container(
                          height: 300.0,
                          child: SvgPicture.asset(
                            "images/logo.svg",
                            color: Colors.green,
                          )),
                    ),
                    Container(
                        padding:
                            EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 10.0),
                              TextFormField(
                                onChanged: (val) {
                                  setState(() {
                                    _phoneNo = val;
                                  });
                                },
                                validator: (val) {
                                  if (val.isEmpty) return "*Enter Phone No.";
                                  return null;
                                },
                                decoration: InputDecoration(
                                    icon: Icon(Icons.phone_android),
                                    labelText: 'Phone No. ',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green))),
                              ),
                              SizedBox(height: 50.0),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _auth.signInWithPhoneNo(
                                          _phoneNo, context, _userType);
                                    }
                                  },
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'),
                                  ),
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ]),
            )),
          );
  }
}
