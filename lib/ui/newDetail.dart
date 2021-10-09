import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:overlock/router/ui_pages.dart';

import '../app_state.dart';
import '../constants.dart';

class newDetails extends StatefulWidget {
  final String docID;
  final String colName;

  newDetails(this.docID, this.colName);

  @override
  _newDetailsState createState() => _newDetailsState();
}

class _newDetailsState extends State<newDetails> {
  var datetime;

  var description;

  var likes;

  var name;

  var pageView;

  var replys;

  var userID;

  final TextEditingController _message = TextEditingController();

  TextEditingController _undNameCon = TextEditingController();

  TextEditingController _undDescCon = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    final size = query.size;
    double bottomBarHeight =  140;



    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection(widget.colName)
            .doc(widget.docID)
            .get()
            .then((value) {
          datetime = value["datetime"];
          description = value["description"];
          likes = value["likes"];
          name = value["name"];
          pageView = value["pageView"];
          replys = value["replys"];
          userID = value["userID"];
        }),
        builder: (BuildContext context,
            AsyncSnapshot < QuerySnapshot > snapshot)
        {
          if (snapshot.hasError) return Text("Error: ${snapshot.error}");
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: kPrimaryColor,
                  title: Text(name,
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline4
                          .copyWith(color: Colors.white, fontSize: 20)),
                ),
                body: Container(
                  height: size.height - bottomBarHeight,

                  child: ListView(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          // height: size.height * 0.3,
                          child: Text(
                            description,
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                color: Colors.black,
                                fontSize: 18,
                                letterSpacing: 0.2,
                                height: 1.5),
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            FlatButton.icon(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.view_agenda,
                                  size: 12,
                                  color: Colors.grey,
                                ),
                                label: Text(pageView.toString())),
                            FlatButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.favorite_border,
                                    size: 12, color: Colors.grey),
                                label: Text(likes.toString())),
                            FlatButton.icon(
                                onPressed: () {},
                                icon:
                                Icon(Icons.add_comment, size: 12,
                                    color: Colors.grey),
                                label: Text(replys.toString())),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: size.height / 17,
                                width: size.width / 1.3,
                                child: TextFormField(
                                  controller: _message,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      hintText: "댓글을 남기세요",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                ),
                              ),
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: kPrimaryColor,
                                ),
                                onPressed: () {
                                  onSendMessage();
                                  FirebaseFirestore.instance
                                      .collection(widget.colName)
                                      .doc(widget.docID)
                                      .get()
                                      .then((doc) {
                                    int view = doc["replys"];
                                    view++;
                                    FirebaseFirestore.instance
                                        .collection(widget.colName)
                                        .doc(widget.docID)
                                        .update({"replys": view});
                                  });
                                })
                          ],
                        ),
                      ),

                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection(widget.colName)
                            .doc(widget.docID)
                            .collection('chats')
                            .orderBy("time", descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError)
                            return Text("Error: ${snapshot.error}");
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return CircularProgressIndicator();
                            default:
                              return ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children:
                                snapshot.data.docs.map((
                                    DocumentSnapshot document) {
                                  Timestamp ts = document["time"];
                                  String dt = timestampToStrDateTime(ts);

                                  //String ShortDt = dt.substring(0, 10);
                                  return Card(
                                    color: document['replyofreply'] == false
                                        ? Colors.grey[50]
                                        : Colors.grey[300],
                                    elevation: 1,
                                    child: InkWell(
                                      // Read Document
                                      onTap: () {},
                                      // Update or Delete Document
                                      // onLongPress: () {
                                      //   showUpdateOrDeleteDocDialog(document, context);
                                      // },
                                      child: Padding(
                                        padding: document['replyofreply'] ==
                                            false
                                            ? const EdgeInsets.only(
                                          //bottom: 8.0,
                                            left: 1,
                                            right: 1)
                                            : const EdgeInsets.only(
                                          //bottom: 8.0,
                                            left: 20,
                                            right: 20),
                                        child: Column(children: <Widget>[
                                          Padding(
                                            padding: document['replyofreply'] ==
                                                false
                                                ? const EdgeInsets.only(
                                              //bottom: 8.0,
                                                left: 12,
                                                right: 12)
                                                : const EdgeInsets.only(
                                              //bottom: 8.0,
                                                left: 12,
                                                right: 12),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: size.width * 0.7,
                                                  child: Text(
                                                    document["sendby"]
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: document['sendby'] ==
                                                          _auth.currentUser
                                                              .displayName
                                                          ? kPrimaryColor
                                                          : Colors.black,
                                                    ),
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                  ),
                                                ),
                                                IconButton(
                                                  //iconSize: 24.0,
                                                  //padding: EdgeInsets.all(1),
                                                  icon: Icon(Icons.more_vert,
                                                      size: 14,
                                                      color: document['sendby'] ==
                                                          _auth.currentUser
                                                              .displayName
                                                          ? Colors.grey
                                                          : Colors.grey[50]),
                                                  onPressed: document['sendby'] ==
                                                      _auth.currentUser
                                                          .displayName
                                                      ? () {
                                                    showUpdateOrDeleteDocDialog(
                                                        document, context);
                                                  }
                                                      : () {},
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0,
                                                left: 15,
                                                right: 15),
                                            child: Container(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                document["message"],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    letterSpacing: 0.2,
                                                    height: 1.2),
                                                //overflow: TextOverflow.ellipsis,
                                                //maxLines: 2,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                padding: EdgeInsets.only(
                                                    left: 15, right: 15),
                                                child: Text(
                                                  DateTime
                                                      .fromMicrosecondsSinceEpoch(
                                                      document["time"]
                                                          .microsecondsSinceEpoch)
                                                      .toString()
                                                      .substring(5, 16),
                                                  // dt.substring(5, 16).toString(),
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              Divider(),
                                              FlatButton.icon(
                                                  onPressed: () {},
                                                  icon: Icon(Icons
                                                      .favorite_border,
                                                      size: 12, color: Colors
                                                          .grey),
                                                  label: Text(
                                                    "추천하기",
                                                    style:
                                                    TextStyle(
                                                        color: Colors.grey),
                                                  )),
                                              FlatButton.icon(
                                                  onPressed: () {
                                                    showReplyOfReplyDialog(
                                                        document, context);
                                                  },
                                                  icon: Icon(Icons.reply_all,
                                                      size: 12, color: Colors
                                                          .grey),
                                                  label: Text(
                                                    "대댓글달기",
                                                    style:
                                                    TextStyle(
                                                        color: Colors.grey),
                                                  )),
                                            ],
                                          ),
                                        ]),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                          }
                        },
                      ),

                      //
                    ],
                  ),
                ),

              );
          }
        });
  }

  void showDocument(String documentID, appState) {
    FirebaseFirestore.instance
        .collection(widget.colName)
        .doc(widget.docID)
        .get()
        .then((doc) {
      showReadDocSnackBar(doc, appState);
    });
  }

  void showUpdateOrDeleteDocDialog(DocumentSnapshot doc, context) {
    _undNameCon.text = doc["sendby"];
    _undDescCon.text = doc["message"];
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

  void showReplyOfReplyDialog(DocumentSnapshot doc, context) {
    var replyDate = doc["time"];
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("대댓글"),
          content: Container(
            height: 200,
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: "Description"),
                  controller: _undDescCon,
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("취소"),
              onPressed: () {
                _undDescCon.clear();
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("작성"),
              onPressed: () {
                if (_undDescCon.text.isNotEmpty) {
                  writeReplyOfRely(doc.id, _undDescCon.text, replyDate);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void updateDoc(String docID, String name, String description) {
    _firestore
        .collection(widget.colName)
        .doc(docID)
        .collection('chats')
        .doc(docID)
        .update({
      "sendby": name,
      "message": description,
      "time": DateTime.now(),
    });
  }

  void writeReplyOfRely(String docID, String description, Timestamp replyDate) {
    Timestamp ts = replyDate;
    ts.toDate();

    _firestore
        .collection(widget.colName)
        .doc(docID)
        .collection('chats')
        .add({
      "sendby": _auth.currentUser.displayName,
      "message": description,
      "time": replyDate,
      "replyofreply": true
    });
    _undDescCon.clear();
  }

  void showReadDocSnackBar(DocumentSnapshot doc, appState) {
    appState.currentAction =
        PageAction(state: PageState.addPage, page: DetailsPageConfig);
  }

  void deleteDoc(String docID) {
    FirebaseFirestore.instance
        .collection(widget.colName)
        .doc(docID)
        .collection('chats')
        .doc(docID)
        .delete();
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser.displayName,
        "message": _message.text,
        "time": DateTime.now(),
        "replyofreply": false
      };

      _message.clear();
      await _firestore
          .collection(widget.colName)
          .doc(widget.docID)
          .collection('chats')
          .add(messages);
    } else {
      print("Enter Some Text");
    }
  }

  String timestampToStrDateTime(Timestamp ts) {
    return DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch)
        .toString();
  }
}
