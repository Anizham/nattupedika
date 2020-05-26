import 'package:flutter/material.dart';
import 'package:nattupedika/Chat.dart';

class DetailedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Shop Name",
          style: TextStyle(color: Colors.white, ),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Image.asset("images/shop.jpg"),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text("Address"),
                    subtitle: Text("Location"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.call),
                    title: Text("Phone No."),
                    subtitle: Text("90886544554"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text("Closing time"),
                    subtitle: Text("5 pm"),
                  ),
                  Divider(),
                ],
              ),
            ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:  () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Chat(shopId:"ShopName",)),
          );
        },
        label: Text("PLACE ORDER"),
      ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ));
  }
}
