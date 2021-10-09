import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:overlock/router/ui_pages.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../app_state.dart';
import '../../constants.dart';
import '../details.dart';

class soWonList extends StatefulWidget {
  @override
  _soWonListState createState() => _soWonListState();
}

class _soWonListState extends State<soWonList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // 컬렉션명
  final String colName = "sowon";
  final String fnCatagory = "Catagory";

  // 필드명
  final String fnName = "name";
  final String fnDescription = "description";
  final String fnDatetime = "datetime";
  final String recomand = "Recomand";
  final String userID = "nickName";


  TextEditingController _newNameCon = TextEditingController();
  TextEditingController _newDescCon = TextEditingController();
  TextEditingController _undNameCon = TextEditingController();
  TextEditingController _undDescCon = TextEditingController();

  bool isScrollingDown = false;
  double bottomBarHeight = 130; // set bottom bar height

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    final size = query.size;
    final itemWidth = size.width;
    final itemHeight = itemWidth * (size.width / size.height);
    final appState = Provider.of<AppState>(context, listen: false);
    FirebaseAuth _auth = FirebaseAuth.instance;

    return Scaffold(
        backgroundColor: Colors.grey[50],
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
                  if (snapshot.hasError)
                    return Text("Error: ${snapshot.error}");
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.transparent),
                      );
                    default:
                      return ListView(
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          Timestamp ts = document[fnDatetime];
                          String dt = timestampToStrDateTime(ts);
                          String ShortDt = dt.substring(0, 10);
                          return Card(
                            elevation: 0.1,
                            child: InkWell(
                              // Read Document
                              onTap: () {
                                appState.currentAction = PageAction(
                                    state: PageState.addPage,
                                    widget: Details(
                                      document[fnName],
                                      document[userID],
                                      document[fnDescription],
                                      document.id,
                                      colName,
                                      document["pageView"].toString(),
                                      document["likes"].toString(),
                                      document["replys"].toString(),
                                      document["hates"].toString(),
                                      document["uid"].toString(),
                                    ),
                                    page: DetailsPageConfig);
                                int view = document["pageView"];
                                view++;
                                FirebaseFirestore.instance
                                    .collection(colName)
                                    .doc(document.id)
                                    .update({"pageView": view});
                              },
                              // Update or Delete Document
                              onLongPress: () {
                                showUpdateOrDeleteDocDialog(document);
                              },
                              child: Container(
                                //height: size.height * 0.3,
                                // padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("["+document[fnCatagory]+"]",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 15,
                                          )),
                                    ),
                                    Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 18, bottom: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Flexible(
                                              child: Text(
                                                document[fnName].toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 18, bottom: 8),
                                          child: Container(
                                            alignment: Alignment.bottomLeft,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(

                                                      dt
                                                          .substring(2, 16)
                                                          .toString(),
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Text(
                                                    "동의 "+document["likes"]
                                                            .toString() +
                                                        " 명",
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 15,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Row(
                                        //   children: <Widget>[
                                        //     FlatButton.icon(
                                        //         onPressed: () {},
                                        //         icon: Icon(
                                        //           Icons.view_agenda,
                                        //           size: 15,
                                        //           color: Colors.grey,
                                        //         ),
                                        //         label: Text("1000")),
                                        //     FlatButton.icon(
                                        //         onPressed: () {},
                                        //         icon: Icon(
                                        //             Icons.favorite_border,
                                        //             size: 15,
                                        //             color: Colors.grey),
                                        //         label: Text("500")),
                                        //     FlatButton.icon(
                                        //         onPressed: () {},
                                        //         icon: Icon(Icons.add_comment,
                                        //             size: 15,
                                        //             color: Colors.grey),
                                        //         label: Text("20")),
                                        //   ],
                                        // )
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          //onPressed: showCreateDocDialog,
          onPressed: () => appState.currentAction =
              PageAction(state: PageState.addPage, page: WriteSoWonPageConfig),
          backgroundColor: kPrimaryColor,
        ));
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
  void showDocument(String documentID) {
    FirebaseFirestore.instance
        .collection(colName)
        .doc(documentID)
        .get()
        .then((doc) {});
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

  void showCreateDocDialog() {
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

  void showUpdateOrDeleteDocDialog(DocumentSnapshot doc) {
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
