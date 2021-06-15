import 'package:flutter/material.dart';

import '../constants.dart';
import '../enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key key,
    @required this.selectedMenu,
  }) : super(key: key);


  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {

    return Container(
      color: kPrimaryColor,
      child: Container(
        height: 50,
        child: TabBar(
        labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.transparent,
          tabs: <Widget> [

            Tab(
              icon: Icon(Icons.auto_stories, size:18 ), child: Text('소원수리', style: TextStyle(fontSize: 12),),
            ),
            Tab(
              icon: Icon(Icons.how_to_vote, size:18 ), child: Text('투표', style: TextStyle(fontSize: 12),),
            ),
            Tab(
              icon: Icon(Icons.article_outlined, size:18 ), child: Text('토픽게시판', style: TextStyle(fontSize: 12),),
            ),
            Tab(
              icon: Icon(Icons.accessibility,size:18 ), child: Text('온라인동기', style: TextStyle(fontSize: 12),),
            ),

            // Tab(
            //   icon: Icon(Icons.article_outlined,  size:18 ), child: Text('계정정보', style: TextStyle(fontSize: 9),),
            // ),

            //계급별 게시판
          ],
        ),
      ),
    );
  }
}
