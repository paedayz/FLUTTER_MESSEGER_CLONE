import 'package:flutter/material.dart';
import 'package:messeger_clone/services/auth.dart';
import 'package:messeger_clone/views/signin.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          child: Text('Home Page'),
        ),
      ),
    );
  }
}
