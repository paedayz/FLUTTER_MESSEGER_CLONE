import 'package:flutter/material.dart';
import 'package:messeger_clone/helperfunctions/sharedpref_helper.dart';

class ChatScreen extends StatefulWidget {
  final String chatWithUsername, name;
  ChatScreen(this.chatWithUsername, this.name);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatRoomId, messageId = '';
  String myName, myProfilePic, myUserName, myEmail;

  getMyInfoFromSharedPreference() async {
    myName = await SharedPreferenceHelper().getUserDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();

    chatRoomId = getChatRoomIdByUsernames(widget.chatWithUsername, myUserName);
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  getAndSetMessages() async {}

  doThisOnLaunch() async {
    await getMyInfoFromSharedPreference();
    getAndSetMessages();
  }

  @override
  void initState() {
    doThisOnLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.black12,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type a message',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Icon(Icons.send),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
