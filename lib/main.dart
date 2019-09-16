import 'dart:io';

import 'package:flutter/material.dart';
import 'package:password_strength/password_strength.dart';
import 'package:password_strength_checker/PasswordShuffle.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'PassGuessAlgorithms.dart';
import 'ImprovePass.dart';
import 'package:localstorage/localstorage.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'PasswordShuffle.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Password Strength Checker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Password Strength Checker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class AdDisplayInfo {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print('DEBUG - PATH LOCATED - $path/counter.txt');
    return File('$path/counter.txt');
  }

  Future<File> writeCounter(int counter) async {
    try {
      final file = await _localFile;

      // Write the file.
      print("DEBUG - Successfully Written To file");
      return file.writeAsString('$counter');
    } on Exception catch (e) {
      print("Something went wrong");
      print(e);
      return null;
    }
  }

  Future<String> readCounter() async {
    try {
      final file = await _localFile;
      // Read the file.
      String contents = await file.readAsString();
      print("DEBUG - Successfully read file - " + contents);
      return (contents);
    } catch (e) {
      // If encountering an error, return 0.
      print("DEBUG - Failed To read file");

      return "0";
    }
  }
}

class PasswordContents {
  final LocalStorage storage = new LocalStorage('TempPass');

  void setPasswordContents(String passwordC) {
    storage.setItem('TempPass', passwordC);
  }

  String getPasswordContents() {
    try {
      return storage.getItem('TempPass');
    } on Exception catch (e) {
      print(e);
      return "password";
    }
  }
}

class UserRatingManager {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print('DEBUG - PATH LOCATED - $path/counter.txt');
    return File('$path/reviewManager.txt');
  }

  Future<File> writeCounter(int counter) async {
    try {
      final file = await _localFile;

      // Write the file.
      print("DEBUG - Successfully Written To file");
      return file.writeAsString('$counter');
    } on Exception catch (e) {
      print("Something went wrong");
      print(e);
      return null;
    }
  }

  Future<String> readCounter() async {
    try {
      final file = await _localFile;
      // Read the file.
      String contents = await file.readAsString();
      print("DEBUG - Successfully read file - " + contents);
      return (contents);
    } catch (e) {
      // If encountering an error, return 0.
      print("DEBUG - Failed To read file");

      return "0";
    }
  }
}

