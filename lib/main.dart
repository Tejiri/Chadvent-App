import 'dart:convert';
import 'dart:io';
import 'package:chadventmpcs/apihelpers/api.dart';
import 'package:chadventmpcs/generalhelpers/helpers.dart';
import 'package:chadventmpcs/models/accountmodel.dart';
import 'package:chadventmpcs/models/membermodel.dart';
import 'package:chadventmpcs/navigation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    method();
  }

  void method() async {
    await Future.delayed(Duration(seconds: 3), _navi);
  }

  Future<void> _navi() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 243, 239, 1),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage("assets/images/chadvent-logo.png"),
                  height: 150,
                ),
                Padding(padding: EdgeInsets.only(top: 50)),
                Text(
                  "Chadvent MPCS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'WorkSans',
                      fontSize: 35,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  var formatter = NumberFormat("#,###,000");
  var apiKey = "api_key=5fd2ac39-15d3-4935-a36a-509597984923";
  var totalContribution;
  var lasttransaction;
  var user;
  var modalState = false;

  @override
  void initState() {
    super.initState();
    initPref();
  }

  Future<void> _navi() async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => BottomNavigation(0)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: ModalProgressHUD(
            inAsyncCall: modalState,
            child: ListView(
              children: [
                Image.asset(
                  "assets/images/chadvent-logo.png",
                  height: 250,
                ),
                Text(
                  "Chadvent MPCS",
                  style: TextStyle(color: Colors.white, fontSize: 40),
                  textAlign: TextAlign.center,
                ),
                Padding(padding: EdgeInsets.only(bottom: 40)),
                Container(
                  margin: EdgeInsets.only(left: 30, right: 30),
                  child: TextField(
                    controller: username,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.greenAccent, width: 5.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                      labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      labelText: "Username",
                      hintText: 'Enter username',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      suffixStyle: TextStyle(color: Colors.yellow),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                  child: TextField(
                    obscureText: true,
                    controller: password,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.greenAccent, width: 5.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                      labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      labelText: "Password",
                      hintText: 'Enter password',
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                      suffixStyle: TextStyle(color: Colors.yellow),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                    child: ButtonTheme(
                      height: 50,
                      child: RaisedButton(
                        color: Color.fromRGBO(166, 97, 74, 1),
                        onPressed: () async {
                          setState(() {
                            modalState = true;
                          });
                          await checkForInternet().then((value) async {
                            if (value == true) {
                              await logUserIn(username.text, password.text)
                                  .then((value) {
                                if (value == true) {
                                  setState(() {
                                    modalState = false;
                                  });
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BottomNavigation(0)));
                                } else {
                                  setState(() {
                                    modalState = false;
                                  });
                                  showAlertMessage(
                                      "Login Failed", "Something went wrong");
                                }
                              });
                            } else {
                              setState(() {
                                modalState = false;
                              });
                              showAlertMessage("No Internet Connection",
                                  "Please connect to the internet and retry");
                            }
                          });
                        },
                        child: Text("Log in",
                            style: GoogleFonts.merriweather(
                              textStyle: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            )),
                      ),
                    )),
              ],
            )));
  }

  showAlertMessage(title, content) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("$title"),
              content: Text("$content"),
            ));
  }
}
