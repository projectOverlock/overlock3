import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlock/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

// 컬렉션명
String colName = "동기";

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
final _valueList = ['이등병', '육군', '동기', '자유', 'test'];
CollectionReference users = FirebaseFirestore.instance.collection('users');
final FirebaseAuth _auth = FirebaseAuth.instance;

class WritePages extends StatefulWidget {
  WritePages(this.colboardName);

  String colboardName;

  @override
  _WritePagesState createState() => _WritePagesState();
}

class _WritePagesState extends State<WritePages> {
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
    List1Name list1Name = Provider.of<List1Name>(context);
    List2Name list2Name = Provider.of<List2Name>(context);
    List3Name list3Name = Provider.of<List3Name>(context);
    List4Name list4Name = Provider.of<List4Name>(context);


    var _selectedValue = widget.colboardName;

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
              '소원수리',
              '${data['level']}',
              '${data['miltype']}',
              '${data['joinMilitary']}',
              '${data['corpType']}'
            ];
            // list1Name.setList1Name(data['level']);
            // list2Name.setList2Name(data['miltype']);
            // list3Name.setList3Name(data['joinMilitary']);
            // list4Name.setList4Name(data['corpType']);
            //return Text("Full Name: ${data['level']} ${data['miltype']} ${data['joinMilitary']} ${data['corpType']}");
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
                      if (_newDescCon.text.isNotEmpty &&
                          _newNameCon.text.isNotEmpty) {
                        createDoc(_newNameCon.text, _newDescCon.text, nickname);
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
                          style:


                          Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(
                              color: Colors.black,
                              fontSize: 18,
                              letterSpacing: 0.2,
                              height: 1.5,
                              fontWeight: FontWeight.w300

                          ),
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
                                    createDoc(_newNameCon.text, _newDescCon.text,
                                        _auth.currentUser.displayName);
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

  void createDoc(String name, String description, String nk) {
    FirebaseFirestore.instance.collection(widget.colboardName).add({
      fnName: name,
      fnDescription: description,
      fnDatetime: Timestamp.now(),
      'nickName': nk,
      pageView: 0,
      likes: 0,
      'hates': 0,
      replys: 0,
      'uid' : _auth.currentUser.uid
    }).then((value) => FirebaseFirestore.instance.collection('all').add({
      'colName': widget.colboardName,
      fnName: name,
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
