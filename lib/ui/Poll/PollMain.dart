import 'package:flutter/material.dart';
import 'package:overlock/constants.dart';
import 'package:overlock/ui/Poll/pollMainStackedCard.dart';
import 'package:overlock/ui/Poll/requestPoll.dart';

class pollMain extends StatefulWidget {

  @override
  _pollMainState createState() => _pollMainState();
}

class _pollMainState extends State<pollMain> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: kPrimaryColor,

            title: TabBar(
              indicatorColor: kPrimaryColor,

              labelColor: Colors.white,
              tabs: [
                Tab(
                  text: "투표",
                ),

                Tab(
                  text: "투표 요청",
                ),

              ],
            ),
          ),
          body: TabBarView(children: [
            stackedCardMain(),
            requstPoll(),

          ]),
        ));
  }
}