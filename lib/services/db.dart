import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{



  final CollectionReference usersCollection = Firestore.instance.collection('users');
  final CollectionReference shopkeeperCollection = Firestore.instance.collection('data');

  Future<String> getUserType(String uid) async{
    var docSnapshot=await usersCollection.document(uid).get();
    return docSnapshot.data['userType'];
  }

  Future<String> getUserName(String uid) async{
    var docSnapshot=await usersCollection.document(uid).get();
    return docSnapshot.data['username'];
  }

  Future<bool> checkShopkeeperExists(String phoneNo) async{
    final QuerySnapshot snapshot = await shopkeeperCollection
        .where('phoneNo', isEqualTo: phoneNo)
        .getDocuments();
    final List<DocumentSnapshot> documents = snapshot.documents;
    if (documents.length == 0) {
      return false;
    }else{
      return true;
    }
  }

  Future<bool> checkCustomerExists(String phoneNo) async{
    final QuerySnapshot snapshot = await usersCollection
        .where('phoneNo', isEqualTo: phoneNo)
        .getDocuments();
    final List<DocumentSnapshot> documents = snapshot.documents;
    if (documents.length == 0) {
      return false;
    }else{
      return true;
    }
  }

  Future<String> getShopkeeperName(String phoneNo) async{
    var docSnapshot=await shopkeeperCollection.document(phoneNo).get();
    return docSnapshot.data['name'];
  }

}