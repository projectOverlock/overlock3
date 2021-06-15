import 'package:flutter/material.dart';
import 'package:overlock/Chat/HomeScreen.dart';
import 'package:overlock/components/coustom_bottom_nav_bar.dart';
import 'package:overlock/ui/boardControl.dart';
import 'Poll/pollMainStackedCard.dart';
import 'sowon/SoWonMain.dart';
//로그인 후 첫번째 페이지

class ListItems extends StatelessWidget {



  @override
  Widget build(BuildContext context) {


    return MaterialApp(


      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        initialIndex: 2,
        length: 4,
        child: Scaffold(
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              soWonMain(),
              stackedCardMain(),
              boardContol(),
              HomeScreen(),
              //CompleteProfileScreen(),
            ],
          ),
          bottomNavigationBar: CustomBottomNavBar(),
        ),
      ),
    );
  }
}
