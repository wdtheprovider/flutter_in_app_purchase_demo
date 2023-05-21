import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
// ignore: depend_on_referenced_packages
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:onepref/onepref.dart';

import '../utils/constants.dart';

class IApEngine extends ChangeNotifier {
  //
  //
  List<String> notFoundIds = <String>[];
  List<ProductDetails> products = <ProductDetails>[];
  List<PurchaseDetails> purchases = <PurchaseDetails>[];
  bool purchasePending = false;
  bool isAvailable = false;
  bool bought = false;
  int reward = OnePref.getInt(Constants.rewardKey) ?? 0;

  //
  InAppPurchase inAppPurchase = InAppPurchase.instance;

  Future<bool> getIsAvailable() async {
    return await inAppPurchase.isAvailable();
  }

  Future<ProductDetailsResponse> queryProducts() async {
    return await inAppPurchase.queryProductDetails(getProductIdsOnly().toSet());
  }

  void handlePurchase(ProductDetails productDetails) {
    late PurchaseParam purchaseParam;
    Platform.isAndroid
        ? purchaseParam = GooglePlayPurchaseParam(
            productDetails: productDetails,
            applicationUserName: null,
          )
        : purchaseParam = PurchaseParam(
            productDetails: productDetails,
            applicationUserName: null,
          );

    for (var product in Constants.storeProductIds) {
      if (product.id == productDetails.id) {
        product.isConsumable
            ? IApEngine()
                .inAppPurchase
                .buyConsumable(purchaseParam: purchaseParam, autoConsume: true)
            : IApEngine()
                .inAppPurchase
                .buyNonConsumable(purchaseParam: purchaseParam);
      }
    }
  }

  List<String> getProductIdsOnly() {
    List<String> temp = <String>[];
    for (var product in Constants.storeProductIds) {
      temp.add(product.id);
    }
    return temp;
  }
}
