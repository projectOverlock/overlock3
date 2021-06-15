import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_state.dart';

String colName = "소원수리";

// 필드명
final String fnName = "name";
final String fnDescription = "description";
final String fnDatetime = "datetime";
final String recomand = "Recomand";
final String fnCatagory = "Catagory";

 String _selectedValue = '폭언';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
String id = '';
String nickname = 'default';
SharedPreferences prefs;
final _valueList = ['폭언', '폭행', '성추행성폭행', '소원수리'];
final int _Recomand =0;
class writeSoWon extends StatefulWidget {
  @override
  _writeSoWonState createState() => _writeSoWonState();
}

class _writeSoWonState extends State<writeSoWon> {
  @override
  TextEditingController _newNameCon = TextEditingController();
  TextEditingController _newDescCon = TextEditingController();

  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    final items = appState.cartItems;
    readLocal();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red[900],
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
                createDoc(_newNameCon.text, _newDescCon.text, _selectedValue);
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
                        createDoc(_newNameCon.text, _newDescCon.text, _selectedValue);
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

  void createDoc(String name, String description, var selectedValue) {
    FirebaseFirestore.instance.collection(colName).add({
      fnName: name,
      fnDescription: description,
      fnDatetime: Timestamp.now(),
      fnCatagory : selectedValue,
      //userID: firebaseAuth.currentUser.uid.toString()
      recomand: _Recomand
    });


  }
}
