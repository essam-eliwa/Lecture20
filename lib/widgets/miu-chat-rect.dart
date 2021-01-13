import 'dart:math';

import 'package:flutter/material.dart';

class MIUChatRect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
        transform: Matrix4.rotationZ(-7 * pi / 180)..translate(-10.0, -10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue.shade900,
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black26,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Text(
          'MIU-Chat',
          style: TextStyle(
            color: Theme.of(context).accentTextTheme.headline6.color,
            fontSize: 24,
            fontFamily: 'Anton',
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
