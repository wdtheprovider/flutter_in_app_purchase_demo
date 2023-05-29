// ignore_for_file: unused_field
// ignore: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_in_app_purchase_demo/main.dart';
// ignore: depend_on_referenced_packages
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:onepref/onepref.dart';
// ignore: depend_on_referenced_packages
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '../../utils/constants.dart';

class ConsumableItems extends StatefulWidget {
  const ConsumableItems({Key? key}) : super(key: key);
  static const String routeName = "/ConsumableItems";

  @override
  State<ConsumableItems> createState() => _ConsumableItemsState();
}

class _ConsumableItemsState extends State<ConsumableItems> {
  late final List<String> _notFoundIds = <String>[];
  late final List<ProductDetails> _products = <ProductDetails>[];
  late final List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  late bool _isAvailable = false;
  late bool _purchasePending = false;
  IApEngine iApEngine = IApEngine();
  int? selectedProduct = 0;
  int reward = 0;

  List<ProductId> storeProductIds = <ProductId>[
    ProductId(id: "test_coins_111", isConsumable: true, reward: 10),
    ProductId(id: "test_coins_201", isConsumable: true, reward: 20),
    ProductId(id: "test_coins_30", isConsumable: true, reward: 30),
  ];

  @override
  void initState() {
    super.initState();

    reward = OnePref.getInt(Constants.rewardKey) ?? 0;

    iApEngine.inAppPurchase.purchaseStream.listen(
        (List<PurchaseDetails> purchaseDetailsList) {
      //listen to the purchases
      listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {}, onError: (Object error) {});
    getProducts();
  }

  void getProducts() async {
    // Querying the products from Google Play
    await iApEngine.getIsAvailable().then((isAvailable) async {
      if (isAvailable) {
        await iApEngine.queryProducts(storeProductIds).then((value) => {
              setState(() {
                _isAvailable = isAvailable;
                _products.addAll(value
                    .productDetails); // Setting the returned products here.
                _notFoundIds.addAll(value
                    .notFoundIDs); // Setting the returned notProductIds here.
                _purchasePending = false;
              })
            });
      }
    });
  }

  setSelectedProduct(int? val) {
    setState(() {
      selectedProduct = val;
    });
  }

  Future<void> listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        if (Platform.isAndroid &&
            iApEngine
                .getProductIdsOnly(storeProductIds)
                .contains(purchaseDetails.productID)) {
          final InAppPurchaseAndroidPlatformAddition androidAddition = iApEngine
              .inAppPurchase
              .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
          await androidAddition.consumePurchase(purchaseDetails);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          //completing pending purchase
          await iApEngine.inAppPurchase.completePurchase(purchaseDetails);
        }
        //delivery items/rewards to user if the product purchased/restored
        deliverProduct(purchaseDetails);
      }
    }
  }

  void deliverProduct(PurchaseDetails purchaseDetails) {
    reward = OnePref.getInt(Constants.rewardKey) ?? 0;
    _purchases.add(purchaseDetails);
    for (var product in storeProductIds) {
      if (purchaseDetails.productID == product.id && product.isConsumable) {
        setState(() {
          reward = reward + product.reward!;
          OnePref.setInt(Constants.rewardKey, reward);
          _purchasePending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
            child: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image: AssetImage('lib/images/coins_bg.jpeg'),
              fit: BoxFit.cover,
              opacity: 0.3,
            ),
          ),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OnClickAnimation(
                    onTap: () => {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const MyHomePage()),
                          (Route<dynamic> route) => false)
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          reward.toString(),
                          style: const TextStyle(
                              color: Colors.deepOrangeAccent,
                              fontSize: 60,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Remaining coins",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: OnClickAnimation(
                      onTap: () {
                        var tempReward =
                            OnePref.getInt(Constants.rewardKey) ?? 0;
                        if (tempReward > 0) {
                          tempReward--;
                          OnePref.setInt(Constants.rewardKey, tempReward);
                          setState(() {
                            reward = tempReward;
                          });
                        } else {
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
                            "USE COINS",
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
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Visibility(
              visible: _products.isEmpty,
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
            Expanded(
              flex: 4,
              child: Visibility(
                visible: _products.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListView.builder(
                      itemCount: _products.length,
                      itemBuilder: ((context, index) => Card(
                            color: Colors.grey,
                            child: RadioListTile<int>(
                              value: index,
                              groupValue: selectedProduct,
                              title: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  _products[index].title,
                                  style: TextStyle(
                                      color: Constants.txtColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              subtitle: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(_products[index].description),
                              ),
                              onChanged: (productIndex) {
                                setSelectedProduct(productIndex);
                              },
                              activeColor: Colors.red,
                              secondary: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(_products[index].price),
                                ],
                              ),
                            ),
                          ))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80),
                      ),
                      child: TextButton(
                        onPressed: () {
                          iApEngine.handlePurchase(
                              _products[selectedProduct ?? 0], storeProductIds);
                        },
                        child: Text(
                          _products.isNotEmpty
                              ? "Buy ${_products[selectedProduct ?? 0].price}"
                              : "Loading ...",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        )),
      );
}
