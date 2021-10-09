import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlock/constants.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class levelSelector extends StatefulWidget {
  @override
  _levelSelectorState createState() => _levelSelectorState();
}
final FirebaseAuth _auth = FirebaseAuth.instance;

List<LevelContact> contacts = [
  LevelContact(fullName: "예비역"),
  LevelContact(fullName: "이등병"),
  LevelContact(fullName: "일병"),
  LevelContact(fullName: "상병"),
  LevelContact(fullName: "병장"),
  LevelContact(fullName: "하사"),
  LevelContact(fullName: "중사"),
  LevelContact(fullName: "상사"),
  LevelContact(fullName: "원사"),
  LevelContact(fullName: "준위"),
  LevelContact(fullName: "소위"),
  LevelContact(fullName: "중위"),
  LevelContact(fullName: "대위"),
  LevelContact(fullName: "소령"),
  LevelContact(fullName: "중령"),
  LevelContact(fullName: "대령"),
  LevelContact(fullName: "준장"),
  LevelContact(fullName: "소장"),
  LevelContact(fullName: "중장"),
  LevelContact(fullName: "대장"),
  LevelContact(fullName: "원수"),
];

class _levelSelectorState extends State<levelSelector> {
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
    List1Name list1Name = Provider.of<List1Name>(context);

    return Scaffold(
        appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: Text('계급 선택',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold))),
        body: new Column(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.all(8.0),
              child: new TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: '계급 검색',
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
                        list1Name.setList1Name(contacts[index].fullName);

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
      "level": post.fullName,
    });

    Navigator.pop(context);
  }
}

class LevelContact {
  final String fullName;

  const LevelContact({
    this.fullName,
  });
}
