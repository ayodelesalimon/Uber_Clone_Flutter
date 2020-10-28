import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static String id = 'homepage';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Uber')),
        body: SafeArea(
            child: Column(
              children: [
           
                Center(
          child: MaterialButton(
                onPressed: () {
                  DatabaseReference dbase =
                      FirebaseDatabase.instance.reference().child("Text");
                  dbase.set("IsConnected");
                },
                child: Text("Test"),
                height: 50.0,
          ),
        ),
              ],
            )));
  }
}
