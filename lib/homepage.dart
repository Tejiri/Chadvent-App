import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chadventmpcs/apihelpers/api.dart';
import 'package:chadventmpcs/generalhelpers/helpers.dart';
import 'package:chadventmpcs/main.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences prefs;

  var username;
  var totalContribution;
  var lasttransaction;
  var sharecapital;
  var thriftsavings;
  var specialdeposit;
  var commoditytrading;
  var fine;
  var loan;
  var projectfinancing;
  var title;
  var firstname;
  var lastname;
  var middlename;
  var position;
  var membershipstatus;
  var loanapplicationstatus;
  var phonenumber;
  var email;
  var address;
  var gender;
  var occupation;
  var nextofkin;
  var nextofkinaddress;
  var apiKey = "api_key=5fd2ac39-15d3-4935-a36a-509597984923";
  Widget lastTransactionTextWidget;
  List<String> newsList = [];

  @override
  void initState() {
    super.initState();

    getInitialSharedPreferences();
  }

  void handleClick(String value) {
    switch (value) {
      case 'Settings':
        break;
      case 'Logout':
        prefs.clear();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()));
        break;
    }
  }

  getInitialSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        username = prefs.getString("username");
        totalContribution =
            performFormating(prefs.getString("totalcontribution"));
        sharecapital = performFormating(prefs.getString("sharecapital"));
        thriftsavings = performFormating(prefs.getString("thriftsavings"));
        specialdeposit = performFormating(prefs.getString("specialdeposit"));
        commoditytrading =
            performFormating(prefs.getString("commoditytrading"));
        fine = performFormating(prefs.getString("fine"));
        loan = performFormating(prefs.getString("loan"));
        projectfinancing =
            performFormating(prefs.getString("projectfinancing"));
        title = prefs.getString("title");
        firstname = prefs.getString("firstname");
        lastname = prefs.getString("lastname");
        middlename = prefs.getString("middlename");
        position = prefs.getString("position");
        membershipstatus = prefs.getString("membershipstatus");
        loanapplicationstatus = prefs.getString("loanapplicationstatus");
        phonenumber = prefs.getString("phonenumber");
        email = prefs.getString("email");
        address = prefs.getString("address");
        gender = prefs.getString("gender");
        occupation = prefs.getString("occupation");
        nextofkin = prefs.getString("nextofkin");
        nextofkinaddress = prefs.getString("nextofkinaddress");
        lasttransaction = json.decode(prefs.getString("lasttransaction"));
        newsList = prefs.getStringList("newsList");
      });
    }

    if (lasttransaction['transactiontype'] == "credit") {
      if (mounted) {
        setState(() {
          lastTransactionTextWidget = Text(
            "Credit of ${performFormating(lasttransaction['amount'] + ".00")} on ${lasttransaction['account']} account",
            style: GoogleFonts.merriweather(
                textStyle: TextStyle(color: Colors.green)),
          );
        });
      }
    } else if (lasttransaction['transactiontype'] == "debit") {
      if (mounted) {
        setState(() {
          lastTransactionTextWidget = Text(
            "Debit of ${performFormating(lasttransaction['amount'] + ".00")} on ${lasttransaction['account']} account ",
            style: GoogleFonts.merriweather(
                textStyle: TextStyle(color: Colors.red)),
          );
        });
      }
    } else if (lasttransaction['transactiontype'] == null) {
      var naira = "0.00";
      if (mounted) {
        setState(() {
          lastTransactionTextWidget = Text(
            "${performFormating(naira)}",
            style: GoogleFonts.merriweather(
                textStyle: TextStyle(color: Colors.red)),
          );
        });
      }
    }
  }

  accountsWidget(accountTitle, accountBalance) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      margin: EdgeInsets.only(
        bottom: 15,
      ),
      child: Row(
        children: [
          Container(
              margin: EdgeInsets.only(left: 20, right: 10),
              child: Container(
                padding: EdgeInsets.only(top: 5),
                child: Image.asset(
                  "assets/images/money.png",
                  height: 30,
                ),
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$accountTitle",
                style: GoogleFonts.merriweather(
                    textStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              accountBalance == null
                  ? CircularProgressIndicator()
                  : Text("$accountBalance")
            ],
          ),
        ],
      ),
    );
  }

  Future<Null> refreshScreen() async {
    try {
      await checkForInternet().then((value) async {
        if (value) {
          await savePrefs().then((value) {
            getInitialSharedPreferences();
            return null;
          });
        } else {
          return showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Refresh Failed"),
                    content: Text(
                        "Please connect to the internet and try to refresh again"),
                  ));
        }
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(38, 48, 75, 1),
        title: firstname == null || lastname == null
            ? CircularProgressIndicator()
            : Text(
                "Hello, $firstname $lastname",
                style: GoogleFonts.merriweather(),
              ),
        actions: [
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Settings', 'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        child: ListView(
          children: [
            Stack(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  color: Color.fromRGBO(38, 48, 75, 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 30, top: 15),
                        child: Text(
                          "Total Contribution",
                          style: GoogleFonts.merriweather(
                              textStyle: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                        ),
                      ),
                      totalContribution == null
                          ? CircularProgressIndicator()
                          : Container(
                              margin: EdgeInsets.only(left: 30, top: 3),
                              child: Text(
                                "$totalContribution",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                      Container(
                        margin: EdgeInsets.only(left: 30, top: 15),
                        child: Text(
                          "Last transaction",
                          style: GoogleFonts.merriweather(
                              textStyle: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 30, top: 3),
                          child: lastTransactionTextWidget),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 190, left: 20, right: 20),
                  // decoration: BoxDecoration(color: Colors.green),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 3, bottom: 10),
                        child: Text(
                          "Your Accounts",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      sharecapital == null
                          ? CircularProgressIndicator()
                          : accountsWidget("Share Capital", "$sharecapital"),
                      thriftsavings == null
                          ? CircularProgressIndicator()
                          : accountsWidget("Thrift Savings", "$thriftsavings"),
                      specialdeposit == null
                          ? CircularProgressIndicator()
                          : accountsWidget(
                              "Special deposit", "$specialdeposit"),
                      commoditytrading == null
                          ? CircularProgressIndicator()
                          : accountsWidget(
                              "Commodity Trading", "$commoditytrading"),
                      fine == null
                          ? CircularProgressIndicator()
                          : accountsWidget("Fine", "$fine"),
                      loan == null
                          ? CircularProgressIndicator()
                          : accountsWidget("Loan", "$loan"),
                      projectfinancing == null
                          ? CircularProgressIndicator()
                          : accountsWidget(
                              "Project Financing", "$projectfinancing")
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onRefresh: refreshScreen,
      ),
      drawer: Drawer(
        child: ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              var currentItem = json.decode(newsList[index]);
              String date = currentItem['date'];
              var splitDate = date.split("-");
              final birthday = DateTime(int.parse(splitDate[0]),
                  int.parse(splitDate[1]), int.parse(splitDate[2]));
              final date2 = DateTime.now();
              final difference = date2.difference(birthday).inDays;
              return index == 0
                  ? Column(
                      children: [
                        AppBar(
                          title: Text("Announcements"),
                          leading: Container(),
                          backgroundColor: Color.fromRGBO(38, 48, 75, 1),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.only(
                                    left: 20, bottom: 20, top: 20, right: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${currentItem['title']}",
                                      style: GoogleFonts.merriweather(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25)),
                                    ),
                                    Text(
                                      "${currentItem['content']}",
                                      style: GoogleFonts.merriweather(
                                          textStyle: TextStyle(fontSize: 17)),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Text(
                                        "${currentItem['date']} ($difference days ago)",
                                        style: GoogleFonts.merriweather(
                                            textStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    38, 48, 75, 1),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12)),
                                      ),
                                    ),
                                  ],
                                )),
                            Divider(
                              thickness: 1,
                              color: Colors.black,
                            )
                          ],
                        )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin:
                                EdgeInsets.only(left: 20, bottom: 20, top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${currentItem['title']}",
                                  style: GoogleFonts.merriweather(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25)),
                                ),
                                Text(
                                  "${currentItem['content']}",
                                  style: GoogleFonts.merriweather(
                                      textStyle: TextStyle(fontSize: 17)),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Text(
                                    "${currentItem['date']} ($difference days ago)",
                                    style: GoogleFonts.merriweather(
                                        textStyle: TextStyle(
                                            color:
                                                Color.fromRGBO(38, 48, 75, 1),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12)),
                                  ),
                                ),
                              ],
                            )),
                        Divider(
                          thickness: 1,
                          color: Colors.black,
                        )
                      ],
                    );
            }),
      ),
    );
  }
}
