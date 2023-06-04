import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_in_app_purchase_demo/screens/pages/dashboard.dart';
import 'package:flutter_in_app_purchase_demo/screens/pages/menu.dart';
import 'package:flutter_in_app_purchase_demo/screens/pages/settings.dart';
import 'package:flutter_in_app_purchase_demo/utils/constants.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onepref/onepref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await OnePref.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Constants.appName,
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        themeMode: ThemeMode.dark,
        home: const MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;

  final screens = [
    const Dashboard(),
    const Menu(),
    const Settings(),
  ];

  late BannerAd _bannerAd;
  bool _isLoaded = false;

  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  @override
  void initState() {
    super.initState();
    loadAd();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            Constants.appName,
            style: TextStyle(
              color: Constants.txtColor,
            ),
          ),
        ),
        body: SafeArea(
            child: Column(
          children: [
            Expanded(child: screens[currentIndex]),
            Visibility(
              visible: _isLoaded && OnePref.getPremium() == false,
              child: _isLoaded
                  ? Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: _bannerAd.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd),
                    )
                  : Container(),
            ),
          ],
        )),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          backgroundColor: Colors.orange,
          selectedItemColor: Colors.white,
          showUnselectedLabels: false,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() => currentIndex = index);
            // Respond to item press.
          },
          items: const [
            BottomNavigationBarItem(
              label: "Dashboard",
              icon: Icon(Icons.dashboard),
            ),
            BottomNavigationBarItem(
              label: "Store",
              icon: Icon(Icons.store),
            ),
            BottomNavigationBarItem(
              label: "Settings",
              icon: Icon(Icons.settings),
            ),
          ],
        ),
      );

  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          print('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          print('BannerAd failed to load: ${err.message}');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }
}
