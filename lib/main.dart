import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone/screens/homepage.dart';
import 'package:uber_clone/screens/loginpage.dart';
import 'package:uber_clone/screens/registerpage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'db2',
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
            appId: '1:678233701573:android:30ba1ec89430bd258e84ac',
            apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
            projectId: 'uberry-9b41a',
            messagingSenderId: '678233701573',
            databaseURL: 'https://uberry-9b41a.firebaseio.com',
          )
        : FirebaseOptions(
            appId: '1:678233701573:android:30ba1ec89430bd258e84ac',
            apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
            messagingSenderId: '678233701573',
            projectId: 'uberry-9b41a',
            databaseURL: 'https://uberry-9b41a.firebaseio.com',
          ),
  );
  runApp(MyApp()
  );
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Brand-Regular',
       
        primarySwatch: Colors.blue,
        
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: RegisterPage.id,
      routes: {
        RegisterPage.id: (context) => RegisterPage(),
        LoginPage.id: (context) => LoginPage(),
        Home.id: (context) => Home(),
      }
    );
  }
}

