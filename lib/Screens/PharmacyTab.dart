import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nattupedika/Loading.dart';
import 'package:nattupedika/services/url.dart';
import 'package:nattupedika/Screens/DetaildPage.dart';

class Pharmacy extends StatelessWidget {
  final UrlLauncher _urlLauncher = UrlLauncher();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance.collection('data').where('category', isEqualTo: 'pharmacy').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Loading();
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          //String phoneNo=snapshot.data.documents[index]['phoneNo'];
                         // await Firestore.instance.collection("shopkeepers").document(phoneNo).get().then((value){
                            Navigator.push(
                              context,
                              MaterialPageRoute (
                                  builder: (context) => DetailedPage(
                                    shopName: snapshot.data.documents[index]
                                    ['name'],
                                    location: snapshot.data.documents[index]
                                    ['location'],
                                    phoneNo: snapshot.data.documents[index]
                                    ['phoneNo'],
                                    timing: snapshot
                                        .data.documents[index]['closingTime']
                                        .toString(),
                                    shopkeeperUid:snapshot.data.documents[index]
                                    ['uid'],
                                  )),
                            );

                         // });
                        },
                        leading: CircleAvatar(
                          backgroundImage: AssetImage("images/pharmacy.jpg"),
                          radius: 30.0,
                        ),
                        trailing: new IconButton(
                            icon: Icon(Icons.call),
                            onPressed: () {
                              Future<void> _launched = _urlLauncher
                                  .makePhoneCall(snapshot.data.documents[index]
                                      ['phoneNo']);
                            }),
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
