import 'package:flutter/material.dart';
import 'package:overlock/constants.dart';

import '../size_config.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key key,
    this.text,
    this.image,
  }) : super(key: key);
  final String text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(height: 60,),
        Text(
          "OVERLOCK",
          style: TextStyle(
            fontSize: 30,
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(height: 10,),

        Text(
          text,
          textAlign: TextAlign.center,
        ),

        Expanded(
          child: Image.asset(
            image,

          ),
        ),

      ],
    );
  }
}
