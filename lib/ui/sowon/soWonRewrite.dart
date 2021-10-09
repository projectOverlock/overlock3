import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlock/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 컬렉션명
String newcolName = "동기";

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
CollectionReference users = FirebaseFirestore.instance.collection('users');
final FirebaseAuth _auth = FirebaseAuth.instance;

class soWonreWritePage extends StatefulWidget {
  soWonreWritePage(
      this.colboardName, this.redocID, this.retitle, this.redecription);

  String colboardName;
  String redocID;
  String retitle;
  String redecription;

  @override
  _soWonreWritePageState createState() => _soWonreWritePageState();
}

class _soWonreWritePageState extends State<soWonreWritePage> {
  FocusNode myFocusNode;

  void initState() {
    super.initState();
    // myFocusNode에 포커스 인스턴스 저장.
    myFocusNode = FocusNode();
  }

  void dispose() {
    // 폼이 삭제되면 myFocusNode도 삭제됨
    myFocusNode.dispose();
    super.dispose();
  }

  TextEditingController _newNameCon = TextEditingController();
  TextEditingController _newDescCon = TextEditingController();

  Widget build(BuildContext context) {
    _newNameCon.text = widget.retitle;
    _newDescCon.text = widget.redecription;

    var _selectedValue = '폭언';

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(_auth.currentUser.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              backgroundColor: kPrimaryColor,
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            );
          }

          if (snapshot.hasData && !snapshot.data.exists) {
            return Scaffold(
              backgroundColor: kPrimaryColor,
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data.data() as Map<String, dynamic>;
            final _valueList = [
              '폭언',
              '폭행',
              '성추행',
              '성폭행',
              '소원수리',
              '불평등',
              '부조리',
              '비리'
            ];

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
                actions: [
                  IconButton(
                    icon: const Icon(Icons.my_library_add),
                    onPressed: () {
                      if (_newDescCon.text.isNotEmpty &&
                          _newNameCon.text.isNotEmpty) {
                        updateDoc(
                          widget.redocID,
                          _newNameCon.text,
                          _newDescCon.text,
                        );
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
                                  fontSize: 18,
                                  letterSpacing: 0.2,
                                  height: 1.5,
                                  fontWeight: FontWeight.w300),
                            ),
                            controller: _newDescCon,
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          TextButton(
                            child: Text(
                              "삭제",
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection(widget.colboardName)
                                  .doc(widget.redocID)
                                  .delete();

                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text("취소",
                                style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              _newNameCon.clear();
                              _newDescCon.clear();
                              Navigator.pop(context);
                            },
                          ),
                          Spacer(),
                          TextButton(
                            child: Text("문서 수정"),
                            onPressed: () {
                              if (_newDescCon.text.isNotEmpty &&
                                  _newNameCon.text.isNotEmpty) {
                                updateDoc(
                                  widget.redocID,
                                  _newNameCon.text,
                                  _newDescCon.text,
                                );
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

          return Scaffold(
            backgroundColor: kPrimaryColor,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          );
        });
  }

  void updateDoc(String docID, String name, String description) {
    FirebaseFirestore.instance
        .collection(widget.colboardName)
        .doc(docID)
        .update({
      fnName: name,
      fnDescription: description,
    });
  }
}
