// ignore_for_file: unused_field
// ignore: avoid_print

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_in_app_purchase_demo/helpers/manage_purchases.dart';

import 'package:in_app_purchase/in_app_purchase.dart';
// ignore: depend_on_referenced_packages
// ignore: depend_on_referenced_packages
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:onepref/onepref.dart';

class Store extends StatefulWidget {
  const Store({Key? key}) : super(key: key);
  static const String routeName = "/Store";

  @override
  State<Store> createState() => _StoreState();
}

//In App Product Ids
const String coins_10Id = 'test_coins_30';
const String coins_20Id = 'test_coins_201';
const String coins_30Id = 'test_coins_111';

const String removed_1ads = 'test_remove_ads1';

////In App Product RemoveAd
const String removeAds = 'test_coins_111';

//Subscription Ids
const String monthlySubscriptionId = 'test_sub_monthly1';
const String weeklySubscriptionId = 'test_sub_weekly1';

const List<String> productIds = <String>[
  coins_10Id,
  coins_20Id,
  coins_30Id,
  monthlySubscriptionId,
  weeklySubscriptionId,
];

class _StoreState extends State<Store> {
  int coins = 0;
  bool adIsReady = false;

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  late List<String> _notFoundIds = <String>[];
  late List<ProductDetails> _products = <ProductDetails>[];
  late final List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  late bool _isAvailable = false;
  late bool _purchasePending = false;
  late bool _loading = true;
  String? _queryProductError;
  final String _subscriptionTypeText = "";
  final List<Widget> stack = <Widget>[];

  @override
  void initState() {
    super.initState();

    //Call this to activate the OnePref sharedPreference instance
    OnePref.init();

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;

    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
      checkSubscription(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
    });

    establishConnection();

    coins = OnePref.getInt("coins") ?? 0;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "Store",
        style: TextStyle(color: Colors.white),
      )),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            !OnePref.getBool("subscribed")!
                ? Text(
                    "You have $coins coin(s)",
                  )
                : const Text(
                    "Unlimited Coins",
                  ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () {
                  if (coins > 0) {
                    setState(() {
                      coins = OnePref.getInt("coins") ?? 0;
                      coins = coins - 1;
                      OnePref.setInt("coins", coins);
                    });
                  }
                },
                child: const Text("Use Coins")),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: !_loading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Loading Products...")
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _products.length,
                      itemBuilder: ((context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(
                              _products[index].title,
                            ),
                            subtitle: Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Text(
                                _products[index].description,
                              ),
                            ),
                            trailing: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.orange,
                              ),
                              onPressed: () {
                                _handlePurchase(_products[index]);
                              },
                              child: Text(
                                _products[index].price,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
            ),
            Container(
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "Terms and Conditions",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                )),
            const Text(
              "By subscribing you get access to unlimited coins, remove ads and premium features.",
              textAlign: TextAlign.center,
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> establishConnection() async {
    final bool isConnected = await _inAppPurchase.isAvailable();
    if (isConnected) {
      setState(() {
        _isAvailable = isConnected;
      });
      getProducts();
    }
  }

  Future<void> getProducts() async {
    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(productIds.toSet());
    if (productDetailResponse.productDetails.isNotEmpty) {
      setState(() {
        _products = productDetailResponse.productDetails;
        _notFoundIds = productDetailResponse.notFoundIDs;
        _purchasePending = false;
        _loading = true;
      });
    } else {
      setState(() {
        _purchasePending = false;
        _loading = false;
      });
    }
  }

  Future<void> _handlePurchase(ProductDetails productDetails) async {
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

    switch (productDetails.id) {
      case coins_10Id:
      case coins_20Id:
      case coins_30Id:
        _inAppPurchase.buyConsumable(
            purchaseParam: purchaseParam, autoConsume: true);
        break;
      default:
        _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
        break;
    }
  }

  Future<void> _deliverProduct(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.productID == coins_10Id) {
      setState(() {
        coins = OnePref.getInt("coins") ?? 0;
        coins = coins + 10;
        OnePref.setInt("coins", coins);
      });
    } else if (purchaseDetails.productID == coins_20Id) {
      setState(() {
        coins = OnePref.getInt("coins") ?? 0;
        coins = coins + 20;
        OnePref.setInt("coins", coins);
      });
    } else if (purchaseDetails.productID == coins_30Id) {
      setState(() {
        coins = OnePref.getInt("coins") ?? 0;
        coins = coins + 30;
        OnePref.setInt("coins", coins);
      });
    } else if (purchaseDetails.productID == weeklySubscriptionId) {
      ManagePurchases.updateWeeklySub(purchaseDetails);
    } else if (purchaseDetails.productID == monthlySubscriptionId) {
      ManagePurchases.updateMonthlySub(purchaseDetails);
    }
    setState(() {
      _purchasePending = false;
      _purchases.add(purchaseDetails);
    });
  }

  void handleError(IAPError error) {
    // ignore: avoid_print
    print("Error caught: $error");
    setState(() {
      _purchasePending = false;
    });
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // ignore: avoid_print
    print("There was error purchase productId ${purchaseDetails.productID}");
  }

  void checkSubscription(List<PurchaseDetails> purchaseDetailsList) {
    if (purchaseDetailsList.isNotEmpty) {
      for (int i = 0; i < purchaseDetailsList.length; i++) {
        if (purchaseDetailsList[i].productID == weeklySubscriptionId) {
          ManagePurchases.updateWeeklySub(purchaseDetailsList[i]);
        } else if (purchaseDetailsList[i].productID == monthlySubscriptionId) {
          ManagePurchases.updateMonthlySub(purchaseDetailsList[i]);
        }
      }
    } else {
      ManagePurchases.resetSubscription();
    }
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    checkSubscription(purchaseDetailsList);
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        setState(() {
          _purchasePending = true;
        });
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          //
          //
          if (Platform.isAndroid) {
            switch (purchaseDetails.productID) {
              case coins_10Id:
              case coins_20Id:
              case coins_30Id:
                final InAppPurchaseAndroidPlatformAddition androidAddition =
                    _inAppPurchase.getPlatformAddition<
                        InAppPurchaseAndroidPlatformAddition>();
                await androidAddition.consumePurchase(purchaseDetails);
                break;
              default:
            }
          }
          //
          //
          if (purchaseDetails.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchaseDetails);
          }
          _deliverProduct(purchaseDetails);
        } else {
          _handleInvalidPurchase(purchaseDetails);
        }
      }
    }
  }
}
