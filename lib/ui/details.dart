import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlock/constants.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../constants.dart';
import '../router/ui_pages.dart';

class Details extends StatelessWidget {
  final String title;
  final String id;
  final String description;
  final String docId;
  final String colName;
  final String pageView;
  final String likes;
  final String replys;

  Details(this.title, this.id, this.description, this.docId, this.colName,
      this.pageView, this.likes, this.replys);

  final TextEditingController _message = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  double bottomBarHeight = 230; // set bottom bar height

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    final size = query.size;
    final appState = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(title,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.white, fontSize: 20)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: size.height * 0.3,
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.black,
                      fontSize: 18,
                      letterSpacing: 0.2,
                      height: 1.5),
                ),
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
                    label: Text(pageView)),
                FlatButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.favorite_border,
                        size: 12, color: Colors.grey),
                    label: Text(likes)),
                FlatButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.add_comment, size: 12, color: Colors.grey),
                    label: Text(replys)),
              ],
            ),
          ),
          Row(
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
                  icon: Icon(Icons.send),
                  onPressed: () {
                    onSendMessage();

                    FirebaseFirestore.instance
                        .collection(colName)
                        .doc(docId)
                        .get()
                        .then((doc) {
                      int view = doc["replys"];
                      view++;
                      FirebaseFirestore.instance
                          .collection(colName)
                          .doc(docId)
                          .update({"replys": view});
                    });
                  })
            ],
          ),
          Expanded(
            // height: size.height*0.36,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(colName)
                  .doc(docId)
                  .collection('chats')
                  .orderBy("time", descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return Text("Error: ${snapshot.error}");
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Scaffold(
                      backgroundColor: Colors.white,
                    );
                  default:
                    return ListView(
                      shrinkWrap: true,
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        Timestamp ts = document["time"];
                        String dt = timestampToStrDateTime(ts);

                        //String ShortDt = dt.substring(0, 10);
                        return Card(
                          color: Colors.grey[50],
                          elevation: 1,
                          child: InkWell(
                            // Read Document
                            onTap: () {},
                            // Update or Delete Document
                            onLongPress: () {
                              //showUpdateOrDeleteDocDialog(document, context);
                            },
                            child: Column(children: <Widget> [
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
                                      width: size.width * 0.7,
                                      child: Text(
                                        document["sendby"].toString(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: document['sendby'] == id
                                              ? kPrimaryColor
                                              : Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                        //iconSize: 24.0,
                                        //padding: EdgeInsets.all(1),
                                        icon: Icon(Icons.more_vert,
                                            size: 14, color: Colors.grey),
                                        onPressed: () {})
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8.0, left: 15, right: 15),
                                child: Expanded(
                                 // height: 40,
                                 // alignment: Alignment.topLeft,
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
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only( bottom: 8.0, left: 15, right: 15),

                                child: Text(
                                  DateTime.fromMicrosecondsSinceEpoch(document["time"].microsecondsSinceEpoch).toString().substring(5,16),
                                 // dt.substring(5, 16).toString(),
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            ]),
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
    appState.currentAction =
        PageAction(state: PageState.addPage, page: DetailsPageConfig);
  }

  void deleteDoc(String docID) {
    FirebaseFirestore.instance.collection(colName).doc(docID).delete();
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser.displayName,
        "message": _message.text,
        //"time": FieldValue.serverTimestamp(),
        "time": DateTime.now(),
        //"time2": DateTime.now().toString(),
      };

      _message.clear();
      await _firestore
          .collection(colName)
          .doc(docId)
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
