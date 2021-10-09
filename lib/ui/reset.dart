import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _ResetScreenState extends State<ResetScreen> {
  String _email;
  OutlineInputBorder _border = OutlineInputBorder();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("비밀번호찾기"),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 18.0, right: 18.0, bottom: 10),
              child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: kPrimaryColor,
                  style: TextStyle(color: Colors.black),
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "가입한 이메일 주소를 입력하세요",
                    filled: false,
                    fillColor: Colors.black45,
                    border: _border,
                    errorBorder: _border.copyWith(
                        borderSide: BorderSide(color: kPrimaryColor, width: 2)),
                    enabledBorder: _border.copyWith(
                        borderSide: BorderSide(color: Colors.grey, width: 1)),
                    focusedBorder: _border.copyWith(
                        borderSide: BorderSide(color: kPrimaryColor, width: 1)),
                    errorStyle: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    hintStyle: TextStyle(color: Colors.black),
                  ))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              side: const BorderSide(color: Colors.transparent),
            ),
            onPressed: () {
              _auth.sendPasswordResetEmail(email: _emailController.text);
              Navigator.of(context).pop();
            },
            child: const Text(
              '요청 보내기',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
