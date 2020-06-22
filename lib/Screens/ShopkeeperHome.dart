import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nattupedika/Screens/Chat.dart';
import 'package:nattupedika/models/persons.dart';
import 'package:nattupedika/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopkeeperHomePage extends StatefulWidget {
  ShopkeeperHomePage({Key key,this.cid}):super(key:key);
  final String cid;
  @override
  _HomePageState createState() => _HomePageState(cid: cid);
}

class _HomePageState extends State<ShopkeeperHomePage> {
   _HomePageState({this.cid});
   final String cid;
  final AuthService _auth = AuthService();
SharedPreferences prefs;
   List<Map> values = [];
   List<Map>  result;
  final String shopClose = "Close";
  final String shopOpen = "Open";
  String id;

  

   Widget BuildItem(BuildContext context,String username,String uid)
  {
  
    {
       return GestureDetector(
         onTap: ()
         {
           Navigator.push(context, MaterialPageRoute(builder: (context)=>Chat(peerId: uid)));
         },
                child: Container(
          color: Colors.black26,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)),
                child: Text(username.substring(0, 1),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w300)),
              ),
              SizedBox(
                width: 12,
              ),
              Text(username,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300))
            ],
          ),
      ),
       );
    }
   

  }
  @override
  void initState() {
  super.initState();
    readlocal();
  }

  readlocal() async{
      // prefs = await SharedPreferences.getInstance();
      id='';
    id = cid ?? '';
    print(id);
    _listenToData();
  }
  
 
  _listenToData() async{  
   Firestore.instance.collection(id)
  .snapshots().listen((snap){
        
           snap.documents.forEach((d) {
           
         
               print('Name:${d.data['username']}');
               var username = d.data['username'].toString();
               var uid = d.data['uid'].toString();
               print(uid);
               var data = {'username': username,'uid':uid};
               values.add(data);        
           });
          
          
  });
  final set = Set<Person>.from(values.map<Person>((person) => Person(person['username'], person['uid'])));
  result = set.map((person) => person.toMap()).toList();
  print(result);
  print(values);
}



  @override
  Widget build(BuildContext context) {
    bool _shopStatus = true;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Nattupeedikaa'),
            actions: <Widget>
            [
            GestureDetector(
              onTap: ()
              {
                _listenToData();

              },
              child: Icon(Icons.ac_unit)
              )
            ],
          ),
          
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                  child: Center(
                    child: CircleAvatar(
                      backgroundImage: AssetImage("images/shop.jpg"),
                      radius: 60.0,
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    SwitchListTile(
                      title: Text("Shop:"),
                      subtitle: _shopStatus ? Text(shopOpen) : Text(shopClose),
                      value: _shopStatus,
                      onChanged: (bool value) {
                        setState(() {
                          _shopStatus = value;
                        });
                      },
                      secondary: Icon(Icons.store),
                    ),
                    Divider(),
                    ListTile(
                      title: Text("About"),
                      leading: Icon(Icons.info_outline),
                    ),
                    ListTile(
                      title: Text("Help"),
                      leading: Icon(Icons.help),
                    ),
                    ListTile(
                      title: Text("Settings"),
                      leading: Icon(Icons.settings),
                    ),
                    ListTile(
                      title: Text("Log Out"),
                      leading: Icon(Icons.power_settings_new),
                      onTap: () async {
                        await _auth.signOut();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
           body:ListView.builder
           (
             itemCount: values.length,
             itemBuilder: (context,i)=>ListTile
             (
               title: Text('Name:${result[i]['name']}'),
               subtitle: Text('Age:${result[i]['age']}'),
             )
           )
          




          // body:Container(
          //   height: MediaQuery.of(context).size.height,
          //   child: Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: <Widget>[
          //         Container(
          //           height: 300,
          //           width: MediaQuery.of(context).size.width * 0.9,
          //           child: SvgPicture.asset("images/no_chats.svg"),
          //         ),
          //         Text(
          //           "No Orders Yet",
          //           style: TextStyle(
          //               fontFamily: 'Montserrat',
          //               fontSize: 18.0,
          //               color: Colors.grey),
          //         ),
          //       ],
          //     ),
          //   ),
          // )
      //     body:Container(
      //   child:StreamBuilder(
      //     stream:Firestore.instance.collection(id).snapshots(),
      //     builder: (context,snapshot)
      //     {
      //       if(!snapshot.hasData)
      //       {
      //         return Center(child: CircularProgressIndicator(),);
      //       }
      //       else
      //       {
      //         return ListView.builder(
      //          padding: EdgeInsets.all(10.0),
      //           itemBuilder: (context,index)=>BuildItem(context,snapshot.data.documents[index]),
      //            itemCount: snapshot.data.documents.length,
      //         );
      //       }
            

      //     })
      // )
          ),
    );
  }
}
