import 'package:flutter/material.dart';
import 'package:password_strength/password_strength.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'PassGuessAlgorithms.dart';
import 'ImprovePass.dart';
import 'package:localstorage/localstorage.dart';
import 'package:toast/toast.dart';

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

class PasswordContents {
  final LocalStorage storage = new LocalStorage('TempPass');

  void setPasswordContents(String passwordC) {
    storage.setItem('TempPass', passwordC);
  }

  String getPasswordContents() {
    try
    {
    return storage.getItem('TempPass');

    } catch (e)
    {
        return "";
    }
  }
}

class _MyHomePageState extends State<MyHomePage> {
  //Declarations
  var passClass = PasswordContents();
  String adText = "Disable Ad's & Unlock Additional Features [Free]";
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
        rewarded = true;
        setState(() {
          // Here, apps should update state to reflect the reward.
          adText = "";
          clearAds();
        });
      }
    };

    _bannerAd = createBannerAd()
      ..load()
      ..show();

    super.initState();
  }

  Widget rewardAdButton() {
    //Creating Additional Features To The App.
    if (rewarded == true) {
      return Column(
        children: <Widget>[
          Divider(color: Colors.white),
          Text(
            "Additional Features",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25),
          ),
          Divider(color: Colors.white),
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
                    if (PasswordContents().getPasswordContents() == "") {
                      Toast.show(
                          "You need to enter a password to do this!", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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
                    "Password Rating Test",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  color: Colors.red,
                  onPressed: () {
                    if(PasswordContents().getPasswordContents() == "")
                    {
                       Toast.show(
                          "You need to enter a password to do this!", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    }
                    else{
                    navigateToPageImprove(context);

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
            adText = "Unlock Features";
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
                style: TextStyle(fontSize: 35),
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
                  if (totalClicks <= 0 && rewarded == false)
                    {
                      createInterstitialAd()
                        ..load()
                        ..show(),
                      totalClicks = 15,
                    }
                },
              ),
              Divider(
                color: Colors.white,
              ),
              SelectableText(
                genPass,
                style: TextStyle(fontSize: 35),
                textAlign: TextAlign.center,
              ),
              Divider(
                color: Colors.white,
              ),
              rewardAdButton(),
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
          temp.toInt().toString() +
          "% Strength)";
    });
  }
}
