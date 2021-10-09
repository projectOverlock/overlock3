import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlock/constants.dart';
import 'package:overlock/ui/userInfo/FirstCorpSelect.dart';
import 'package:provider/provider.dart';
import '../../main.dart';

class FirstMilSelect extends StatefulWidget {
  @override
  _FirstMilSelectState createState() => _FirstMilSelectState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

List<LevelContact> contacts = [
  LevelContact(fullName: "육군"),
  LevelContact(fullName: "해군"),
  LevelContact(fullName: "공군"),
  LevelContact(fullName: "해병대"),
  LevelContact(fullName: "카투사"),
  LevelContact(fullName: "의무경찰"),
  LevelContact(fullName: "ROTC"),
  LevelContact(fullName: "킹익"),
  LevelContact(fullName: "기타"),
];

class _FirstMilSelectState extends State<FirstMilSelect> {
  TextEditingController searchController = new TextEditingController();
  String filter;

  @override
  initState() {
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List2Name list2Name = Provider.of<List2Name>(context);

    return Scaffold(
        appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: Text('병과 선택',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold))),
        body: new Column(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.all(8.0),
              child: new TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: '병과 검색',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
              ),
            ),
            new Expanded(
              child: new ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  // if filter is null or empty returns all data
                  return filter == null || filter == ""
                      ? ListTile(
                          title: Text(
                            '${contacts[index].fullName}',
                          ),
                          // subtitle: Text('${contacts[index].email}'),
                          leading: new CircleAvatar(
                              backgroundColor: kPrimaryColor,
                              child: Text(
                                  '${contacts[index].fullName.substring(0, 1)}',
                                  style: TextStyle(color: Colors.white))),
                          onTap: () {
                            _onTapItem(context, contacts[index]);
                            list2Name.setList2Name(contacts[index].fullName);
                          })
                      : '${contacts[index].fullName}'
                              .toLowerCase()
                              .contains(filter.toLowerCase())
                          ? ListTile(
                              title: Text(
                                '${contacts[index].fullName}',
                                style: TextStyle(color: Colors.black),
                              ),
                              // subtitle: Text('${contacts[index].email}'),
                              leading: new CircleAvatar(
                                  backgroundColor: kPrimaryColor,
                                  child: Text(
                                    '${contacts[index].fullName.substring(0, 1)}',
                                    style: TextStyle(color: Colors.white),
                                  )),
                              onTap: () => _onTapItem(context, contacts[index]),
                            )
                          : new Container();
                },
              ),
            ),
          ],
        ));
  }

  void _onTapItem(BuildContext context, LevelContact post) {
    // Scaffold.of(context).showSnackBar(
    //     new SnackBar(content: new Text("Tap on " + ' - ' + post.fullName)));

    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid)
        .update({
      "miltype": post.fullName,
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FirstCorpSelect(),
      ),
    );  }
}

class LevelContact {
  final String fullName;

  const LevelContact({
    this.fullName,
  });
}
