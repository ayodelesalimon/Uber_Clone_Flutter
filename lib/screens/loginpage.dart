import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uber_clone/resources/brand_colors.dart';
import 'package:uber_clone/screens/homepage.dart';
import 'package:uber_clone/screens/registerpage.dart';
import 'package:uber_clone/widgets/taxibutton.dart';

class LoginPage extends StatefulWidget {
  static String id = 'login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
//initialize FireBase Auth

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Controller for reg form

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  //Create snackBar to display error
  void showSnackBar(String title) {
    final snackBar = new SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15.0),
      ),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }
//sign in user
  void signInWithEmailAndPassword() async {
    final User user = (await _auth
            .signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )
            .catchError((ex) {
      //check for error and display it.
      PlatformException thisEX = ex;
      showSnackBar(thisEX.message);
    }))
        .user;

    if (user != null) {

      //check user on database
      DatabaseReference userRef =
          FirebaseDatabase.instance.reference().child('users/${user.uid}');

      userRef.once().then((DataSnapshot snapShot) {
        if (snapShot.value != null) {
          Navigator.pushNamedAndRemoveUntil(context, Home.id, (route) => false);
        }
      });
    }

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Image(
                  height: 100,
                  width: 100,
                  alignment: Alignment.center,
                  image: AssetImage('images/logo.png'),
                ),
              ),
              SizedBox(height: 30),
              Text("Sign In As Rider",
                  style: TextStyle(
                      fontSize: 20.0, color: BrandColors.colorTextDark)),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  style: TextStyle(fontFamily: 'Brand-Regular'),
                  decoration: InputDecoration(
                      hoverColor: BrandColors.colorGreen,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.0)),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                          color: BrandColors.colorGreen, fontSize: 15.0),
                      focusColor: BrandColors.colorAccent1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  obscureText: true,
                  style: TextStyle(fontFamily: 'Brand-Regular'),
                  decoration: InputDecoration(
                      hoverColor: BrandColors.colorGreen,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.0)),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                          color: BrandColors.colorGreen,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w800),
                      focusColor: BrandColors.colorAccent1),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              TaxiButton(
                title: "LOGIN",
                color: BrandColors.colorGreen,
                onPressed: () async {
                  // check for network coonnectivity
                  var connectResult = new Connectivity().checkConnectivity();
                  // ignore: unrelated_type_equality_checks
                  if (connectResult != ConnectivityResult.mobile &&
                      // ignore: unrelated_type_equality_checks
                      connectResult != ConnectivityResult.wifi) {
                    showSnackBar('No network connectivity');
                    return;
                  }
                  //validation of the form to check if the username input correct data
                  if (!emailController.text.contains("@") &&
                      emailController.text.length != 3) {
                    showSnackBar('Kindly enter a valid email');
                    return;
                  }

                  if (passwordController.text.length < 8) {
                    showSnackBar('Password must be aleast 8 characters');
                    return;
                  }
                  signInWithEmailAndPassword();
                },
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RegisterPage.id, (route) => false);
                    // Navigator.push(context,
                    //           MaterialPageRoute(builder: (context) => RegisterPage()));
                  },
                  child: Text('Don\'t have an account, Sign up here'))
            ],
          ),
        ),
      ),
    );
  }
}
