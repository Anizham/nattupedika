import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nattupedika/CustomerHome.dart';

import '../ShopkeeperHome.dart';
import '../user.dart';

class AuthService{

  final _codeController=TextEditingController();

  final FirebaseAuth _auth= FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user){
    return user!=null ? User(uid:user.uid):null;
  }

  // change user auth stream
  Stream<User> get user{
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }


  Future<bool> signInWithPhoneNo(String phoneNo,BuildContext context,String userType) async {
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async{
          Navigator.of(context).pop();
          AuthResult result=await _auth.signInWithCredential(credential);
          User user=_userFromFirebaseUser(result.user);

          if(user!=null){
            if(userType=="customer"){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>CustomerHomePage(email:"vpsines@gmail.com",)
              ));
            }else{
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>ShopkeeperHomePage()
              ));
            }
          }
        },
        verificationFailed: (AuthException e){
          print(e.toString());
          return false;
        },
        codeSent: (String verificationId, [int forceResendingToken]){
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Enter the OTP"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _codeController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("VERIFY"),
                      textColor: Colors.white,
                      color: Colors.green,
                      onPressed: () async{
                        final code = _codeController.text.trim();

                        AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: code);
                        AuthResult result = await _auth.signInWithCredential(credential);

                        FirebaseUser user = result.user;

                        if(user != null){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => CustomerHomePage(email: "sas",)
                          ));
                        }else{
                          print("Error");
                        }
                      },
                    )
                  ],
                );
              }
          );
        },
        codeAutoRetrievalTimeout: null);
    return false;
  }

  Future<User> signInWithGoogle() async{
    try{
        GoogleSignIn googleSignIn =GoogleSignIn();
        GoogleSignInAccount account=await googleSignIn.signIn();

        if(account==null) return null;

        AuthResult result= await _auth.signInWithCredential(GoogleAuthProvider.getCredential(
            idToken: (await account.authentication).idToken,
            accessToken: (await account.authentication).accessToken));

        if(result.user!=null) return null;
        return _userFromFirebaseUser(result.user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}