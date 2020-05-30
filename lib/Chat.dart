import 'dart:io';
import 'package:flutter/material.dart';
import 'Loading.dart';

class Chat extends StatelessWidget {
  final String shopName;

  Chat({Key key, @required this.shopName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(shopName),
          leading: Icon(Icons.arrow_back),
        ),
        body: ChatScreen(
          shopName: shopName,
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String shopName;

  ChatScreen({
    Key key,
    @required this.shopName,
  }) : super(key: key);
  @override
  State createState() => ChatScreenState(shopId: shopName);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState({Key key, @required this.shopId});

  String shopId;
  String id;

  var listMessage;
  String groupChatId;

  bool isLoading;
  File image;

  String imageUrl;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              buildListMessage(), // List of messages
              buildInput(), // Input content
            ],
          ),
          // Loading
          //_buildLoading()
        ],
      ),
    );
  }

  _buildLoading() {
    return Positioned(
      child: isLoading ? const Loading() : Container(),
    );
  }

  buildListMessage() {
    return Flexible(
        child: Container(
      height: MediaQuery.of(context).size.height * 0.5,
    ));
  }

  buildInput() {
    return Material(
      elevation: 5.0,
      child: Container(
        child: Row(
          children: <Widget>[
            Material(
              // Button send image
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                child: IconButton(
                  icon: Icon(Icons.image),
                  onPressed: null,
                  color: Colors.black,
                ),
              ),
              color: Colors.white,
            ),
            Flexible(
              // field to type message
              child: Container(
                child: TextField(
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                  controller: textEditingController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Type your message...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  focusNode: focusNode,
                ),
              ),
            ),
            Material(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                child: IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                  ),
                  color: Colors.black,
                  onPressed: null,
                ),
              ),
              color: Colors.white,
            ),
            Material(
              // Button send message
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => {},
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
            border:
                Border(top: BorderSide(color: Color(0xffE8E8E8), width: 0.5)),
            color: Colors.white),
      ),
    );
  }
}
