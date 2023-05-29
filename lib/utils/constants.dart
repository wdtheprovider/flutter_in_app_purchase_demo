import 'package:flutter/material.dart';
import 'package:onepref/onepref.dart';

class Constants {
  static String rewardKey = "reward";

  static final List<ProductId> storeProductIds = <ProductId>[
    ProductId(id: "test_coins_111", isConsumable: true, reward: 10),
    ProductId(id: "test_coins_201", isConsumable: true, reward: 20),
    ProductId(id: "test_coins_30", isConsumable: true, reward: 30),
  ];

  static List<String> benefits = [
    "Remove Ads",
    "Unlock all features",
    "Unlimited coins"
  ];

  static List<String> benefitRemoveAd = ["Remove Ads"];

  static const String appName = "F-InAppDemo";
  static Color txtColor = Colors.brown.shade800;
}
