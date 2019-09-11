import 'package:flutter/material.dart';

var gurpsTheme = ThemeData(
  fontFamily: 'Muli',
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    ),
  ),
  cardTheme: CardTheme(
    margin: EdgeInsets.all(8.0),
  ),
);

var titleStyle = TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold);