class _MyHomePageState extends State<MyHomePage> {
  //Declarations
  var passClass = PasswordContents();
  String adText = "Permenantly Unlock Additional Features [Free]";
  int totalClicks = 10;
  String passwordStrength = " ";
  String genPass = "";
  int passwordCrackingAttempts = 0;
  bool rewarded;

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

//Navigations
  Future navigateToPageGuesser(context) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PassGuessAlgorithms()));
  }

  Future navigateToPageImprove(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ImprovePass()));
  }

  Future navigateToPasswordManiplulation(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PasswordShuffle()));
  }

  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: 'ca-app-pub-2887967406057408/4600454367',
        //Change BannerAd adUnitId with Admob ID
        size: AdSize.smartBanner,
        listener: (MobileAdEvent event) {
          print("BannerAd $event");
        });
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: 'ca-app-pub-2887967406057408/9844401555',
        //Change Interstitial AdUnitId with Admob ID
        listener: (MobileAdEvent event) {
          print("IntersttialAd $event");
        });
  }

  @override
  void initState() {
    AdDisplayInfo().readCounter().then((val) {
      print("DEBUG - CONTENTS IN DATA FILE - " + val);
      if (val == "1") {
        setState(() {
          rewarded = true;
        });
        print("DEBUG - REWARDED USER WITH REWARD PROGRAM");
      } else {
        print("DEBUG - FAILED TO VALIDATE REWARD PROGRAM");
      }
    });

    PasswordContents().setPasswordContents("password");

    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-2887967406057408~1235924424');
    //Change appId With Admob Id
    RewardedVideoAd.instance.load(
        adUnitId: 'ca-app-pub-2887967406057408/7198018928',
        targetingInfo: targetingInfo);

    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.rewarded) {
        AdDisplayInfo().writeCounter(1);
        setState(() {
          // Here, apps should update state to reflect the reward.
          rewarded = true;
          adText = "Unlock Features";
        });
      }
    };

    _bannerAd = createBannerAd()
      ..load()
      ..show();

    super.initState();
  }

  //STORE WIDGET

  //STORE WIDGET

  String appID = "";
  String output = "";

  Widget rewardAdButton() {
    //Creating Additional Features To The App.
    if (rewarded == true) {
      return Column(
        children: <Widget>[
          Text(
            "Additional Features",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  child: Text(
                    "Attempt To Guess Password",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  color: Colors.red,
                  onPressed: () {
                    String code = PasswordContents().getPasswordContents();
                    if (code == "" || code == null) {
                      Toast.show(
                          "You need to enter a password to do this!", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                    } else {
                      navigateToPageGuesser(context);
                    }
                  },
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  child: Text(
                    "Password Quality Test",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  color: Colors.red,
                  onPressed: () {
                    String code = "";

                    code = PasswordContents().getPasswordContents();

                    if (code == "" || code == null) {
                      Toast.show(
                          "You need to enter a password to do this!", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                    } else {
                      navigateToPageImprove(context);
                    }
                  },
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  child: Text(
                    "Password Manipulation",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  color: Colors.red,
                  onPressed: () {
                    String code = "";

                    code = PasswordContents().getPasswordContents();
                    if (code == "" || code == null) {
                      Toast.show(
                          "You need to enter a password to do this!", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                    } else {
                      navigateToPasswordManiplulation(context);
                    }
                  },
                ),
              )
            ],
          ),
        ],
      );
    } else {
      return MaterialButton(
        child: Text(
          adText,
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.blueAccent,
        onPressed: () {
          setState(() {
            RewardedVideoAd.instance.show();
          });
        },
      );
    }
  }

  void clearAds() {
    _bannerAd.dispose();
    _interstitialAd.dispose();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd.dispose();
    final LocalStorage storage = new LocalStorage('TempPass');
    storage.deleteItem("TempPass");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Divider(color: Colors.white),
              Text(
                'Enter a password',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.display1,
              ),
              Divider(
                color: Colors.white,
              ),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (text) {
                  passClass.setPasswordContents(text);
                  refreshPasswordStrength(text);
                },
                autofocus: true,
                style: TextStyle(fontSize: 25),
              ),
              Divider(
                color: Colors.white,
              ),
              Text(
                passwordStrength,
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
              Divider(
                color: Colors.white,
              ),
              MaterialButton(
                child: Text(
                  "Generate A Strong Password",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blueAccent,
                onPressed: () => {
                  setState(() {
                    genPass = randomString(16);
                  }),
                  totalClicks = totalClicks - 1,
                  if (totalClicks <= 0)
                    {
                      createInterstitialAd()
                        ..load()
                        ..show(),
                      totalClicks = 15,
                    }
                },
              ),
              SelectableText(
                genPass,
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
              rewardAdButton(),
              Padding(padding: EdgeInsets.all(48.0)),
            ],
          ),
        ],
      ),
    );
  }

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    nonPersonalizedAds: false,
    keywords: <String>['Charity', 'Donate'],
  );
  void refreshPasswordStrength(String input) {
    double strength = estimatePasswordStrength(input);

    String power;
    if (strength == 1) {
      power = "Uncrackable";
    } else if (strength < 0.1) {
      power = "Terrible!";
    } else if (strength < 0.3) {
      power = "Weak!";
    } else if (strength < 0.5) {
      power = "Okayish";
    } else if (strength < 0.6) {
      power = "Okay";
    } else if (strength < 0.7) {
      power = "Decent";
    } else if (strength < 0.8) {
      power = "Good!";
    } else if (strength < 0.9) {
      power = "Great!";
    } else if (strength < 0.95) {
      power = "Perfect!";
    } else {
      power = "Excelent!";
    }
    double temp = strength * 100;

    setState(() {
      passwordStrength = "Your password is considered " +
          power +
          " (" +
          temp.toStringAsFixed(2) +
          "% Strength)";
    });
  }
}
