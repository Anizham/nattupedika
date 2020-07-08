import 'package:flutter/material.dart';
import 'package:nattupedika/Screens/Chat.dart';

class DetailedPage extends StatelessWidget {
  final String location;
  final String phoneNo;
  final String timing;
  final String shopName;
  final String shopkeeperUid;
  DetailedPage({
    Key key,
    @required this.shopName,
    @required this.location,
    @required this.timing,
    @required this.phoneNo,
    @required this.shopkeeperUid
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(shopkeeperUid);
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
            onPressed: (){
              Navigator.pop(context);
            },
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
                      title: Text("Location"),
                      subtitle: Text(location),
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
        floatingActionButton: Builder(builder: (BuildContext context){
          return FloatingActionButton.extended(
            onPressed: () {
              if(shopkeeperUid==''){
                final snackBar = SnackBar(content: Text('This shop does not offer chat service.',style: TextStyle(color: Colors.green),));
                Scaffold.of(context).showSnackBar(snackBar);
              }else{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Chat(
                        peerUid: shopkeeperUid,
                      )),
                );
              }
            },
            label: Text("PLACE ORDER"),
          );
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}