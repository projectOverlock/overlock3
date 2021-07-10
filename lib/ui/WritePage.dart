import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlock/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 컬렉션명
String colName = "계급";

// 필드명
final String fnName = "name";
final String pageView = "pageView";
final String likes = "likes";
final String replys = "replys";
final String fnDescription = "description";
final String fnDatetime = "datetime";
final String userID = "userID";
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
String id = '';
String nickname = 'default';
SharedPreferences prefs;
final _valueList = ['꿀팁', '취미', '계급', '유머', '제작'];

class WritePage extends StatefulWidget {
  WritePage(this.colboardName);

  String colboardName;

  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  TextEditingController _newNameCon = TextEditingController();
  TextEditingController _newDescCon = TextEditingController();

  Widget build(BuildContext context) {
    var _selectedValue = widget.colboardName;

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
        title: DropdownButton(
          isExpanded: true,
          value: _selectedValue,
          items: _valueList.map((value) {
            return DropdownMenuItem(
                value: value,
                child: Container(
                  alignment: Alignment.center,
                  color: kPrimaryColor,
                  child: Text(
                    value,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        letterSpacing: 0.2,
                        height: 1.2),
                  ),
                ));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
              widget.colboardName = value;
            });
          },
        ),
        // const Text(
        //   '새글 작성',
        //   style: TextStyle(
        //       fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        // ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_library_add),
            onPressed: () {
              if (_newDescCon.text.isNotEmpty && _newNameCon.text.isNotEmpty) {
                createDoc(_newNameCon.text, _newDescCon.text, nickname);
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
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(labelText: "제목을 작성하세요"),
                    controller: _newNameCon,
                  ),
                  TextField(
                    maxLines: 10,
                    decoration: InputDecoration(
                      labelText: "내용을 작성하세요",
                      hintStyle: TextStyle(
                          fontSize: 18, letterSpacing: 0.2, height: 1.2),
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
                        createDoc(_newNameCon.text, _newDescCon.text, nickname);
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

  void createDoc(String name, String description, String nk) {
    FirebaseFirestore.instance.collection(widget.colboardName).add({
      fnName: name,
      fnDescription: description,
      fnDatetime: Timestamp.now(),
      userID: nk,
      pageView: 0,
      likes: 0,
      replys: 0
    });
  }
}
