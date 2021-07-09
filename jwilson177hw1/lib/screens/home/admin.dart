import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jwilson177hw1/screens/SubScreen/DynmaicLV.dart';
import 'package:jwilson177hw1/screens/home/profile.dart';
import 'package:jwilson177hw1/services/adminalert.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:jwilson177hw1/services/auth.dart';

class Admin extends StatefulWidget {
  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  String message = '';
  String msg = '';
  String current_user = '';
  var arr = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth1 = FirebaseAuth.instance;
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo();
  late BannerAd _bannerAd;
  int coins = 0;

  BannerAd createBannerAdd() {
    return BannerAd(
        targetingInfo: targetingInfo,
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.smartBanner,
        listener: (MobileAdEvent event) {
          print('Bnner Event: $event');
        });
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 10), () {
      _bannerAd.show();
    });
    final AuthService _auth = AuthService();
    AdminAlert db = new AdminAlert();
    // Future<String> msgs = db.getMessagesAsString();
    Future<String> uzr = db.getUser();

    // msgs.then((value) => setState(() {
    //       msg = value;
    //     }));
    uzr.then((value) => setState(() {
          current_user = value;
        }));
    return Scaffold(
        appBar: AppBar(
          title: Text("Messanger!"),
          backgroundColor: Colors.greenAccent,
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        drawer: new Drawer(
          child: ListView(
            children: <Widget>[
              TextButton.icon(
                icon: Icon(Icons.person),
                label: Text('Profile'),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                },
              ),
            ],
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  _bannerAd.dispose();
                  await RewardedVideoAd.instance.show();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddPage(
                            coins: coins,
                          )));
                },
                child: Text("Reward Add"),
              ),
              Expanded(child: DynamicLV()),
            ],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-8112380480118072~9870269244');
    _bannerAd = createBannerAdd()..load();
    RewardedVideoAd.instance.load(
        adUnitId: RewardedVideoAd.testAdUnitId, targetingInfo: targetingInfo);
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String? rewardType, int? rewardAmount}) {
      print('Rewarded event: $event');
      if (event == RewardedVideoAdEvent.rewarded) {
        setState(() {
          coins += 1000;
        });
      }
    };
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class AddPage extends StatefulWidget {
  final coins;
  AddPage({this.coins});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo();
  late InterstitialAd _interstitialAd;

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        targetingInfo: targetingInfo,
        adUnitId: InterstitialAd.testAdUnitId,
        listener: (MobileAdEvent event) {
          print('interstitial event: $event');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coins: ${widget.coins}'),
      ),
      body: Container(
        child: ElevatedButton(
          onPressed: () async {
            await _interstitialAd
              ..show();
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Admin()));
          },
          child: Text("Go back"),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-8112380480118072~9870269244');
    _interstitialAd = createInterstitialAd()..load();
  }
}
