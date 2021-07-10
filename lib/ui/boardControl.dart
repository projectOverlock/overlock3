import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlock/router/ui_pages.dart';
import 'package:overlock/ui/Topic/lisTip.dart';
import 'package:overlock/ui/Topic/listHobby.dart';
import 'package:overlock/ui/Topic/listHumor.dart';
import 'package:overlock/ui/Topic/listLevel.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../constants.dart';
import 'Topic/listCreator2.dart';
import 'cart.dart';

//익명게시판


class boardContol extends StatefulWidget {
  @override
  _boardContolState createState() => _boardContolState();
}


class _boardContolState extends State<boardContol> {


  @override
  Widget build(BuildContext context) {

    int _myLegth = 5;
    return DefaultTabController(

      length: _myLegth,
      initialIndex: 2,
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 55,

            backgroundColor: kPrimaryColor,
            //title: myTopBar(),
            bottom: TabBar(

              indicatorColor: kPrimaryColor,
              labelColor: Colors.white,
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              tabs: [
                Tab(
                  text: "꿀팁",
                ),
                Tab(
                  text: "취미",
                ),
                Tab(
                  text: "계급",
                ),
                Tab(
                  text: "유머",
                ),
                Tab(
                  text: "제작",
                )
              ],
            ),

          ),
          body: TabBarView(children: <Widget>[
            listTip(),
            listHobby(),
            listLevel(),
            listHumor(),
            listCreator2(),
          ]),
          // floatingActionButton: FloatingActionButton(
          //   child: Icon(Icons.add),
          //   //onPressed: showCreateDocDialog,
          //   onPressed: () => appState.currentAction =
          //       PageAction(state: PageState.addPage, page: CartPageConfig),
          //   backgroundColor: kPrimaryColor,
          // )
      ),
    );
  }
}
