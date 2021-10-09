import 'package:flutter/material.dart';
import 'package:overlock/ui/news/newsList.dart';
import 'package:overlock/ui/sowon/SoWonList.dart';

import '../constants.dart';
import 'Youtubu/YoutubuList.dart';
import 'Youtubu/video_list.dart';
import 'Youtubu/youtubePlayer.dart';



class fixedBoards extends StatefulWidget {

  @override
  _fixedBoardsState createState() => _fixedBoardsState();
}

class _fixedBoardsState extends State<fixedBoards> {
  @override
  Widget build(BuildContext context) {


    int _myLegth = 4;

    return DefaultTabController(
      length: _myLegth,
      initialIndex: 1,
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
              Tab(
                text: "폭로",
              ),
              Tab(
                text: "이슈",
              ),
              Tab(
                text: "유머",
              ),
              Tab(
                text: "정보",
              ),
            ],
          ),
        ),
        body: TabBarView(children: <Widget>[
          soWonList(),
          newsList(),
          soWonList(),
          VideoList(),
          //listLevel(),
        ]),

      ),
    );
  }


}
