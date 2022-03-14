import 'package:flutter/material.dart';

class AppConsts {
  static const List<BoxShadow> boxShadows = [
    BoxShadow(
        color: Colors.black,
        blurRadius: 1,
        spreadRadius: 3,
        offset: Offset(1, 1)),
    BoxShadow(
        color: Colors.black,
        blurRadius: 1,
        spreadRadius: 3,
        offset: Offset(-1, -1)),
    BoxShadow(
        color: Colors.black,
        blurRadius: 1,
        spreadRadius: 3,
        offset: Offset(-1, 1)),
    BoxShadow(
        color: Colors.black,
        blurRadius: 1,
        spreadRadius: 3,
        offset: Offset(1, -1)),
    BoxShadow(
        color: Colors.black,
        blurRadius: 3,
        spreadRadius: 5,
        offset: Offset(1.5, 1.5)),
  ];
}
