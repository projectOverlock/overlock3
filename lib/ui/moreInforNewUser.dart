import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:overlock/AdsTest/AdmobHelper.dart';
import 'package:overlock/router/ui_pages.dart';
import 'package:overlock/ui/userInfo/LevelSelector.dart';
import 'package:overlock/ui/userInfo/MilSelector.dart';
import 'package:overlock/ui/userInfo/datePicker.dart';
import 'package:overlock/ui/userInfo/moreInformation.dart';
import 'package:overlock/ui/userInfo/nickNameChange.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../constants.dart';
import '../main.dart';
import 'list_items.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;


class moreInforNewUser extends StatefulWidget {

  @override
  _moreInforNewUserState createState() => _moreInforNewUserState();
}

class _moreInforNewUserState extends State<moreInforNewUser> {

  @override
  Widget build(BuildContext context) {

    String userID = FirebaseAuth.instance.currentUser.uid;

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final double _horizontalPadding = 11.0;
    final double _verticalPadding =10.0;
    final double _cardElevation =4;
    final appState = Provider.of<AppState>(context, listen: false);
    AdmobHelper admobHelper = new AdmobHelper();


    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        title: const Text(
          '추가정보 입력',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),

      body: Container(
          color: Colors.grey[100],
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
                child: InkWell(

                  child: Card(
                    color: Colors.white70,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: <Widget>[
                          Text("내정보"),
                          Divider(),
                          Text('내 이메일 : ${_auth.currentUser.email}'),
                          Divider(),
                          Text('내 닉네임 : ${_auth.currentUser.displayName}'),
                          // Divider(),
                          // Text('관심 계급 : ${list1Name.getList1Name()}'),
                          // Divider(),
                          // Text('관심 병과 : ${list2Name.getList2Name()}'),
                          // Divider(),
                          // Text('관심 기수 : ${list3Name.getList3Name()}'),
                          // Divider(),
                          // Text('관심 부대 : ${list4Name.getList4Name()}'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
                child: InkWell(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => nickNameChange()));
                   // admobHelper.loadRewardedAd();
                    appState.currentAction = PageAction(
                        state: PageState.addWidget, page: WritnickNameChangeConfig, widget: nickNameChange());
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Container(
                      height: 40,
                      child: Center(child: Text("닉네임 설정")),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
                child: InkWell(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => levelSelector()));
                    appState.currentAction = PageAction(
                    state: PageState.addWidget, page: levelSelectorConfig, widget: levelSelector());
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Container(
                      height: 40,
                      child: Center(child: Text("관심 계급 설정")),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
                child: InkWell(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => milSelector()));
                    appState.currentAction = PageAction(
                    state: PageState.addWidget, page: milSelectorConfig, widget: milSelector());
  },
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Container(
                      height: 40,
                      child: Center(child: Text("관심 병과 설정")),
                    ),
                  ),
                ),
              ),
              _auth.currentUser.uid == 'w52YDoBc14WwHj2MjKGcngcjszg1' ?
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
                child: InkWell(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => datePicker()));
                    appState.currentAction = PageAction(
                        state: PageState.addWidget, page: datePickerConfig, widget: datePicker());
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Container(
                      height: 40,
                      child: Center(child: Text("관심 기수 설정")),
                    ),
                  ),
                ),
              ):
              Container(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
                child: InkWell(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => moreInformation()));
                    appState.currentAction = PageAction(
                        state: PageState.addWidget, page: moreInformationConfig, widget: moreInformation());
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Container(
                      height: 40,
                      child: Center(child: Text("관심 부대 설정")),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
                child: InkWell(
                  onTap: ()  {
                    // setState(() {
                    //   // appState.login();
                    //   ListItems();
                    //
                    // });
                    //  Navigator.of(context).pop();
                    //
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (_) => ListItems(),
                    //   ),
                    // );
                    //appState.login();
                    // PageAction(
                    //     state: PageState.addPage, page: ListItemsPageConfig, widget:ListItems());
                    appState.currentAction = PageAction(state: PageState.replaceAll, page: ListItemsPageConfig, widget:moreInforNewUser() ); //메인페이지로 이동시킨다.

                   // PageAction(state: PageState.replaceAll, page: ListItemsPageConfig);
                  },
                  child: Card(
                    color: kPrimaryColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Container(
                      height: 40,
                      child: Center(child: Text("설정 완료", style: TextStyle(color: Colors.white),)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),


    );
  }
}
