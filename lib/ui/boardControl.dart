import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlock/ui/Topic/list4.dart';
import 'package:overlock/ui/Topic/list2.dart';
import 'package:overlock/ui/Topic/list3.dart';
import 'package:overlock/ui/sowon/SoWonList.dart';
import '../constants.dart';
import 'Topic/list1.dart';

//익명게시판
final FirebaseAuth _auth = FirebaseAuth.instance;

class boardContol extends StatefulWidget {
  final String mylevel;
  final String miltype;
  final String joinMilitary;
  final String corpType;

  boardContol(this.mylevel, this.miltype, this.joinMilitary, this.corpType);


  @override
  _boardContolState createState() => _boardContolState();
}

class _boardContolState extends State<boardContol> {
  @override
  Widget build(BuildContext context) {


    int _myLegth = 4;

    return DefaultTabController(
      length: _myLegth,
      initialIndex: 2,
      child: Scaffold(
        appBar:

        AppBar(
          toolbarHeight: 55,

          backgroundColor: kPrimaryColor,
          //title: myTopBar(),
          bottom: TabBar(
            isScrollable: false,
            indicatorColor: kPrimaryColor,
            unselectedLabelColor: Colors.white.withOpacity(0.3),

            labelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            tabs: [
              // Tab(
              //   text: "폭로",
              // ),
              Tab(
                text: "${widget.mylevel}",
              ),
              Tab(
                text: "${widget.miltype}",
              ),
              Tab(
                text: "동기",
              ),
              Tab(
                text: "${widget.corpType}",
              ),

            ],
          ),
        ),
        body: TabBarView(children: <Widget>[
          // soWonList(),
          list1(widget.mylevel),
          list2(widget.miltype),
          list3(widget.joinMilitary),
          list4(widget.corpType),

          //listLevel(),
        ]),

      ),
    );
  }
}
