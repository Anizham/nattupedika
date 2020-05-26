import 'package:flutter/material.dart';

class HealthCare extends StatelessWidget {
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
                      backgroundImage: AssetImage(
                        "images/healthcentre.jpg",
                      ),
                      radius: 30.0,
                    ),
                    trailing: Icon(Icons.call),
                    isThreeLine:true,
                    title: Text("StoreName"),
                    subtitle: Wrap(
                      direction: Axis.vertical,
                      spacing: 10.0,
                      children: <Widget>[
                        Text("Location"),
                        Text("Open"),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
