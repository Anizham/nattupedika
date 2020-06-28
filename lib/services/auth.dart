import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nattupedika/Screens/CustomerHome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/ShopkeeperHome.dart';
import '../main.dart';
import '../models/user.dart';

class AuthService {
  final _codeController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences prefs;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }
 

  // change user auth stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future<bool> signInWithPhoneNo(
      String phoneNo, BuildContext context, String userType) async {
    _auth.verifyPhoneNumber(
        phoneNumber: '+91' + phoneNo,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();
          AuthResult result = await _auth.signInWithCredential(credential);
          User user = _userFromFirebaseUser(result.user);

          if (user != null) {
            if (userType == "customer") {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomerHomePage(
                            user: user,
                          )));
            } else {
              print(phoneNo);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShopkeeperHomePage(pno1: phoneNo,user: user,)));
            }
          }
        },
        verificationFailed: (AuthException e) {
          print(e.message.toString());
          return false;
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
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
                      onPressed: () async {
                        final code = _codeController.text.trim();

                        AuthCredential credential =
                            PhoneAuthProvider.getCredential(
                                verificationId: verificationId, smsCode: code);
                        AuthResult result =
                            await _auth.signInWithCredential(credential);

                        User user = _userFromFirebaseUser(result.user);

                        print(user.uid);
                        if (user != null) {
                          if (userType == "customer") {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CustomerHomePage(
                                          user: user,
                                        )));
                          } else {
                            print(phoneNo);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ShopkeeperHomePage(pno1: phoneNo,user: user,)));
                          }
                        } else {
                          print("Error");
                        }
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: null);
    return false;
  }

  Future<bool> registerWithPhoneNo(String phoneNo, BuildContext context,
      String userType, String username) async {
    _auth.verifyPhoneNumber(
        phoneNumber:  phoneNo,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();
          AuthResult result = await _auth.signInWithCredential(credential);
          User user = _userFromFirebaseUser(result.user);

          if (user != null) {
            // Check is already sign up
            final QuerySnapshot snapshot = await Firestore.instance
                .collection('users')
                .where('id', isEqualTo: user.uid)
                .getDocuments();
            final List<DocumentSnapshot> documents = snapshot.documents;
            if (documents.length == 0) {
              // Update data to server if new user
              Firestore.instance
                  .collection('users')
                  .document(user.uid)
                  .setData({
                'username': username,
                'userType': userType,
                'id': user.uid,
                'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
                'chattingWith': null
              });
              if(userType=="shopkeeper"){
                Firestore.instance
                    .collection('shopkeepers')
                    .document(phoneNo)
                    .setData({
                  'id': user.uid,
                });
              }

            } else {
              print("User already exists");
            }
            if (userType == "customer") {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomerHomePage(
                        user: user,
                      )));
            } else {
              print(phoneNo);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShopkeeperHomePage(pno1: phoneNo,user: user,)));
            }
          } else {
            print("error");
          }
        },
        verificationFailed: (AuthException e) {
          print(e.message.toString());
          return false;
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
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
                      onPressed: () async {
                        final code = _codeController.text.trim();

                        AuthCredential credential =
                            PhoneAuthProvider.getCredential(
                                verificationId: verificationId, smsCode: code);
                        AuthResult result =
                            await _auth.signInWithCredential(credential);

                        User user = _userFromFirebaseUser(result.user);
                        if (user != null) {
                          // Check is already sign up
                          final QuerySnapshot snapshot = await Firestore
                              .instance
                              .collection('users')
                              .where('id', isEqualTo: user.uid)
                              .getDocuments();
                          final List<DocumentSnapshot> documents =
                              snapshot.documents;
                          if (documents.length == 0) {
                            // Update data to server if new user
                            Firestore.instance
                                .collection('users')
                                .document(user.uid)
                                .setData({
                              'username': username,
                              'userType': userType,
                              'id': user.uid,
                              'createdAt': DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              'chattingWith': null
                            });
                            if (userType == "customer") {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CustomerHomePage(
                                            user: user,
                                          )));
                            } else {
                              print(phoneNo);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ShopkeeperHomePage(pno1: phoneNo,user: user,)));
                            }
                          } else {
                            print("User already exists");
                          }
                        } else {
                          print("error");
                        }
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: null);
    return false;
  }

  Future<bool> signInWithGoogle(String userType,BuildContext context) async {
    try {
      GoogleSignInAccount account = await _googleSignIn.signIn();

      if (account == null) return false;

      AuthResult result = await _auth.signInWithCredential(
          GoogleAuthProvider.getCredential(
              idToken: (await account.authentication).idToken,
              accessToken: (await account.authentication).accessToken));
        if (result.user != null) {
          // Check is already sign up
          final QuerySnapshot snapshot = await Firestore.instance
              .collection('users')
              .where('id', isEqualTo: result.user.uid)
              .getDocuments();
          final List<DocumentSnapshot> documents = snapshot.documents;
          if (documents.length == 0) {
            // Update data to server if new user
            Firestore.instance
                .collection('users')
                .document(result.user.uid)
                .setData({
              'username': result.user.displayName,
              'userType': userType,
              'id': result.user.uid,
              'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
              'chattingWith': null
            });
            if (userType == "customer") {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomerHomePage(
                        user: _userFromFirebaseUser(result.user),
                      )));
            }
          } else {
            print("User already exists");
            if (userType == "customer") {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomerHomePage(
                        user: _userFromFirebaseUser(result.user),
                      )));
            }
          }
        } else {
          print("error");
          return false;
        }
    } catch (e) {
      print(e.message.toString());
      return false;
    }
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      // Firestore.instance.collection("user").document(user.uid).setData({"username":_nameController.text,"id":user.uid,"chattingwith":null});
      if (user != null) return null;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<FirebaseUser> signInWithEmail(String email, String password) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print(e.message.toString());
      return null;
    }
  }

  Future signOut(BuildContext context) async {
    await _auth.signOut();
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MyApp()),
              (Route < dynamic > route) => false);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
