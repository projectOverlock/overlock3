import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:overlock/constants.dart';
import 'package:overlock/router/ui_pages.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../app_state.dart';
import '../details.dart';



class listHumor extends StatelessWidget {
  final String colName = "유머";

  // 필드명
  final String fnName = "name";
  final String fnDescription = "description";
  final String fnDatetime = "datetime";
  final String userID = "userID";

  TextEditingController _newNameCon = TextEditingController();
  TextEditingController _newDescCon = TextEditingController();
  TextEditingController _undNameCon = TextEditingController();
  TextEditingController _undDescCon = TextEditingController();

  bool _showAppbar = true; //this is to show app bar
  ScrollController _scrollBottomBarController =
  new ScrollController(); // set controller on scrolling
  bool isScrollingDown = false;
  bool _show = true;
  double bottomBarHeight = 50; // set bottom bar height
  double _bottomBarOffset = 0;

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    final size = query.size;
    final appState = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ListView(
        children: <Widget>[
          Container(
            height: size.height - bottomBarHeight,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(colName)
                  .orderBy(fnDatetime, descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return Text("Error: ${snapshot.error}");
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Scaffold(
                      backgroundColor: Colors.grey[200],
                    );
                  default:
                    return ListView(
                      shrinkWrap: true,
                      children:
                      snapshot.data.docs.map((DocumentSnapshot document) {
                        Timestamp ts = document[fnDatetime];
                        String dt = timestampToStrDateTime(ts);
                        String ShortDt = dt.substring(0, 10);
                        String username = document[userID];
                        return Card(
                          elevation: 1,
                          child: InkWell(
                            // Read Document
                            onTap: () {
                              appState.currentAction = PageAction(
                                  state: PageState.addPage,
                                  widget: Details(document.id, colName),
                                  page: DetailsPageConfig);

                              // showDocument(document.id, appState);
                            },
                            // Update or Delete Document
                            onLongPress: () {
                              showUpdateOrDeleteDocDialog(document, context);
                            },
                            child: Container(
                              //height: size.height * 0.3,
                              // padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                children: <Widget>[
                                  Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        //bottom: 8.0,
                                          left: 12,
                                          right: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          SizedBox(
                                            width: size.width*0.7,
                                            child: Text(document[fnName].toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                color: Colors.black,
                                              ), overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          IconButton(
                                              icon: Icon(Icons.more_vert,
                                                  size: 17, color: Colors.grey),
                                              onPressed: () {})
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 8.0,
                                          left: 15,
                                          right: 15),
                                      child: Container(
                                        height: 70,
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          document[fnDescription],
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16, letterSpacing: 0.2, height: 1.2
                                          ),overflow: TextOverflow.ellipsis,
                                          maxLines: 4,
                                        ),
                                      ),
                                    ),
                                  ]),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15),
                                        child: Container(
                                          alignment: Alignment.bottomLeft,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(document[userID],
                                                  style: TextStyle(
                                                    color: Colors.red[900],
                                                    fontSize: 14,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //Divider(),
                                      SizedBox(
                                        height: 30,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top:8.0, bottom: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: <Widget>[
                                              FlatButton.icon(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    Icons.view_agenda,
                                                    size: 12,
                                                    color: Colors.grey,
                                                  ),
                                                  label: Text("900")),
                                              FlatButton.icon(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                      Icons.favorite_border,
                                                      size: 12,
                                                      color: Colors.grey),
                                                  label: Text("500")),
                                              FlatButton.icon(
                                                  onPressed: () {},
                                                  icon: Icon(Icons.add_comment,
                                                      size: 12,
                                                      color: Colors.grey),
                                                  label: Text("20")),
                                              Text(
                                                dt.substring(2, 16).toString(),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                }
              },
            ),
          )
        ],
      ),
    );
    // Create Document
  }

  /// Firestore CRUD Logic

// 문서 생성 (Create)
  void createDoc(String name, String description) {
    FirebaseFirestore.instance.collection(colName).add({
      fnName: name,
      fnDescription: description,
      fnDatetime: Timestamp.now(),
    });
  }

// 문서 조회 (Read)
  void showDocument(String documentID, appState) {
    FirebaseFirestore.instance
        .collection(colName)
        .doc(documentID)
        .get()
        .then((doc) {
      showReadDocSnackBar(doc, appState);
    });

  }
  void showReadDocSnackBar(DocumentSnapshot doc, appState) {

    appState.currentAction = PageAction(
        state: PageState.addWidget,
        widget: Details(doc.id, colName),
        page: DetailsPageConfig);
  }

// 문서 갱신 (Update)
  void updateDoc(String docID, String name, String description) {
    FirebaseFirestore.instance.collection(colName).doc(docID).update({
      fnName: name,
      fnDescription: description,
    });
  }

// 문서 삭제 (Delete)

  void deleteDoc(String docID) {
    FirebaseFirestore.instance.collection(colName).doc(docID).delete();
  }

  void showCreateDocDialog(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Create New Document"),
          content: Container(
            height: 500,
            child: Column(
              children: <Widget>[
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(labelText: "Name"),
                  controller: _newNameCon,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Description"),
                  controller: _newDescCon,
                )
              ],
            ),
          ),
          actions: <Widget>[
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
        );
      },
    );
  }

  void showUpdateOrDeleteDocDialog(DocumentSnapshot doc, context) {
    _undNameCon.text = doc[fnName];
    _undDescCon.text = doc[fnDescription];
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update/Delete Document"),
          content: Container(
            height: 200,
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: "Name"),
                  controller: _undNameCon,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Description"),
                  controller: _undDescCon,
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                _undNameCon.clear();
                _undDescCon.clear();
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Update"),
              onPressed: () {
                if (_undNameCon.text.isNotEmpty &&
                    _undDescCon.text.isNotEmpty) {
                  updateDoc(doc.id, _undNameCon.text, _undDescCon.text);
                }
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Delete"),
              onPressed: () {
                deleteDoc(doc.id);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  String timestampToStrDateTime(Timestamp ts) {
    return DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch)
        .toString();
  }
}
