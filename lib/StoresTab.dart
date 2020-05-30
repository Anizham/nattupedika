import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nattupedika/DetaildPage.dart';
import 'package:nattupedika/Loading.dart';

class Stores extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance.collection('store_data').snapshots(),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
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
                                    )),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundImage: AssetImage("images/shop.jpg"),
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
                        isThreeLine: true,
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
