// ignore_for_file: unused_field

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_in_app_purchase_demo/helpers/manage_subscription.dart';

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

const bool _kAutoConsume = true;

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
  late List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  late List<String> _consumables = <String>[];
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
    initStoreInfo();

    coins = OnePref.getInt("coins") ?? 0;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();

    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(productIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _purchasePending = false;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Text(
                OnePref.getBool("subscribed")! ? "" : "GET MORE COINS",
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
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
              _buildConnectionCheckTile(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    await _inAppPurchase.restorePurchases();
                  },
                  child: const Text(
                    "Restore Subscription",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
              ),
              _buildProductList(),
              Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    "Terms and Conditions",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  )),
              const Text(
                "By subscribing you get access to unlimited coins, all application links and free from ads.",
                textAlign: TextAlign.center,
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionCheckTile() {
    return _loading
        ? const Card(child: ListTile(title: Text('Trying to connect...')))
        : Column(children: [
            Card(
              color:
                  OnePref.getBool("subscribed")! ? Colors.green : Colors.white,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  _subscriptionTypeText,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            _isAvailable != true
                ? Card(
                    child: Column(
                      children: const [
                        Divider(),
                        ListTile(
                          title: Text('Not connected'),
                          subtitle: Text(
                              'Unable to connect to the payments processor.'),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ]);
  }

  Card _buildProductList() {
    if (_loading) {
      return const Card(
        child: ListTile(
          leading: CircularProgressIndicator(),
          title: Text('Fetching products...'),
        ),
      );
    }

    if (!_isAvailable) {
      return const Card();
    }

    final List<ListTile> productList = <ListTile>[];
    if (_notFoundIds.isNotEmpty) {
      productList.add(
        const ListTile(
          title: Text(
            'Technical Error',
          ),
          subtitle: Text(
              'Oops something went wrong, check if you have internet access.'),
        ),
      );
    }

    productList.addAll(_products.map(
      (ProductDetails productDetails) {
        return ListTile(
          title: Text(
            productDetails.title,
          ),
          subtitle: Container(
            margin: const EdgeInsets.only(top: 5),
            child: Text(
              productDetails.description,
            ),
          ),
          trailing: TextButton(
            style: Platform.isIOS
                ? TextButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue)
                : TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
            onPressed: () {
              late PurchaseParam purchaseParam;
              if (Platform.isAndroid) {
                purchaseParam = GooglePlayPurchaseParam(
                    productDetails: productDetails,
                    applicationUserName: null,
                    changeSubscriptionParam: null);
              } else {
                purchaseParam = PurchaseParam(
                  productDetails: productDetails,
                  applicationUserName: null,
                );
              }

              if (productDetails.id == coins_10Id ||
                  productDetails.id == coins_20Id ||
                  productDetails.id == coins_30Id) {
                _inAppPurchase.buyConsumable(
                    purchaseParam: purchaseParam,
                    autoConsume: _kAutoConsume || Platform.isIOS);
              } else {
                _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
              }
            },
            child: Text(productDetails.price,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                )),
          ),
        );
      },
    ));

    return Card(
      elevation: 4,
      child: Column(
        children: productList,
      ),
    );
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.productID == coins_10Id) {
      setState(() {
        coins = OnePref.getInt("coins") ?? 0;
        coins = coins + 15;
        OnePref.setInt("coins", coins);
      });
    } else if (purchaseDetails.productID == coins_20Id) {
      setState(() {
        coins = OnePref.getInt("coins") ?? 0;
        coins = coins + 5;
        OnePref.setInt("coins", coins);
      });
    } else if (purchaseDetails.productID == coins_30Id) {
      setState(() {
        coins = OnePref.getInt("coins") ?? 0;
        coins = coins + 22;
        OnePref.setInt("coins", coins);
      });
    } else if (purchaseDetails.productID == weeklySubscriptionId) {
      ManageSubscription.updateWeeklySub(purchaseDetails);
    } else if (purchaseDetails.productID == monthlySubscriptionId) {
      ManageSubscription.updateMonthlySub(purchaseDetails);
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
      });
    }
    setState(() {
      _purchasePending = false;
    });
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  void checkSubscription(List<PurchaseDetails> purchaseDetailsList) {
    if (purchaseDetailsList.isNotEmpty) {
      for (int i = 0; i < purchaseDetailsList.length; i++) {
        if (purchaseDetailsList[i].productID == weeklySubscriptionId) {
          ManageSubscription.updateWeeklySub(purchaseDetailsList[i]);
        } else if (purchaseDetailsList[i].productID == monthlySubscriptionId) {
          ManageSubscription.updateMonthlySub(purchaseDetailsList[i]);
        }
      }
    } else {
      ManageSubscription.resetSubscription();
    }
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
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
            if (!_kAutoConsume && purchaseDetails.productID == coins_10Id ||
                purchaseDetails.productID == coins_20Id ||
                purchaseDetails.productID == coins_30Id) {
              final InAppPurchaseAndroidPlatformAddition androidAddition =
                  _inAppPurchase.getPlatformAddition<
                      InAppPurchaseAndroidPlatformAddition>();
              await androidAddition.consumePurchase(purchaseDetails);
            }
          }
          //
          //
          if (purchaseDetails.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchaseDetails);
          }
          deliverProduct(purchaseDetails);
        } else {
          _handleInvalidPurchase(purchaseDetails);
        }
      }
    }
  }
}
