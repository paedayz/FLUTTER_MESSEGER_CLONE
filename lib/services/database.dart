import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messeger_clone/helperfunctions/sharedpref_helper.dart';

class DatabaseMethods {
  Future addUserInfoToDB(
      String userId, Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getUserByUsername(String username) async {
    return FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .snapshots();
  }

  Future addMessage(
      String chatRoomId, String messageId, Map messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('chats')
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessageSend(String chatRoomId, Map lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  createChatRoom(String chatRoomId, Map chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      // chatroom already exists
      return true;
    } else {
      // chatroom do not exists
      return FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('chats')
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    String myUsername = await SharedPreferenceHelper().getUserName();
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .where('users', arrayContains: myUsername)
        .snapshots();
  }
}
