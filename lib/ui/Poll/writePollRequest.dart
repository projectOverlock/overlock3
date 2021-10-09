import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';


String colName = "투표요청";

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
final _valueList = ['폭언', '폭행', '성추행성폭행', '소원수리'];
final int _Recomand =0;


class writePollRequest extends StatefulWidget {

  @override
  _writePollRequestState createState() => _writePollRequestState();
}

class _writePollRequestState extends State<writePollRequest> {
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
          '새로운 투표 만들기',
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
      body: Container(
        height: 500,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Column(
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
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(labelText: "제목을 작성하세요"),
                    controller: _newNameCon,
                  ),
                  TextField(
                    maxLines: 10,
                    decoration: InputDecoration(
                      labelText: "내용을 작성하세요",
                    ),
                    controller: _newDescCon,
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      _newNameCon.clear();
                      _newDescCon.clear();
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text("Create"),
                    onPressed: () {
                      if (_newDescCon.text.isNotEmpty &&
                          _newNameCon.text.isNotEmpty) {
                        createDoc(_newNameCon.text, _newDescCon.text, _selectedValue, nickname );
                      }
                      _newNameCon.clear();
                      _newDescCon.clear();
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            ],
          ),
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
      userID: nk,
      pageView : 0,
      likes : 0,
      replys : 0
    });


  }
}

