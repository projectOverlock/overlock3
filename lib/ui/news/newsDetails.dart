import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kakao_flutter_sdk/link.dart';
import 'package:overlock/constants.dart';
import 'package:overlock/router/ui_pages.dart';
import 'package:overlock/ui/reWritePage.dart';
import 'package:overlock/ui/sowon/soWonRewrite.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';


class newsDetails extends StatefulWidget {
  final String title;
  final String id;
  final String description;
  final String docId;
  final String colName;
  final String pageView;
  String likes;
  String hates;
  String replys;
  final String uidd;
  final String imageurl;


  newsDetails(
      this.title,
      this.id,
      this.description,
      this.docId,
      this.colName,
      this.pageView,
      this.likes,
      this.hates,
      this.replys,
      this.uidd,
      this.imageurl,

      );

  @override
  _newsDetailsState createState() => _newsDetailsState();
}

class _newsDetailsState extends State<newsDetails> {
  FocusNode myFocusNode;
  final ScrollController _scrollController = ScrollController();

  //final String androidTestUnitId = 'ca-app-pub-3940256099942544/6300978111';//테스트아이디
  final String androidTestUnitId = 'ca-app-pub-2229504227701789/1378091589';

  BannerAd banner;

  final TextEditingController _message = TextEditingController();
  TextEditingController _undNameCon = TextEditingController();
  TextEditingController _undDescCon = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final scrlController = ScrollController();
  double bottomBarHeight = 140;
  final double allFontSize = 12;

