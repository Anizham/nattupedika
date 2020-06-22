import 'package:flutter/material.dart';
import 'package:nattupedika/Screens/Chat.dart';

class DetailedPage extends StatelessWidget {
  final String address;
  final String phoneNo;
  final String timing;
  final String shopName;
  final String peerId;
  DetailedPage({
    Key key,
    @required this.shopName,
    @required this.address,
    @required this.timing,
    @required this.phoneNo,
    @required this.peerId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            shopName,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: (){},
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
                      subtitle: Text(address),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.call),
                      title: Text("Phone No."),
                      subtitle: Text(phoneNo),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.access_time),
                      title: Text("Time"),
                      subtitle: Text(timing),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ],
          ),
        )),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Chat(
                    peerId: peerId,
                      )),
            );
          },
          label: Text("PLACE ORDER"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}