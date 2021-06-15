import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlock/constants.dart';
import 'package:overlock/router/ui_pages.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';
import 'SoWonList.dart';

final _valueList = ['폭언', '폭행', '성추행성폭행', '소원수리'];
var _selectedValue = '폭언';

class soWonMain extends StatefulWidget {
  @override
  _soWonMainState createState() => _soWonMainState();
}

class _soWonMainState extends State<soWonMain> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    return DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: TabBar(
                labelColor: Colors.black,
                tabs: [
                  Tab(
                    text: "전체",
                  ),
                  Tab(
                    text: "분야별",
                  ),
                  Tab(
                    text: "답변대기",
                  ),
                  Tab(
                    text: "답변완료",
                  ),
                ],
              ),
            ),
            body: TabBarView(children: [
              soWonList(),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
              Icon(Icons.directions_car),
            ]),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              //onPressed: showCreateDocDialog,
              onPressed: () => appState.currentAction =
                  PageAction(state: PageState.addPage, page: WriteSoWonPageConfig),
              backgroundColor: kPrimaryColor,
            )));
  }
}
