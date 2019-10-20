import 'dart:math';
import 'package:flutter/material.dart';
import 'package:password_strength/password_strength.dart';
import 'main.dart';
import 'dart:async';
import 'localPasswords.dart';

class PasswordShuffle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PasswordShuffleState();
  }
}

class _PasswordShuffleState extends State<PasswordShuffle> {
  int countAnimate = 0;
  String computedGuess = "";
  String actualPassword = PasswordContents().getPasswordContents();
  Widget fancyText(String text) {
    return SelectableText(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 25),
    );
  }

  Widget fancyDivider() {
    return Padding(padding: EdgeInsets.all(8.0));
  }

  String reversedText = "";
  String sortedText = "";
  String actualText = "";
  String reverseSort = "";
  String alphValue = "";
  String strength = "";
  String ratingTest = "";
  String len = "";
  String totalNumbers = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Manipulator'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: ListView(children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            fancyDivider(),
            fancyText("Welcome To The Password Manipulator"),
            fancyDivider(),
            fancyText("The Original Password is " + actualPassword),
            fancyDivider(),
            RaisedButton(
              child: Text("Generate Manipulated Passwords",
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                setState(() {
                  startRandomShuffelAnimaiton(actualPassword);
                  sortedText = "Sorted - " + sortString(actualPassword);
                  reversedText = "Reversed - " + reverseText(actualPassword);
                  reverseSort = "Sorted In Reverse - " +
                      sortReverse(sortString(actualPassword));
                  alphValue = "Code Unit Password Value - " +
                      passAlphabetValue(actualPassword).toString();
                  strength = "Password Strength - " +
                      (estimatePasswordStrength(actualPassword) * 100)
                          .toStringAsFixed(2) +
                      "%";
                  ratingTest =
                      "Password Quality - " + qualityTest(actualPassword);
                  len = "Password Length - " + actualPassword.length.toString();
                  totalNumbers =
                      "Total Numbers - " + totalNum(actualPassword).toString();
                });
              },
              color: Colors.redAccent,
            ),
            fancyDivider(),
            fancyText("" + actualText),
            fancyDivider(),
            fancyText(sortedText),
            fancyDivider(),
            fancyText(reversedText),
            fancyDivider(),
            fancyText(reverseSort),
            fancyDivider(),
            fancyText(alphValue),
            fancyDivider(),
            fancyText(strength),
            fancyDivider(),
            fancyText(ratingTest),
            fancyDivider(),
            fancyText(len),
            fancyDivider(),
            fancyText(totalNumbers),
            fancyDivider(),
            // fancyText(secondsToWords(getTotalSecondsCrackTime(actualPassword))),
            // fancyDivider(),
            Padding(padding: EdgeInsets.all(48.0)), //* Required For Banner Ad
          ],
        ),
      ]),
    );
  }

  void startRandomShuffelAnimaiton(String input) {
    Timer fancyAnimation;

    fancyAnimation = Timer.periodic(Duration(milliseconds: 1), (timer) {
      setState(() {
        actualText = randomShuffel(input);
        countAnimate++;
      });
      if (countAnimate >= 150) {
        fancyAnimation.cancel();
        countAnimate = 0;
      }
    });
  }

  String randomShuffel(String input) {
    int len = 0;
    len = input.length;

    print("INPUT LENGTH = " + len.toString());
    String newInput = "";
    Random r = new Random();
    List<int> numbersUsed = new List<int>();
    while (numbersUsed.length != len) {
      int numNew = r.nextInt(len);
      if (!numbersUsed.contains(numNew)) {
        numbersUsed.add(numNew);
      }
    }

    for (int i = 0; i < len; i++) {
      newInput += input[numbersUsed[i]];
    }

    return "Shuffled - " + newInput;
  }

  String sortString(String input) {
    String newInput = "";

    for (int i = 0; i < input.length; i++) {
      newInput += input[i] + " ";
    }
    List<String> list = new List<String>();
    newInput = newInput.trim();
    list = newInput.split(" ");
    list.sort();
    String finalString = "";
    for (int i = 0; i < list.length; i++) {
      finalString += list[i];
    }
    return finalString;
  }

  String reverseText(String input) {
    String newInput = "";
    for (int i = input.length; i > 0; i--) {
      newInput += input[i - 1];
    }
    return newInput;
  }

  String sortReverse(String input) {
    String newInput = "";
    for (int i = input.length; i > 0; i--) {
      newInput += input[i - 1];
    }
    return newInput;
  }

  int passAlphabetValue(String input) {
    int total = 0;
    for (int i = 0; i < input.length; i++) {
      int value = input[i].codeUnitAt(0);
      total = total + value;
    }
    return total;
  }

  String qualityTest(String password) {
    String longList = LocalPasses().getlocal();
    int rating = 0;
    double strength = estimatePasswordStrength(password);
    double temp = strength * 100;
    if (temp.toInt() >= 85) {
      rating++;
    }

    if (password.length >= 10) {
      rating++;
    }

    if (password.toLowerCase() == password ||
        password.toUpperCase() == password) {
    } else {
      rating++;
    }
    bool containsL = false;
    bool containsN = false;

    for (int i = 0; i < password.length; i++) {
      if (isNumeric(password[i]) == true) {
        containsN = true;
      }

      if (isNumeric(password[i]) == false) {
        containsL = true;
      }
    }
    if (containsL == false || containsN == false) {
    } else {
      rating++;
    }
    if (longList.contains(password)) {
    } else {
      rating++;
    }

    return "[ " +
        rating.toString() +
        " / 5 ] (" +
        (rating / 5 * 100).toStringAsFixed(0) +
        "%)";
  }

  int totalNum(String input) {
    int numbers = 0;

    for (int i = 0; i < input.length; i++) {
      if (isNumeric(input[i]) == true) {
        numbers++;
      }
    }
    return numbers;
  }

  double getTotalSecondsCrackTime(String str) {
    double total = toThePowerOf(str.length.toDouble(), 93) / 11344618;

    print("TOTAL - " + total.toString());
    return (total);
  }

  num toThePowerOf(double val1, double val2) {
    double total = val1;
    for (int i = 0; i < val2; i++) {
      total = total + (total * val1);
      print("TOTAL CALC " + total.toString());
    }
    return total;
  }

  String secondsToWords(double seconds) {
    double finalSeconds = seconds;
    int years = 0;
    int months = 0;
    int days = 0;
    int hours = 0;
    int minutes = 0;
    int decades = 0;
    double temp = 0;
    print("TOTAL SECONDS - " + seconds.toString());

    temp = finalSeconds / 31556952;
    years = temp.toInt();
    temp = finalSeconds / 2629746;
    months = temp.toInt() - (years * 12);
    temp = finalSeconds / 86400;
    days = temp.toInt() - (months * 31);
    /*
    while (finalSeconds > 31556952) {
      years++;
      finalSeconds = seconds - 31556952;
      print("Added Year");
    }
    while (finalSeconds > 2629746) {
      months++;
      finalSeconds = finalSeconds - 2629746;
      print("Added Seconds");
    }
    while (finalSeconds > 86400) {
      days++;
      finalSeconds = finalSeconds - 86400;
    }
    print("Added Days");

    while (finalSeconds > 3600) {
      hours++;
      finalSeconds = finalSeconds - 3600;
    }
    print("Added Hours");

    while (finalSeconds > 60) {
      minutes++;
      finalSeconds = finalSeconds - 60;
    }
    print("Added Minutes");

    while (years > 10) {
      decades++;
      years = years - 10;
      print("Added Decades");
    }
    */
    String constructString = "In ";
    if (decades != 0) {
      constructString += decades.toString() + " Decades ";
    }
    if (years != 0) {
      constructString += years.toString() + " Years ";
    }
    if (months != 0) {
      constructString += months.toString() + " Months ";
    }
    if (days != 0) {
      constructString += days.toString() + " Days ";
    }
    if (hours != 0) {
      constructString += hours.toString() + " Hours ";
    }
    if (minutes != 0) {
      constructString += minutes.toString() + " Minutes ";
    }
    if (seconds != 0) {
      constructString += seconds.toString() + " Seconds ";
    }
    if (constructString == "In ") {
      constructString = "Instantly";
    }
    return "Your Password Will Be Cracked By A Brute Force Attack " +
        constructString;
  }

  num pow(int x, int y) {
    if (y == 0) {
      return 1;
    }

    if (y == 1) {
      return x;
    }

    return pow(x, y - 1) * x;
  }

  bool isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  //End methods

}
