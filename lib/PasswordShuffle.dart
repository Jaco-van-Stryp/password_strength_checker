import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'main.dart';
import 'dart:async';
import 'localPasswords.dart';
import 'package:toast/toast.dart';

class PasswordShuffle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PasswordShuffleState();
  }
}

class _PasswordShuffleState extends State<PasswordShuffle> {
  Timer maintimer;
  String computedGuess = "";
  String actualPassword = PasswordContents().getPasswordContents();
  Widget fancyText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 25),
    );
  }

  Widget fancyDivider() {
    return Padding(padding: EdgeInsets.all(8.0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attempt To Guess Password'),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView(children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            fancyDivider(),
            fancyText("Welcome To Password Shuffler");
            Padding(padding: EdgeInsets.all(48.0)), //* Required For Banner Ad
          ],
        ),
      ]),
    );
  }
  String randomShuffel(String input)
  {
    
  }
}
