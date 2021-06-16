import 'package:flutter/material.dart';
import 'package:overlock/Chat/HomeScreen.dart';
import 'package:overlock/components/coustom_bottom_nav_bar.dart';
import 'package:overlock/ui/boardControl.dart';
import 'Poll/pollMainStackedCard.dart';
import 'sowon/SoWonMain.dart';

//로그인 후 메인페이지 입니다.

class ListItems extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 베너 제거
      
      home: DefaultTabController( // 탭컨트롤 
        initialIndex: 2, // 초기인덱스는 익명게시판으로 설정
        length: 4,
        child: Scaffold(
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(), //좌우 스크롤 안되도록 설정
            children: <Widget>[
              soWonMain(), //소원수리 게시판
              stackedCardMain(), // 투표 게시판
              boardContol(), // 익명게시판
              HomeScreen(), // 온라인 동기 게시판
              //CompleteProfileScreen(),
            ],
          ),
          bottomNavigationBar: CustomBottomNavBar(), //바텀바
        ),
      ),
    );
  }
}
