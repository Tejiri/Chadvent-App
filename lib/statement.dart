import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chadventmpcs/apihelpers/api.dart';
import 'package:chadventmpcs/generalhelpers/helpers.dart';
import 'package:chadventmpcs/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Statement extends StatefulWidget {
  @override
  _StatementState createState() => _StatementState();
}

class _StatementState extends State<Statement> {
  var apiKey = "api_key=5fd2ac39-15d3-4935-a36a-509597984923";
  SharedPreferences prefs;
  List<String> newsList = [];
  List<String> totalContributionList = [];
  List<String> commodityTradingList = [];
  List<String> fineList = [];
  List<String> loanList = [];
  List<String> projectFinancingList = [];
  var totalContribution;
  var totalCommodityTrading;
  var totalFine;
  var totalLoan;
  var totalProjectFinancing;
  var username;
  var formatter = NumberFormat("#,###,000");
  List<String> statementToDisplay = [];
  String accountSelected;
  Text closingBalance;
  var accounts = [
    "Total Contribution",
    "Commodity Trading",
    "Fine",
    "Loan",
    "Project Financing"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitialSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(38, 48, 75, 1),
        title: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Color.fromRGBO(38, 48, 75, 1),
            ),
            child: new DropdownButton<String>(
              autofocus: false,
              isExpanded: true,
              icon: Icon(
                Icons.arrow_downward,
                color: Colors.white,
              ),
              underline: DropdownButtonHideUnderline(
                child: new Container(),
              ),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20),
              hint: Text(
                "Select an account",
                style: TextStyle(
                    fontFamily: 'WorkSans',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20),
              ),
              items: accounts.map((String dropitem) {
                return DropdownMenuItem<String>(
                    value: dropitem,
                    child: Text(
                      dropitem,
                      style: TextStyle(
                        fontFamily: 'WorkSans',
                      ),
                    ));
              }).toList(),
              onChanged: (String newitem) {
                if (this.mounted) {
                  setState(() {
                    this.accountSelected = newitem;
                  });
                  setStatementToDisplay();
                }
              },
              value: accountSelected,
            )),
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
        child: Column(
          children: [
            closingBalance == null
                ? Text(
                    "Please select an account to display transaction history",
                    style: GoogleFonts.merriweather(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )
                : Container(),
            closingBalance == null
                ? Container()
                : Container(
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 0.5)),
                        color: Colors.purple[100]),
                    padding: EdgeInsets.only(
                        top: 20, bottom: 20, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(children: [
                            Container(
                              child: Image.asset("assets/images/money.png"),
                              height: 20,
                              padding: EdgeInsets.only(right: 10),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Closing Balance",
                                  style: GoogleFonts.merriweather(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ],
                            )
                          ]),
                        ),
                        closingBalance == null ? Container() : closingBalance
                      ],
                    ),
                  ),
            Expanded(
              child: ListView.builder(
                itemCount: statementToDisplay.length,
                itemBuilder: (context, index) {
                  var currentTransaction =
                      jsonDecode(statementToDisplay[index]);
                  var transactiontype = currentTransaction['transactiontype'];
                  var account = currentTransaction['account'];
                  var amount = currentTransaction['amount'];
                  var narration = currentTransaction['narration'];
                  var date = currentTransaction['date'];
                  return Container(
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 0.5))),
                    padding: EdgeInsets.only(
                        top: 20, bottom: 20, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(children: [
                            Container(
                              child: Image.asset("assets/images/money.png"),
                              height: 30,
                              padding: EdgeInsets.only(right: 10),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  narration,
                                  style: GoogleFonts.merriweather(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(
                                  "account - " + account,
                                  style: GoogleFonts.merriweather(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(
                                  date,
                                  style: GoogleFonts.merriweather(
                                      textStyle: TextStyle(
                                          color: Color.fromRGBO(38, 48, 75, 1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                ),
                              ],
                            )
                          ]),
                        ),
                        transactiontype == "credit"
                            ? Text(
                                performFormating(amount),
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text(
                                performFormating(amount),
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
        onRefresh: refreshScreen,
      ),
      drawer: Drawer(
        child: ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              final currentNews = jsonDecode(newsList[index]);
              String date = currentNews['date'];
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
                                    left: 20, bottom: 20, top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${currentNews['title']}",
                                      style: GoogleFonts.merriweather(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25)),
                                    ),
                                    Text(
                                      "${currentNews['content']}",
                                      style: GoogleFonts.merriweather(
                                          textStyle: TextStyle(fontSize: 15)),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Text(
                                        "${currentNews['date']} ($difference days ago)",
                                        style: GoogleFonts.merriweather(
                                            textStyle: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
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
                                  "${currentNews['title']}",
                                  style: GoogleFonts.merriweather(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25)),
                                ),
                                Text(
                                  "${currentNews['content']}",
                                  style: GoogleFonts.merriweather(
                                      textStyle: TextStyle(fontSize: 15)),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Text(
                                    "${currentNews['date']} ($difference days ago)",
                                    style: GoogleFonts.merriweather(
                                        textStyle: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
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

  getInitialSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        totalContribution = prefs.getString("totalcontribution");
        totalCommodityTrading = prefs.getString("commoditytrading");
        totalFine = prefs.getString("fine");
        totalLoan = prefs.getString("loan");
        totalProjectFinancing = prefs.getString("projectfinancing");
        totalContributionList = prefs.getStringList("totalContributionList");
        commodityTradingList = prefs.getStringList("commodityTradingList");
        fineList = prefs.getStringList("fineList");
        loanList = prefs.getStringList("loanList");
        projectFinancingList = prefs.getStringList("projectFinancingList");
        newsList = prefs.getStringList("newsList");
      });
    }

    setStatementToDisplay();
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

  setStatementToDisplay() {
    if (accountSelected == "Total Contribution") {
      setState(() {
        statementToDisplay = totalContributionList;
        closingBalance = Text(
          performFormating(totalContribution.toString()),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        );
      });
    } else if (accountSelected == "Commodity Trading") {
      setState(() {
        statementToDisplay = commodityTradingList;
        closingBalance = Text(
          performFormating(totalCommodityTrading.toString()),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        );
      });
    } else if (accountSelected == "Fine") {
      setState(() {
        statementToDisplay = fineList;
        closingBalance = Text(
          performFormating(totalFine.toString()),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        );
      });
    } else if (accountSelected == "Loan") {
      setState(() {
        statementToDisplay = loanList;
        closingBalance = Text(
          performFormating(totalLoan.toString()),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        );
      });
    } else if (accountSelected == "Project Financing") {
      setState(() {
        statementToDisplay = projectFinancingList;
        closingBalance = Text(
          performFormating(totalProjectFinancing.toString()),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        );
      });
    }
  }
}
