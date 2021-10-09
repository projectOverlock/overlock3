import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

TextEditingController _nicknameController = TextEditingController();
final FirebaseAuth _auth = FirebaseAuth.instance;

class nickNameChange extends StatefulWidget {
  @override
  _nickNameChangeState createState() => _nickNameChangeState();
}

class _nickNameChangeState extends State<nickNameChange> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: Text('닉네임 변경',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold))),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 10),
              child: TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(labelText: '닉네임'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return '닉네임을 작성해주세요.';
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                side: BorderSide(
                  color: kPrimaryColor,
                ),
              ),
              onPressed: () async {
                if (_nicknameController.text.isNotEmpty) {
                  await _register();
                  //appState.login();
                  setState(() {

                  });
                  Navigator.pop(context);

                  }
              },
              child: const Text(
                '닉네임 업데이트',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ));
  }
}

Future<void> _register() async {
  _auth.currentUser.updateProfile(displayName: _nicknameController.text);

  await FirebaseFirestore.instance
      .collection('users')
      .doc(_auth.currentUser.uid)
      .update({
    "name": _nicknameController.text,
  });
}
