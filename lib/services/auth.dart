import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nattupedika/Screens/CustomerHome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/ShopkeeperHome.dart';
import '../user.dart';

class AuthService{

  final _codeController=TextEditingController();

  final FirebaseAuth _auth= FirebaseAuth.instance;
  SharedPreferences prefs;

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
          print(e.message.toString());
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
                        prefs = await SharedPreferences.getInstance();
                        await prefs.setString('id',user.uid);
                        if(user != null){
                          if(userType=="customer"){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context)=>CustomerHomePage(email:"vpsines@gmail.com",)
                            ));
                          }else{
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context)=>ShopkeeperHomePage()
                            ));
                          }
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
  Future<bool> signUpWithEmail(String email, String password) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      // Firestore.instance.collection("user").document(user.uid).setData({"username":_nameController.text,"id":user.uid,"chattingwith":null});
      if(user!=null) return null;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<FirebaseUser> signInWithEmail(String email,String password) async{
    FirebaseAuth _auth=FirebaseAuth.instance;

    try{
      AuthResult result =await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user =result.user;
      return user;
    }catch(e){
      print(e.message.toString());
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