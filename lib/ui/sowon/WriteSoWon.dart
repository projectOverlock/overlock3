import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';


String colName = "sowon";

// 필드명
final String fnName = "name";
final String fnDescription = "description";
final String fnDatetime = "datetime";
final String recomand = "Recomand";
final String fnCatagory = "Catagory";
final String userID = "userID";
final String pageView = "pageView";
final String likes = "likes";
final String replys = "replys";
 String _selectedValue = '폭언';
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
String id = '';
String nickname = 'default';
SharedPreferences prefs;
final _valueList = ['폭언', '폭행', '성추행','성폭행','소원수리', '불평등','부조리','비리'];
final int _Recomand =0;
final FirebaseAuth _auth = FirebaseAuth.instance;


class writeSoWon extends StatefulWidget {
  @override
  _writeSoWonState createState() => _writeSoWonState();
}

class _writeSoWonState extends State<writeSoWon> {
  @override
  TextEditingController _newNameCon = TextEditingController();
  TextEditingController _newDescCon = TextEditingController();


  Widget build(BuildContext context) {

    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseAuth.currentUser.uid.toString())
        .get()
        .then((doc) {
      nickname = doc["name"];
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        title: const Text(
          '소원수리 작성',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_library_add),
            onPressed: () {
              if (_newDescCon.text.isNotEmpty && _newNameCon.text.isNotEmpty) {
                createDoc(_newNameCon.text, _newDescCon.text, _selectedValue, nickname);
              }
              _newNameCon.clear();
              _newDescCon.clear();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            DropdownButton(
              isExpanded: true,
              value: _selectedValue,
              items: _valueList.map((value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            SizedBox(
              height: 50,
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(labelText: "제목을 작성하세요"),
                controller: _newNameCon,
              ),
            ),
            Flexible(
              child: TextField(
                maxLines: null,
                minLines: null,
                expands: true,
                style:  Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(
                    color: Colors.black,
                    fontSize: 14,
                    letterSpacing: 0.2,
                    height: 1.5),
                decoration: InputDecoration(

                  alignLabelWithHint: true,
                  labelText: "내용을 작성하세요",
                  hintStyle: TextStyle(
                      fontSize: 14,
                      letterSpacing: 0.2,
                      height: 1.2),
                ),
                controller: _newDescCon,
              ),
            ),
            SizedBox(
              height: 50,
              child: Row(
                children: <Widget>[
                  TextButton(
                    child: Text("취소", style: TextStyle(color: Colors.black),),
                    onPressed: () {
                      _newNameCon.clear();
                      _newDescCon.clear();
                      Navigator.pop(context);
                    },
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right :8.0),
                    child: TextButton(
                      child: Text("문서작성"),
                      onPressed: () {

                        if (_newDescCon.text.isNotEmpty &&
                            _newNameCon.text.isNotEmpty) {
                          createDoc(_newNameCon.text, _newDescCon.text, _selectedValue, nickname );

                          _newNameCon.clear();
                          _newDescCon.clear();
                          Navigator.pop(context);
                        }
                        else
                        {
                          if(!_newDescCon.text.isNotEmpty)
                            _newDescCon.text ='내용을 입력해주세요';
                          else if(!_newNameCon.text.isNotEmpty)
                            _newNameCon.text ='제목을 입력해주세요';
                        }


                      },
                    ),
                  )
                ],
              ),
            )

          ],
        ),
      ),


    );
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    nickname = prefs.getString('nickname') ?? '';

    // Force refresh input
    setState(() {});
  }

  void createDoc(String name, String description, var selectedValue, String nk) {

    FirebaseFirestore.instance.collection(colName).add({
      fnName: name,
      fnDescription: description,
      fnDatetime: Timestamp.now(),
      fnCatagory : selectedValue,

      'nickName': nk,
      pageView: 0,
      likes: 0,
      'hates': 0,
      replys: 0,
      'uid' : _auth.currentUser.uid
    }).then((value) => FirebaseFirestore.instance.collection('all').add({
      'colName': colName,
      fnName: name,
      fnCatagory : selectedValue,

      fnDescription: description,
      fnDatetime: Timestamp.now(),
      'nickName': nk,
      pageView: 0,
      likes: 0,
      'hates': 0,
      replys: 0,
      'uid' : _auth.currentUser.uid,
      'value' : value.toString()
    })
    );

  }
}