  void initState() {
    super.initState();

    ///배너 광고 삽입을 위한 초기화 수행
    banner = BannerAd(
        listener: BannerAdListener(),
        size: AdSize.fullBanner,
        adUnitId: androidTestUnitId,
        request: AdRequest())
      ..load();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    KakaoContext.clientId = 'd39f9b18ce4b5918be97413cf6f09c17';
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    return FutureBuilder<double>(
        future: whenNotZero(Stream<double>.periodic(Duration(milliseconds: 100),
                (x) => MediaQuery.of(context).size.width)),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Size size = MediaQuery.of(context).size;

            return Scaffold(
              appBar: AppBar(
                elevation: 1,
                iconTheme: IconThemeData(color: kPrimaryColor),
                foregroundColor: Colors.white,
                backgroundColor: Colors.white,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "오바로크",
                      style: TextStyle(color: Colors.grey, fontSize: allFontSize*1.5),
                    ),
                    SizedBox(
                        height: 40.0,
                        width: 40.0,
                        child: widget.uidd == _auth.currentUser.uid
                            ? new IconButton(
                            padding: new EdgeInsets.all(0.0),
                            color: kPrimaryColor,
                            icon: new Icon(Icons.more_vert, size: 24.0),
                            onPressed: () {
                              // Navigator.pop(context);
                              if (widget.colName == 'sowon') {
                                appState.currentAction = PageAction(
                                    state: PageState.addWidget,
                                    widget: soWonreWritePage(
                                        widget.colName,
                                        widget.docId,
                                        widget.title,
                                        widget.description),
                                    page: soWonreWritePageConfig);
                              } else {
                                appState.currentAction = PageAction(
                                    state: PageState.addWidget,
                                    widget: reWritePage(
                                        widget.colName,
                                        widget.docId,
                                        widget.title,
                                        widget.description),
                                    page: reWritePageConfig);
                              }
                            })
                            : Container()),
                  ],
                ),
              ),
              body: Stack(children: [
                Container(
                  height: size.height - bottomBarHeight,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.title,
                              style:
                              TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                        ),

                        widget.uidd == _auth.currentUser.uid
                            ? Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15),
                          child: Container(
                            alignment:
                            Alignment.bottomLeft,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                Text(widget.id+"(내가쓴글)",
                                    style: TextStyle(
                                        color:
                                        kPrimaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                    )),
                              ],
                            ),
                          ),
                        )
                            : Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15),
                          child: Container(
                            alignment:
                            Alignment.bottomLeft,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                Text("타인의 글",
                                    style: TextStyle(
                                        color:
                                        Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: widget.imageurl ==
                                "noImage"
                                ? Container(
                              color: Colors.amber,
                            )
                                : SizedBox(
                              width: size.width,
                              height: size.width,
                              child: Image.network(
                                  widget.imageurl, fit: BoxFit.fill),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                          child: Divider(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            onLongPress: () {
                              showMenu(
                                position: RelativeRect.fromLTRB(0, 100, 0, 0)
                                ,
                                items: <PopupMenuEntry>[
                                  PopupMenuItem(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.copy),
                                        TextButton(
                                            onPressed: () {
                                              Clipboard.setData(new ClipboardData(
                                                  text: widget.description));
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "본문복사",
                                              style:
                                              TextStyle(color: Colors.black),
                                            )),
                                      ],
                                    ),
                                  )
                                ],
                                context: context,
                              );
                            },
                            child: Container(
                              constraints: BoxConstraints(
                                  minHeight: 250,
                                  minWidth: double.infinity,
                                  maxHeight: double.infinity),
                              child: Text(
                                  widget.description,
                                  style:
                                  TextStyle(fontFamily: 'NanumFontSetup_OTF_BARUNGOTHIC',
                                      color: Colors.black,
                                      fontSize: 18,//네이버 기준
                                      letterSpacing: 0.2,
                                      height: 1.5,
                                      fontWeight: FontWeight.w300
                                  )
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Row(
                              children: <Widget>[
                                TextButton.icon(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.view_agenda,
                                      size: allFontSize,
                                      color: Colors.grey,
                                    ),
                                    label: Text(
                                      "조회수: " + widget.pageView,
                                      style: TextStyle(
                                          fontSize: allFontSize, color: Colors.grey),
                                    )),
                                TextButton.icon(
                                    onPressed: () {
                                      likeIt();
                                    },
                                    icon: Icon(Icons.favorite_border,
                                        size: allFontSize, color: Colors.grey),
                                    label: Text("좋아요: " + widget.likes,
                                        style: TextStyle(
                                            fontSize: allFontSize, color: Colors.grey))),
                                TextButton.icon(
                                    onPressed: () {
                                      //unlikeIt();
                                      hateIt();
                                    },
                                    icon: Icon(Icons.do_disturb_off_rounded,
                                        size: allFontSize, color: Colors.grey),
                                    label: Text("싫어요: " + widget.hates,
                                        style: TextStyle(
                                            fontSize: allFontSize, color: Colors.grey))),
                                TextButton.icon(
                                    onPressed: () {},
                                    icon: Icon(Icons.add_comment,
                                        size: allFontSize, color: Colors.grey),
                                    label: Text("댓글수: " + widget.replys,
                                        style: TextStyle(
                                            fontSize: allFontSize, color: Colors.grey))),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "오바로크의 모든 게시글은 이용자 개인 의견이며, 군의 공식의견이나 군사정보가 아닙니다.",
                            style: TextStyle(color: kPrimaryColor, fontSize: 10),
                          ),
                        ),

                        ///광고 삽입구
                        Container(
                          height: 50.0,
                          child: this.banner == null
                              ? Container()
                              : AdWidget(
                            ad: this.banner,
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection(widget.colName)
                              .doc(widget.docId)
                              .collection('chats')
                              .orderBy("time2", descending: false)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError)
                              return Text("Error: ${snapshot.error}");
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.transparent),
                                );
                              default:
                                return ListView(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: snapshot.data.docs
                                      .map((DocumentSnapshot document) {
                                    Timestamp ts = document["time"];
                                    String dt = timestampToStrDateTime(ts);

                                    return Card(
                                      //카드형태로 댓글 남김 댓글과 대댓글의 배경 다르게 표시
                                      color: document['replyofreply'] == false
                                          ? Colors.grey[50]
                                          : Colors.grey[100],
                                      elevation: 0.1,
                                      child: InkWell(
                                        // Read Document
                                        onTap: () {},
                                        child: Padding(
                                          padding:
                                          document['replyofreply'] == false
                                              ? const EdgeInsets.only(
                                              left: 1, right: 1)
                                              : const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Column(children: <Widget>[
                                            Padding(
                                              //글쓴이 아이디
                                              padding: document['replyofreply'] ==
                                                  false
                                                  ? const EdgeInsets.only(
                                                  left: 12, right: 12)
                                                  : const EdgeInsets.only(
                                                  left: 12, right: 12),
                                              child: Row(
                                                children: <Widget>[
                                                  SizedBox(
                                                      width: size.width * 0.6,
                                                      child: document['uid'] ==
                                                          widget.uidd
                                                          ? Text(
                                                        // 작성자와 댓글글쓴이 같으면 색상을 붉은 색아이디로 표시
                                                        document["sendby"]
                                                            .toString() +
                                                            "(글쓴이)",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                            kPrimaryColor),
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                      )
                                                          :

                                                      Text(
                                                        // 작성자와 댓글글쓴이 다르면 색상을 붉은 색아이디로 표시
                                                        "타인의 댓글",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors
                                                                .black),
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                      )
                                                  ),
                                                  Spacer(),
                                                  SizedBox(
                                                      height: 18.0,
                                                      width: 18.0,
                                                      child: new IconButton(
                                                        padding:
                                                        new EdgeInsets.all(
                                                            0.0),
                                                        color: Colors.grey,
                                                        icon: new Icon(
                                                            Icons.more_vert,
                                                            size: allFontSize,
                                                            color: document[
                                                            'uid'] ==
                                                                _auth
                                                                    .currentUser
                                                                    .uid
                                                                ? Colors.grey
                                                                : Colors
                                                                .grey[50]),
                                                        onPressed: document[
                                                        'uid'] ==
                                                            _auth.currentUser
                                                                .uid
                                                            ? () {
                                                          showUpdateOrDeleteDocDialog(
                                                              document,
                                                              context);
                                                        }
                                                            : () {},
                                                      ))
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 6,
                                                  bottom: 6.0,
                                                  left: 15,
                                                  right: 15),
                                              child: Container(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  document["message"],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      letterSpacing: 0.2,
                                                      height: 1.2),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                TextButton.icon(
                                                    onPressed: () {
                                                      replylikeIt(document.id);
                                                    },
                                                    icon: Icon(
                                                        Icons.favorite_border,
                                                        size: allFontSize,
                                                        color: Colors.grey),
                                                    label: Text(
                                                      "좋아요: " +
                                                          document['likes']
                                                              .toString(),
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: allFontSize),
                                                    )),
                                                document['replyofreply'] == true
                                                    ? Container()
                                                    : TextButton.icon(
                                                    onPressed: () {
                                                      showReplyOfReplyDialog(
                                                          document, context);
                                                    },
                                                    icon: Icon(
                                                        Icons.reply_all,
                                                        size: allFontSize,
                                                        color: Colors.grey),
                                                    label: Text(
                                                      "대댓글달기",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: allFontSize),
                                                    )),
                                                Spacer(),
                                                Container(
                                                  padding:
                                                  EdgeInsets.only(right: 8),
                                                  child: Text(
                                                    DateTime.fromMicrosecondsSinceEpoch(
                                                        document["time"]
                                                            .microsecondsSinceEpoch)
                                                        .toString()
                                                        .substring(5, 16),
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: allFontSize),
                                                  ),
                                                ),
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
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: size.width / 1.2,
                            child: TextField(
                              controller: _message,
                              maxLines: 1,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8.0),
                                  //here your padding

                                  hintText: "댓글을 남기세요",
                                  hintStyle: TextStyle(fontSize: 14),
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
                            })
                      ],
                    ),
                  ),
                )
              ]),
            );
          } else {
            return CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.transparent),
            );
          }
        });
    // Create Document
  }

  /// Firestore CRUD Logic

  Future<double> whenNotZero(Stream<double> source) async {
    await for (double value in source) {
      if (value > 0) {
        return value;
      }
    }
  }

