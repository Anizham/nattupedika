import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nattupedika/Loading.dart';

import 'DetaildPage.dart';

class Pharmacy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance.collection('pharmacy_data').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Loading();
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      child: ListTile(
                        onTap: () async{
                          String phoneNo=snapshot.data.documents[index]['phoneNo'];
                          await Firestore.instance.collection("shopkeepers").document(phoneNo).get().then((value){
                            Navigator.push(
                              context,
                              MaterialPageRoute (
                                  builder: (context) => DetailedPage(
                                    shopName: snapshot.data.documents[index]
                                    ['name'],
                                    address: snapshot.data.documents[index]
                                    ['address'],
                                    phoneNo: snapshot.data.documents[index]
                                    ['phoneNo'],
                                    timing: snapshot
                                        .data.documents[index]['closingTime']
                                        .toString(),
                                    shopkeeperUid:value.data['id'].toString(),
                                  )),
                            );

                          });
                        },
                        leading: CircleAvatar(
                          backgroundImage: AssetImage("images/pharmacy.jpg"),
                          radius: 30.0,
                        ),
                        trailing: Icon(Icons.call),
                        title: Text(snapshot.data.documents[index]['name']),
                        subtitle: Wrap(
                          direction: Axis.vertical,
                          spacing: 10.0,
                          children: <Widget>[
                            Text(snapshot.data.documents[index]['location']),
                            Text(snapshot.data.documents[index]['status']),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
