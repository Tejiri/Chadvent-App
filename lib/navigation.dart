import 'package:chadventmpcs/homepage.dart';
import 'package:chadventmpcs/members.dart';
import 'package:chadventmpcs/statement.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  int selectedindex;
  BottomNavigation(this.selectedindex);
  @override
  _BottomNavigationState createState() => _BottomNavigationState(selectedindex);
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectedindex;
  var username;

  _BottomNavigationState(this.selectedindex);

  var count = 0;

  @override
  void initState() {
    super.initState();
   }


  List<Widget> _children = [HomePage(), Statement(), Members()];
  void _onTap(int index) {
       if(this.mounted){
    setState(() {
      selectedindex = index;
    });}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[selectedindex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
               
            label: "Home",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.money), label: "Transactions"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Members"),
        ],
        currentIndex: selectedindex,
        selectedItemColor: Color.fromRGBO(38, 48, 75, 1),
        onTap: _onTap,
      ),
    );
  }
}
