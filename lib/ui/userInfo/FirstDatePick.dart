import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:overlock/ui/userInfo/FirstLevelSelect.dart';
import '../../constants.dart';

class FirstDatePick extends StatefulWidget {

  @override
  _FirstDatePickState createState() => _FirstDatePickState();
}

class _FirstDatePickState extends State<FirstDatePick> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _date = "Not set";
  String _date2 = "Not set";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('입대날짜 설정'),
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true,
                      minTime: DateTime(2000, 1, 1),
                      maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                        print('confirm $date');
                        _date = '${date.year} - ${date.month} - ${date.day}';
                        _date2 = '동기${date.year}년${date.month}월';

                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(_auth.currentUser.uid)
                            .update({
                          "joinMilitary": _date2,
                        });
                        setState(() {});
                      }, currentTime: DateTime.now(), locale: LocaleType.ko);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 18.0,
                                  color: Colors.teal,
                                ),
                                Text(
                                  " $_date",
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "  Change",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              SizedBox(
                height: 20.0,
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
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(_auth.currentUser.uid)
                      .update({
                    "joinMilitary": _date2,
                  });

                  //Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FirstLevelSelect(),
                    ),
                  );


                },
                child: const Text(
                  '입대년월 업데이트',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              // RaisedButton(
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(5.0)),
              //   elevation: 4.0,
              //   onPressed: () {
              //     DatePicker.showTimePicker(context,
              //         theme: DatePickerTheme(
              //           containerHeight: 210.0,
              //         ),
              //         showTitleActions: true, onConfirm: (time) {
              //           print('confirm $time');
              //           _time = '${time.hour} : ${time.minute} : ${time.second}';
              //           setState(() {});
              //         }, currentTime: DateTime.now(), locale: LocaleType.ko);
              //     setState(() {});
              //   },
              //   child: Container(
              //     alignment: Alignment.center,
              //     height: 50.0,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: <Widget>[
              //         Row(
              //           children: <Widget>[
              //             Container(
              //               child: Row(
              //                 children: <Widget>[
              //                   Icon(
              //                     Icons.access_time,
              //                     size: 18.0,
              //                     color: Colors.teal,
              //                   ),
              //                   Text(
              //                     " $_time",
              //                     style: TextStyle(
              //                         color: Colors.teal,
              //                         fontWeight: FontWeight.bold,
              //                         fontSize: 18.0),
              //                   ),
              //                 ],
              //               ),
              //             )
              //           ],
              //         ),
              //         Text(
              //           "  Change",
              //           style: TextStyle(
              //               color: Colors.teal,
              //               fontWeight: FontWeight.bold,
              //               fontSize: 18.0),
              //         ),
              //       ],
              //     ),
              //   ),
              //   color: Colors.white,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
