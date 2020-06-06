import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nattupedika/services/auth.dart';

import '../Loading.dart';

class SignUpPage extends StatefulWidget {
  final String userType;
  SignUpPage({Key key, @required this.userType}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthService _auth = AuthService();
  final _formKey= GlobalKey<FormState>();

  bool loading=false;

  String email = '';
  String phoneNo = '';
  String name = '';
  String error="";

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : SafeArea(
      child:Scaffold(
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
                      padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                      child: Form(
                        key:_formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              keyboardType: TextInputType.text,
                              validator: (val)=>val.isEmpty?"*Enter Name":null,
                              onChanged: (val) {
                                setState(() {
                                  name = val;
                                });
                              },
                              decoration: InputDecoration(
                                  labelText: 'Name',
                                  icon: Icon(Icons.person),
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.green))),
                            ),
                            SizedBox(height: 10.0),
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
                              validator: (val){
                                if(val.isEmpty) return "*Enter Phone No.";
                                if(val.length<10||val.length>13) return "*Invalid Phone No.";
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                setState(() {
                                  phoneNo = val;
                                });
                              },
                              decoration: InputDecoration(
                                  labelText: 'Phone No.',
                                  icon: Icon(Icons.phone_android),
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.green))),
                            ),
                            SizedBox(height: 30.0,),
                            Container(
                              width: MediaQuery.of(context).size.width*0.75,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                onPressed: () async{
                                  if(_formKey.currentState.validate()){
                                    setState(() {
                                      loading=true;
                                    });
                                    dynamic result=_auth.signInWithPhoneNo(phoneNo, context, widget.userType);
                                    if(result==false){
                                      setState(() {
                                        loading=false;
                                      });
                                    }
                                    }
                                },
                                child: Text('Sign Up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),),
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
