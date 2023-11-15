import 'package:flutter/material.dart';
import 'package:flutter_in_app_purchase_demo/screens/inner_screens/non_consumable_items.dart';
import 'package:flutter_in_app_purchase_demo/screens/inner_screens/remove_ads.dart';
import 'package:flutter_in_app_purchase_demo/screens/inner_screens/subscription.dart';
import 'package:flutter_in_app_purchase_demo/utils/constants.dart';
import 'package:onepref/onepref.dart';

import '../../components/snackbar.dart';
import '../inner_screens/consumable_items.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int reward = 0;
  bool isSubscribed = false;
  bool adsRemoved = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    reward = OnePref.getInt(Constants.rewardKey) ?? 0;
    adsRemoved = OnePref.getRemoveAds() ?? false;
    isSubscribed = OnePref.getPremium() ?? false;
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "$reward",
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Constants.txtColor,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Text(
                    "Remaining Coins",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Constants.txtColor,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  child: OnClickAnimation(
                    onTap: () {
                      var tempReward = OnePref.getInt(Constants.rewardKey) ?? 0;
                      if (tempReward > 0) {
                        tempReward--;
                        OnePref.setInt(Constants.rewardKey, tempReward);
                        setState(() {
                          reward = tempReward;
                        });
                      } else {
                        openSnackBar(
                          context: context,
                          btnName: "OK",
                          title: "Restore",
                          message: "Oops! You ran out of coins, please top up.",
                          color: Colors.accents,
                          bgColor: Constants.txtColor,
                        );

                        OnePref.setInt(Constants.rewardKey, 0);
                        setState(() {
                          reward = 0;
                        });
                      }
                    },
                    child: Card(
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "USE 1 COIN",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: OnClickAnimation(
                    onTap: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ConsumableItems()))
                    },
                    child: const Text(
                      "TOP UP",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Text(
                  "SUBSCRIBED ",
                  style: TextStyle(
                      color: Constants.txtColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Card(
                  color: isSubscribed ? Colors.green : Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      isSubscribed ? "YES" : "NO",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: OnClickAnimation(
                    onTap: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Subscriptions()))
                    },
                    child: const Text(
                      "BUY",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Visibility(
              visible: true,
              child: Row(
                children: [
                  Text(
                    "REMOVE ADS ",
                    style: TextStyle(
                        color: Constants.txtColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Card(
                    color: adsRemoved ? Colors.green : Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        adsRemoved ? "ON" : "OFF",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: OnClickAnimation(
                      onTap: () => {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const NonConsumable()))
                      },
                      child: const Text(
                        "BUY",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: OnClickAnimation(
                onTap: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RemoveAds()))
                },
                child: const Text(
                  "YouTube",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Visibility(
              visible: false,
              child: Row(
                children: [
                  Expanded(
                    child: OnClickAnimation(
                      onTap: () => {},
                      child: Card(
                        color: Constants.txtColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "BUY THIS DEMO SOURCE CODE",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
}
