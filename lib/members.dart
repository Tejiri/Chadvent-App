import 'dart:convert';
import 'dart:io';

import 'package:chadventmpcs/apihelpers/api.dart';
import 'package:chadventmpcs/generalhelpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Members extends StatefulWidget {
  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> {
  var modalState = false;
  var apiKey = "api_key=5fd2ac39-15d3-4935-a36a-509597984923";
  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text(
    "Chadvent Members",
    style: TextStyle(color: Colors.white),
  );
  List<String> searchlist = [];
  List<String> membersList = [];
  List<String> newsList = [];
  SharedPreferences prefs;

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
        elevation: 0,
        title: cusSearchBar,
        //leading: Container(),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: cusIcon,
              onPressed: () {
                if (this.mounted) {
                  setState(() {
                    if (this.cusIcon.icon == Icons.search) {
                      searchlist = [];
                      this.cusIcon = Icon(Icons.cancel);
                      this.cusSearchBar = TextField(
                        onChanged: (value) async {
                          searchlist = [];
                          for (var i = 0; i < membersList.length; i++) {
                            final person = jsonDecode(membersList[i]);
                            if (person['firstname']
                                    .toString()
                                    .toLowerCase()
                                    .contains(value.toLowerCase()) ||
                                person['lastname']
                                    .toString()
                                    .toLowerCase()
                                    .contains(value.toLowerCase())) {
                              searchlist.add(jsonEncode(person));
                            }
                            setState(() {});

                            //jsonDecode(item[0]);

                          }
                        },
                        decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                            hintText: "Enter search here",
                            border: InputBorder.none),
                        textInputAction: TextInputAction.go,
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      );
                    } else {
                      this.cusIcon = Icon(Icons.search);
                      this.cusSearchBar = Text(
                        "Chadvent Members",
                        style: TextStyle(color: Colors.white),
                      );
                    }
                  });
                }
              })
        ],
      ),
      body: this.cusIcon.icon == Icons.search ? body1() : body2(),
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

  body1() {
    return RefreshIndicator(
      child: ListView.builder(
          itemCount: membersList.length,
          itemBuilder: (context, index) {
            final currentMember = jsonDecode(membersList[index]);
            final phonenumber = currentMember["phonenumber"].toString();
            final firstname = currentMember["firstname"];
            final lastname = currentMember["lastname"];
            return Container(
              decoration:
                  BoxDecoration(border: Border(bottom: BorderSide(width: 0.5))),
              padding:
                  EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(children: [
                      Container(
                        child: Image.asset("assets/images/chadvent-logo.png"),
                        height: 30,
                        padding: EdgeInsets.only(right: 10),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$firstname $lastname",
                            style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            "$phonenumber",
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
                  Container(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            _makePhoneCall('tel:$phonenumber');
                          },
                          child: Icon(
                            Icons.phone,
                            color: Color.fromRGBO(38, 48, 75, 1),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(right: 30)),
                        GestureDetector(
                          onTap: () async {
                            _sendSms('sms:$phonenumber');
                          },
                          child: Icon(
                            Icons.sms,
                            color: Color.fromRGBO(38, 48, 75, 1),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
      onRefresh: refreshScreen,
    );
  }

  body2() {
    print(searchlist);
    return RefreshIndicator(
      child: ListView.builder(
          itemCount: searchlist.length,
          itemBuilder: (context, index) {
            final currentMember = jsonDecode(searchlist[index]);
            final phonenumber = currentMember["phonenumber"].toString();
            final firstname = currentMember["firstname"];
            final lastname = currentMember["lastname"];
            return Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 0.5, color: Colors.black))),
              padding:
                  EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(children: [
                      Container(
                        child: Image.asset("assets/images/chadvent-logo.png"),
                        height: 30,
                        padding: EdgeInsets.only(right: 10),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$firstname $lastname",
                            style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            "$phonenumber",
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
                  Container(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            _makePhoneCall('tel:$phonenumber');
                          },
                          child: Icon(
                            Icons.phone,
                            color: Color.fromRGBO(38, 48, 75, 1),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(right: 30)),
                        GestureDetector(
                          onTap: () async {
                            _sendSms('sms:$phonenumber');
                          },
                          child: Icon(
                            Icons.sms,
                            color: Color.fromRGBO(38, 48, 75, 1),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
      onRefresh: refreshScreen,
    );
  }

  getInitialSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        membersList = prefs.getStringList("membersList");
        newsList = prefs.getStringList("newsList");
      });
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

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _sendSms(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
