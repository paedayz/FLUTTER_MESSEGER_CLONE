import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messeger_clone/helperfunctions/sharedpref_helper.dart';
import 'package:messeger_clone/services/database.dart';
import 'package:random_string/random_string.dart';

class ChatScreen extends StatefulWidget {
  final String chatWithUsername, name;
  ChatScreen(this.chatWithUsername, this.name);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatRoomId, messageId = '';
  Stream messageStream;
  String myName, myProfilePic, myUserName, myEmail;
  TextEditingController messageTextEdittingController = TextEditingController();

  getMyInfoFromSharedPreference() async {
    myName = await SharedPreferenceHelper().getUserDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();

    chatRoomId = getChatRoomIdByUsernames(widget.chatWithUsername, myUserName);
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) + a.length >
        b.substring(0, 1).codeUnitAt(0) + b.length) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  addMessage(bool sendClicked) {
    if (messageTextEdittingController.text != '') {
      String message = messageTextEdittingController.text;

      var lastMessageTs = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        'message': message,
        'sendBy': myUserName,
        'ts': lastMessageTs,
        'imgUrl': myProfilePic
      };

      //messageId
      if (messageId == '') {
        messageId = randomAlphaNumeric(12);
      }

      DatabaseMethods()
          .addMessage(chatRoomId, messageId, messageInfoMap)
          .then((val) {
        Map<String, dynamic> lastMessageInfoMap = {
          'lastMessage': message,
          'lastMessageSendTs': lastMessageTs,
          'lastMessageSendBy': myUserName
        };

        DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);

        if (sendClicked) {
          messageTextEdittingController.text = '';
          messageId = '';
        }
      });
    }
  }

  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          child: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
              bottomLeft: sendByMe ? Radius.circular(24) : Radius.circular(0),
              bottomRight: sendByMe ? Radius.circular(0) : Radius.circular(24),
            ),
            color: Colors.blue[300],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
      ],
    );
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                reverse: true,
                padding: const EdgeInsets.only(bottom: 70, top: 16),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return chatMessageTile(
                      ds['message'], myUserName == ds['sendBy']);
                },
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  getAndSetMessages() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

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
            chatMessages(),
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
                        controller: messageTextEdittingController,
                        onChanged: (value) => addMessage(false),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type a message',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => addMessage(true),
                      child: Icon(Icons.send),
                    ),
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
