import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uber_clone/resources/brand_colors.dart';
import 'package:uber_clone/screens/loginpage.dart';
import 'package:uber_clone/widgets/taxibutton.dart';

class RegisterPage extends StatefulWidget {
  static String id = 'register';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
  //initialize FireBase Auth

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Controller for reg form
  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

//dispose email and passowrd form
  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // code for registration of new user.
  void registerUser() async {
    final User user = (await _auth
            .createUserWithEmailAndPassword(
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
      //Create database to store the user data to Firestore
      DatabaseReference newUserReg =
          FirebaseDatabase.instance.reference().child('users/${user.uid}');

      Map userMap = {
        'fullname': fullNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
      };
      newUserReg.set(userMap);

      //If login is successful print success

      print("Registration Sucessful");

      //Take the user to Login
      Navigator.pushNamedAndRemoveUntil(
          context, LoginPage.id, (route) => false);

      // setState(() {
      //   _success = true;
      //   _userEmail = user.email;
      // });
    } else {
      // _success = false;
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
              Text("Create An Account As Rider",
                  style: TextStyle(
                      fontSize: 20.0, color: BrandColors.colorTextDark)),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: fullNameController,
                  style: TextStyle(fontFamily: 'Brand-Regular'),
                  decoration: InputDecoration(
                      hoverColor: BrandColors.colorGreen,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.0)),
                      labelText: 'Full Name',
                      labelStyle: TextStyle(
                          color: BrandColors.colorGreen, fontSize: 15.0),
                      focusColor: BrandColors.colorAccent1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: emailController,
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
                  controller: phoneController,
                  style: TextStyle(fontFamily: 'Brand-Regular'),
                  decoration: InputDecoration(
                      hoverColor: BrandColors.colorGreen,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.0)),
                      labelText: 'Phone',
                      labelStyle: TextStyle(
                          color: BrandColors.colorGreen, fontSize: 15.0),
                      focusColor: BrandColors.colorAccent1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: TextStyle(fontFamily: 'Brand-Regular'),
                  decoration: InputDecoration(
                      hoverColor: BrandColors.colorGreen,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.0)),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                          color: BrandColors.colorGreen, fontSize: 15.0),
                      focusColor: BrandColors.colorAccent1),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TaxiButton(
                title: "REGISTER",
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
                  if (emailController.text.contains("@") &&
                      emailController.text.length != 3) {
                    showSnackBar(
                        'Email is invalid, kindly enter a valid email');
                    return;
                  }
                  if (fullNameController.text.length < 3) {
                    showSnackBar('Kindly enter a valid email');
                    return;
                  }
                  if (phoneController.text.length < 10) {
                    showSnackBar('Kindly enter a valid phone number');
                    return;
                  }
                  if (passwordController.text.length < 8) {
                    showSnackBar('Password must be aleast 8 characters');
                    return;
                  }
                  registerUser();
                },
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginPage.id, (route) => false);
                  },
                  child: Text('Already have an account, Login here'))
            ],
          ),
        ),
      ),
    );
  }
}
