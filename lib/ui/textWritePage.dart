import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_state.dart';
import '../router/ui_pages.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

// 컬렉션명
final String colName = "FirstDemo";

// 필드명
final String fnName = "name";
final String fnDescription = "description";
final String fnDatetime = "datetime";
final String userID = "userID";
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
String id = '';
String nickname = '';
SharedPreferences prefs;
final _valueList = ['계급별게시판', '유머게시판', '팁게시판', '소원수리'];
var _selectedValue = '계급별게시판';
@override
TextEditingController _newNameCon = TextEditingController();
TextEditingController _newDescCon = TextEditingController();

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    final items = appState.cartItems;

    readLocal();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red[900],
        title: const Text(
          '새글 작성',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_library_add),
            onPressed: () {
              if (_newDescCon.text.isNotEmpty && _newNameCon.text.isNotEmpty) {
                createDoc(_newNameCon.text, _newDescCon.text);
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
                      value: _selectedValue,
                      items: _valueList.map((value) {
                        return DropdownMenuItem(
                            value: value, child: Text(value));
                      }).toList(), onChanged: (value){
                        setState(() {
                          _selectedValue = value;
                        });
                  },),
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(labelText: "제목을 작성하세요1"),
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
                        createDoc(_newNameCon.text, _newDescCon.text);
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

  void createDoc(String name, String description) {
    FirebaseFirestore.instance.collection(colName).add({
      fnName: name,
      fnDescription: description,
      fnDatetime: Timestamp.now(),
      //userID: firebaseAuth.currentUser.uid.toString()
      userID: nickname
    });
  }
}
