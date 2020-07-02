import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nattupedika/models/user.dart';
import 'package:provider/provider.dart';

import '../full_photo.dart';

class Chat extends StatelessWidget {
  final String peerUid;

  Chat({Key key, @required this.peerUid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user.uid);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CHAT',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ChatScreen(
        peerId: peerUid,
        uid: user.uid,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String uid;

  ChatScreen({Key key, @required this.peerId, @required this.uid})
      : super(key: key);

  @override
  State createState() => ChatScreenState(peerId: peerId, uid: uid);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState({Key key, @required this.peerId, @required this.uid});

  String peerId;
  String uid;

  var listMessage;
  String groupChatId;
  bool isLoading;

  File imageFile;
  String imageUrl;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    groupChatId = '';
    imageUrl = '';

    isLoading = false;
    readLocal();
  }

  readLocal() async {
    if (uid.hashCode <= peerId.hashCode) {
      groupChatId = '$uid-$peerId';
    } else {
      groupChatId = '$peerId-$uid';
    }

    Firestore.instance
        .collection('users')
        .document(uid)
        .updateData({'chattingWith': peerId});
  }

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      print("not image");
    });
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': uid,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });
      Firestore.instance
          .collection('users')
          .document(peerId)
          .collection('userchats')
          .document(uid)
          .setData({'username': peerId, 'uid': uid});
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      print("Nothimg to send");
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == uid) {
      // Right (my message)
      return Row(
        children: <Widget>[
          document['type'] == 0
          // Text
              ? Container(
            child: Text(
              document['content'],
              style: TextStyle(color: Colors.black),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                right: 10.0),
          )
              : document['type'] == 2
              ? Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text("Order"),
                ),
                Divider(
                  color: Colors.black,
                ),
                Text(
                  document['content'],
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10.0)),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                right: 10.0),
          )
              : Container(
            child: FlatButton(
              child: Material(
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                    width: 200.0,
                    height: 200.0,
                    padding: EdgeInsets.all(70.0),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Material(
                    child: Image.asset(
                      'images/img_not_available.jpeg',
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  ),
                  imageUrl: document['content'],
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                clipBehavior: Clip.hardEdge,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FullPhoto(url: document['content'])));
              },
              padding: EdgeInsets.all(0),
            ),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                right: 10.0),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            document['type'] == 0
            // Text
                ? Container(
              child: Text(
                document['content'],
                style: TextStyle(color: Colors.black),
              ),
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              width: 200.0,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8.0)),
              margin: EdgeInsets.only(
                  bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                  right: 10.0),
            )
                : document['type'] == 2
                ? Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.shopping_cart),
                    title: Text("Order"),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Text(
                    document['content'],
                    style: TextStyle(color: Colors.black),
                  ),
                  RaisedButton(
                    onPressed: () {
                      onSendMessage("Your order is ready", 0);
                    },
                    child: Text('Order Ready'),
                    color: Colors.white,
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              width: 200.0,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10.0)),
              margin: EdgeInsets.only(
                  bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                  right: 10.0),
            )
                : Container(
              child: FlatButton(
                child: Material(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.green),
                      ),
                      width: 200.0,
                      height: 200.0,
                      padding: EdgeInsets.all(70.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Material(
                      child: Image.asset(
                        'images/img_not_available.jpeg',
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      clipBehavior: Clip.hardEdge,
                    ),
                    imageUrl: document['content'],
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius:
                  BorderRadius.all(Radius.circular(8.0)),
                  clipBehavior: Clip.hardEdge,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FullPhoto(url: document['content'])));
                },
                padding: EdgeInsets.all(0),
              ),
              margin: EdgeInsets.only(left: 10.0),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
        listMessage != null &&
        listMessage[index - 1]['idFrom'] == uid) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
        listMessage != null &&
        listMessage[index - 1]['idFrom'] != uid) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    Firestore.instance
        .collection('users')
        .document(uid)
        .updateData({'chattingWith': null});
    Navigator.pop(context);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),
              // Input content
              buildInput(),
            ],
          ),
          buildLoading()
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green))
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: getImage,
                color: Colors.black,
              ),
            ),
            color: Colors.white,
          ),

          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () => _getOrderDialog(context)
                    .then((value) => onSendMessage(value, 2)),
                color: Colors.black,
              ),
            ),
            color: Colors.white,
          ),

          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: Colors.black, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.green),
                ),
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: Colors.black,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green)))
          : StreamBuilder(
        stream: Firestore.instance
            .collection('messages')
            .document(groupChatId)
            .collection(groupChatId)
            .orderBy('timestamp', descending: true)
            .limit(20)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.green)));
          } else {
            listMessage = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  buildItem(index, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              reverse: true,
              controller: listScrollController,
            );
          }
        },
      ),
    );
  }

  Future<String> _getOrderDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('Order'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                  controller: controller,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Enter your order',
                    hintStyle: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Order'),
              onPressed: () {
                if (controller.text == "") {
                  print("Empty order");
                } else {
                  Navigator.of(context).pop(controller.text.toString());
                }
              },
            ),
          ],
        );
      },
    );
  }
}