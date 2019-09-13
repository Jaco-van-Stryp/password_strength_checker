import 'package:flutter/material.dart';
import 'package:password_strength/password_strength.dart';
import 'package:random_string/random_string.dart';
import 'main.dart';
import 'localPasswords.dart';

class ImprovePass extends StatelessWidget {
  String password = PasswordContents().getPasswordContents();

  Widget fancyText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Improve Password'),
          backgroundColor: Colors.redAccent,
        ),
        body: Center(
            child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                fancyText(qualityTest()),
                Divider(color: Colors.white),
                RaisedButton(
                  textColor: Colors.white,
                  color: Colors.redAccent,
                  child: Text('Go Back'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ],
        )));
  }

  String qualityTest() {
    String longList = LocalPasses().getlocal();
    int rating = 0;
    double strength = estimatePasswordStrength(password);
    double temp = strength * 100;
    String quality =
        "\nYour Selected Password: " + password + "\n\nQuality Test:\n\n";
    if (temp.toInt() >= 85) {
      quality += "\nThis password Has A Strength Rating of " +
          temp.toInt().toString() +
          "% which is above average - ✔️";
      rating++;
    } else {
      quality += "\nThis password Has A Strength Rating of " +
          temp.toInt().toString() +
          "% which is Below average ❌ \nTry adding more random characters and numbers";
    }

    if (password.length >= 16) {
      quality += "\n\nThis password Is " +
          password.length.toString() +
          " characters long, which is at or above the recommended mark! ✔️";
      rating++;
    } else {
      quality += "\n\nThis password Is " +
          password.length.toString() +
          " characters long, which is below the recommended mark of 16! ❌ \nTry adding something random to the password, for example: \n" +
          password +
          randomString(16 - password.length);
    }
    if (temp.toInt() == 0) {
      quality +=
          "\n\nThis password contains a common word ❌\nA Good Password should be randomised and have no meaning attached";
    }

    if (password.toLowerCase() == password ||
        password.toUpperCase() == password) {
      quality +=
          "\n\nYour password only contains one case of characters ❌ \nA Good Password should Contain upper and lower case characters!";
    } else {
      rating++;
      quality += "\n\nYour password Contains Upper And Lowercase characters ✔️";
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
      quality +=
          "\n\nYour password only does not contain enough special characters! ❌\nPasswords should contain numbers, letters and special characters!";
    } else {
      quality += "\n\nYour password Contains more than just letters! ✔️";
      rating++;
    }
    if (longList.contains(password)) {
      quality +=
          "\n\nYour password Was found in a Commonly Used Passwords List! ❌\nYour Password Should Be Something That Noone else uses!";
    } else {
      quality +=
          "\n\nYour password Does Not Exist in a Commonly Used Passwords List! ✔️";
      rating++;
    }

    if (rating >= 5) {
      quality +=
          "\n\nYour password Passed the rating test! ✔️\nGood Job On Staying Secure!";
    } else {
      quality +=
          "\n\nYour password Failed the rating test! ❌\nYou should change this password if you still use it!";
    }
    return quality;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }
}
