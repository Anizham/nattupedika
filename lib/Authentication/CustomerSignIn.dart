import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nattupedika/Authentication/SignUpPage.dart';
import 'package:nattupedika/Loading.dart';
import 'package:nattupedika/services/auth.dart';
class CustomerSignInPage extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<CustomerSignInPage> {
  String _phoneNo = "";
  String error = "";
  String _userType="customer";
  String name = "";

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading=false;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :SafeArea(
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
                  padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
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
                            onPressed: () async{
                              if (_formKey.currentState.validate()) {
                                _auth.signInWithPhoneNo(_phoneNo, context,_userType);
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
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage(userType: _userType,))),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Don\'t have an Account? ',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 18.0,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: OutlineButton(
                            splashColor: Colors.grey,
                            onPressed: () async{
                                setState(() {
                                  loading=true;
                                });
                                dynamic result=await _auth.signInWithGoogle(_userType,context);
                                if(result==false){
                                  setState(() {
                                    loading=false;
                                    error='Authentication failed';
                                    print(error);
                                  });
                                }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            highlightElevation: 0,
                            borderSide: BorderSide(color: Colors.grey),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image(
                                      image: AssetImage("images/google_logo.png"),
                                      height: 20.0),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Sign in with Google',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 16.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ]),
      )),
    );
  }
}
