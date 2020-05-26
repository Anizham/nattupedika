import 'package:flutter/material.dart';
import 'package:nattupedika/DetaildPage.dart';

class Stores extends StatelessWidget {
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailedPage()),
                      );
                    },
                    leading: CircleAvatar(backgroundImage:AssetImage("images/shop.jpg") ,
                    radius: 30.0,),
                    trailing: Icon(Icons.call),
                    title: Text("StoreName"),
                    subtitle: Wrap(
                      direction: Axis.vertical,
                      spacing: 10.0,
                      children: <Widget>[
                        Text("Location"),
                        Text("Open"),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                ),
              );
            }),
      ),
    );
  }
}
