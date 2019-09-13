import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'main.dart';
import 'dart:async';
import 'localPasswords.dart';
import 'package:toast/toast.dart';

class PassGuessAlgorithms extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PassGuessAlgorithmsState();
  }
}

class _PassGuessAlgorithmsState extends State<PassGuessAlgorithms> {
  Timer maintimer;
  String computedGuess = "";
  String actualPassword = PasswordContents().getPasswordContents();
  @override
  Widget fancyText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 25),
    );
  }

  Widget fancyDivider() {
    return Divider(
      height: 10,
      color: Colors.white,
      thickness: 3,
    );
  }

  String guessing = "";
  int guesses = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attempt To Guess Password'),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            fancyText("We Will Try To Guess the password: " +
                actualPassword +
                "\nBy Generating Random Characters\n\nWarning - Long passwords Will take a very long time!"),
            fancyDivider(),
            RaisedButton(
              textColor: Colors.white,
              color: Colors.redAccent,
              child: Text('Start Guessing'),
              onPressed: () {
                guesses = 0;
                updateState();
              },
            ),
            fancyDivider(),
            fancyText("Total Guesses So Far - [" + guesses.toString() + "]"),
            fancyText("" + guessing + ""),
            fancyDivider(),
            RaisedButton(
              child: Text("Stop & Back"),
              onPressed: () {
                Navigator.pop(context);
                busy = false;
                maintimer.cancel();
              },
              color: Colors.greenAccent,
            )
          ],
        ),
      ),
    );
  }

  bool busy = false;
  String longList = LocalPasses().getlocal();
  void updateState() {
    if (busy == false) {
      busy = true;
      if (longList.contains(actualPassword)) {
        guesses++;
        setState(() {
          guessing = "We've Guessed your password in " +
              guesses.toString() +
              " Guess\nThis was a very common Password!";
          busy = false;
        });
      } else {
        maintimer = Timer.periodic(Duration(milliseconds: 1), (timer) {
          guess();
        });
      }
    } else {
      Toast.show("Already Guessing...", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void guess() {
    String random = randomString(actualPassword.length);
    String randomNum = randomNumeric(actualPassword.length);
    String randomAlph = randomAlphaNumeric(actualPassword.length);
    String randomLet = randomAlpha(actualPassword.length);

    setState(() {
      guessing = "Guessing - " + random;
      guesses++;
    });
    print("Str - " +
        random +
        "\nNum - " +
        randomNum +
        "\n AlphNum - " +
        randomAlph +
        "\n Alph - " +
        randomLet);
    if (random == actualPassword ||
        randomNum == actualPassword ||
        randomAlph == actualPassword ||
        randomLet == actualPassword) {
      maintimer.cancel();
      busy = false;
      setState(() {
        guessing =
            "We've Guessed your password in " + guesses.toString() + " Guesses";
      });
    }
  }
}
