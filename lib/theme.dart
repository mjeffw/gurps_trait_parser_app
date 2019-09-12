import 'package:flutter/material.dart';

const standard_gap = 8.0;
const standard_radius = 4.0;

var gurpsTheme = ThemeData(
  fontFamily: 'Muli',
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    isDense: true,
    contentPadding:
        EdgeInsets.symmetric(vertical: standard_gap, horizontal: standard_gap),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(standard_radius)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    ),
  ),
  cardTheme: CardTheme(
    margin: EdgeInsets.all(standard_gap),
    shape: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[300], width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(standard_radius))),
  ),
  bottomAppBarTheme: BottomAppBarTheme(shape: const CircularNotchedRectangle()),
);

var titleStyle = gurpsTheme.textTheme.title;
var largeLabelStyle = TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold);
var smallLabelStyle = TextStyle(fontSize: 10.0, fontWeight: FontWeight.normal);
var focusedBorder = gurpsTheme.inputDecorationTheme.focusedBorder;