// 문서 조회 (Read)
  void showDocument(String documentID, appState) {
    FirebaseFirestore.instance
        .collection(widget.colName)
        .doc(documentID)
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
            height: 300,
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
              child: Text("취소"),
              onPressed: () {
                _undNameCon.clear();
                _undDescCon.clear();
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("삭제"),
              onPressed: () {
                deleteDoc(doc.id);
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("업데이트"),
              onPressed: () {
                if (_undNameCon.text.isNotEmpty &&
                    _undDescCon.text.isNotEmpty) {
                  updateDoc(doc.id, _undNameCon.text, _undDescCon.text);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void showReplyOfReplyDialog(DocumentSnapshot doc, context) {
    Timestamp replyDate = doc["time2"];
    int replyCount = doc["replyCount"];
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
                  autofocus: true,
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
                  writeReplyOfRely(
                      doc.id, _undDescCon.text, replyDate, replyCount);
                  _firestore
                      .collection(widget.colName)
                      .doc(widget.docId)
                      .collection('chats')
                      .doc(doc.id)
                      .update({
                    "replyCount": replyCount + 1,
                  });
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
        .doc(widget.docId)
        .collection('chats')
        .doc(docID)
        .update({
      "sendby": name,
      "message": description,
      "time": DateTime.now(),
    });
  }

  void writeReplyOfRely(
      String docID, String description, Timestamp replyDate, int replyCount) {
    DateTime ts =
    DateTime.fromMicrosecondsSinceEpoch(replyDate.microsecondsSinceEpoch);
    _firestore
        .collection(widget.colName)
        .doc(widget.docId)
        .collection('chats')
        .add({
      "sendby": _auth.currentUser.displayName,
      "message": description,
      "time": DateTime.now(),
      "time2": ts.add(Duration(milliseconds: 100 + replyCount * 100)),
      "replyofreply": true,
      "replyCount": 0,
      "uid": _auth.currentUser.uid,
      "likes": 0
    });
    _firestore
        .collection(widget.colName)
        .doc(widget.docId)
        .collection('chats')
        .get()
        .then((querySnapshot) {
      _firestore
          .collection(widget.colName)
          .doc(widget.docId)
          .update({"replys": querySnapshot.size});
      widget.replys = querySnapshot.size.toString();
      setState(() {});
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
        .doc(widget.docId)
        .collection('chats')
        .doc(docID)
        .delete();

    _firestore
        .collection(widget.colName)
        .doc(widget.docId)
        .collection('chats')
        .get()
        .then((querySnapshot) {
      _firestore
          .collection(widget.colName)
          .doc(widget.docId)
          .update({"replys": querySnapshot.size});
      widget.replys = querySnapshot.size.toString();
      setState(() {});
    });
  }

  ///댓글 쓰기
  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser.displayName,
        "message": _message.text,
        "time": DateTime.now(),
        "time2": DateTime.now(),
        "replyofreply": false,
        "replyCount": 0,
        "uid": _auth.currentUser.uid,
        "likes": 0
      };
      await _firestore
          .collection(widget.colName)
          .doc(widget.docId)
          .collection('chats')
          .add(messages);
    } else {
      _message.text = "글을 작성해주세요.";
    }
    await _firestore
        .collection(widget.colName)
        .doc(widget.docId)
        .collection('chats')
        .get()
        .then((querySnapshot) {
      _firestore
          .collection(widget.colName)
          .doc(widget.docId)
          .update({"replys": querySnapshot.size});
      widget.replys = querySnapshot.size.toString();
      setState(() {});
    });
    _message.clear();
    FocusScope.of(context).requestFocus(FocusNode());
  }

  String timestampToStrDateTime(Timestamp ts) {
    return DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch)
        .toString();
  }

  void likeIt() async {
    Map<String, dynamic> messages = {"uid": _auth.currentUser.uid};

    ///게시판쓰는 것처럼 좋아요 관리.
    await _firestore
        .collection(widget.colName)
        .doc(widget.docId)
        .collection('likes')
        .doc(_auth.currentUser.uid)
        .set(messages);

    ///좋아요 갯수 업데이트
    await _firestore
        .collection(widget.colName)
        .doc(widget.docId)
        .collection('likes')
        .get()
        .then((querySnapshot) {
      _firestore
          .collection(widget.colName)
          .doc(widget.docId)
          .update({"likes": querySnapshot.size});

      ///좋아요 갯수 표시
      widget.likes = querySnapshot.size.toString();
      setState(() {});
    });
  }

  void unlikeIt() async {
    FirebaseFirestore.instance
        .collection(widget.colName)
        .doc(widget.docId)
        .collection('likes')
        .doc(_auth.currentUser.uid)
        .delete();

    await _firestore
        .collection(widget.colName)
        .doc(widget.docId)
        .collection('likes')
        .get()
        .then((querySnapshot) {
      _firestore
          .collection(widget.colName)
          .doc(widget.docId)
          .update({"likes": querySnapshot.size});
      widget.likes = querySnapshot.size.toString();
      setState(() {});
    });
  }

  void hateIt() async {
    Map<String, dynamic> messages = {"uid": _auth.currentUser.uid};

    ///게시판쓰는 것처럼 좋아요 관리.
    await _firestore
        .collection(widget.colName)
        .doc(widget.docId)
        .collection('hates')
        .doc(_auth.currentUser.uid)
        .set(messages);

    ///좋아요 갯수 업데이트
    await _firestore
        .collection(widget.colName)
        .doc(widget.docId)
        .collection('hates')
        .get()
        .then((querySnapshot) {
      _firestore
          .collection(widget.colName)
          .doc(widget.docId)
          .update({"hates": querySnapshot.size});

      ///좋아요 갯수 표시
      widget.hates = querySnapshot.size.toString();
      setState(() {});
    });
  }

  void replylikeIt(replydocID) async {
    Map<String, dynamic> messages = {"uid": _auth.currentUser.uid};

    ///게시판쓰는 것처럼 좋아요 관리.
    await _firestore
        .collection(widget.colName)
        .doc(widget.docId)
        .collection('chats')
        .doc(replydocID)
        .collection('replylikes')
        .doc(_auth.currentUser.uid)
        .set(messages);

    ///좋아요 갯수 업데이트
    await _firestore
        .collection(widget.colName)
        .doc(widget.docId)
        .collection('chats')
        .doc(replydocID)
        .collection('replylikes')
        .get()
        .then((querySnapshot) {
      _firestore
          .collection(widget.colName)
          .doc(widget.docId)
          .collection('chats')
          .doc(replydocID)
          .update({"likes": querySnapshot.size});

      ///좋아요 갯수 표시

    });
  }
}


