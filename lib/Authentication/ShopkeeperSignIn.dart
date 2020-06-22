import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nattupedika/Loading.dart';
import 'package:nattupedika/Screens/ShopkeeperHome.dart';
import 'package:nattupedika/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopkeeperSignInPage extends StatefulWidget {
//  final String userType;
//  ShopkeeperSignInPage({Key key, @required this.userType}) : super(key: key);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<ShopkeeperSignInPage> {
  String password = "";
  String email = "";
  String error = "";
  String _userType = "shopkeeper";
  String cid = '';

  SharedPreferences prefs;

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
                              // SizedBox(height: 10.0),
                              // TextFormField(
                              //   onChanged: (val) {
                              //     setState(() {
                              //       _phoneNo = val;
                              //     });
                              //   },
                              //   validator: (val) {
                              //     if (val.isEmpty) return "*Enter Phone No.";
                              //     return null;
                              //   },
                              //   decoration: InputDecoration(
                              //       icon: Icon(Icons.phone_android),
                              //       labelText: 'Phone No. ',
                              //       labelStyle: TextStyle(
                              //           fontFamily: 'Montserrat',
                              //           fontWeight: FontWeight.bold,
                              //           color: Colors.grey),
                              //       focusedBorder: UnderlineInputBorder(
                              //           borderSide:
                              //               BorderSide(color: Colors.green))),
                              // ),
                              TextFormField(
                              validator: (val)=>val.isEmpty?"*Enter Email":null,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  icon: Icon(Icons.email),
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.green))),
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              obscureText: true,
                              validator: (val){
                                if(val.length<6) return "*Invalid Password";
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  icon: Icon(Icons.phone_android),
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.green))),
                            ),

                              SizedBox(height: 50.0),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  onPressed: ()  async{
                                    if (_formKey.currentState.validate()) {
                                    FirebaseUser user= await _auth.signInWithEmail(email, password);
                                    // currentuser =user;
                                    cid = user.uid;
                                     if(user!=null)
                                     {
                                      // prefs = await SharedPreferences.getInstance();
                                      // await prefs.setString('id',user.uid);

                                      Navigator.push(context, MaterialPageRoute(
                                      builder: (context)=>ShopkeeperHomePage(cid: cid,)
                                      ));
                                     }
                                       
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
