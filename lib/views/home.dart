import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messeger_clone/services/auth.dart';
import 'package:messeger_clone/services/database.dart';
import 'package:messeger_clone/views/signin.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearching = false;

  Stream userStream;

  TextEditingController searchUsernameEditingController =
      TextEditingController();

  onSearchButtonClick() async {
    setState(() {
      isSearching = true;
    });
    userStream = await DatabaseMethods()
        .getUserByUsername(searchUsernameEditingController.text);
    setState(() {});
  }

  Widget searchUsersList() {
    return StreamBuilder(
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return searchListUserTile(
                      ds['imgUrl'], ds['username'], ds['email']);
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
      stream: userStream,
    );
  }

  Widget chatRoomList() {
    return Container();
  }

  Widget searchListUserTile(String profileUrl, name, email) {
    return Row(
      children: [
        Image.network(
          profileUrl,
          height: 30,
          width: 30,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messenger Clone'),
        actions: [
          InkWell(
            onTap: () {
              AuthMethods().signOut().then((s) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              });
            },
            child: Container(
              child: Icon(Icons.exit_to_app),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          )
        ],
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  isSearching
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              isSearching = false;
                              searchUsernameEditingController.text = '';
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(Icons.arrow_back),
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(24)),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchUsernameEditingController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'username',
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (searchUsernameEditingController.text != '') {
                                onSearchButtonClick();
                              }
                            },
                            child: Icon(Icons.search),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              isSearching ? searchUsersList() : chatRoomList()
            ],
          ),
        ),
      ),
    );
  }
}
