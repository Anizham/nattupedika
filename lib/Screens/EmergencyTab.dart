import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nattupedika/Loading.dart';
import 'package:nattupedika/services/url.dart';

class Emergency extends StatelessWidget {
  final UrlLauncher _urlLauncher = UrlLauncher();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance.collection('emergency_data').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Loading();
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              AssetImage("images/emergency_avatar.jpg"),
                          radius: 30.0,
                          backgroundColor: Colors.black,
                        ),
                        trailing: new IconButton(
                            icon: Icon(Icons.call),
                            onPressed: () {
                              Future<void> _launched = _urlLauncher
                                  .makePhoneCall(snapshot.data.documents[index]
                                      ['phoneNo']);
                            }),
                        title: Text(snapshot.data.documents[index]['name']),
                        subtitle:
                            Text(snapshot.data.documents[index]['phoneNo']),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
