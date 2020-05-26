import 'package:flutter/material.dart';

class Emergency extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView.builder(
            itemCount: 10,
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
                    trailing: Icon(Icons.call),
                    title: Text("Name"),
                    subtitle: Text("Resignation"),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
