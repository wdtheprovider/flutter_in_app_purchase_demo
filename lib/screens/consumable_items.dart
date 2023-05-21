// ignore_for_file: unused_field
// ignore: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:onepref/onepref.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '../helpers/store_engine.dart';
import '../utils/constants.dart';

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
        await iApEngine.queryProducts().then((value) => {
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
            iApEngine.getProductIdsOnly().contains(purchaseDetails.productID)) {
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
    for (var product in Constants.storeProductIds) {
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
  Widget build(BuildContext context) => Consumer<IApEngine>(
        builder: (context, value, child) => Scaffold(
          appBar: AppBar(
              title: Text(
            "Consumable Items ${_products.length}",
            style: const TextStyle(color: Colors.white),
          )),
          body: SafeArea(
              child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              Expanded(
                child: ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: ((context, index) => Card(
                          color: Colors.green,
                          child: RadioListTile<int>(
                            value: index,
                            groupValue: selectedProduct,
                            title: Text(_products[index].title),
                            subtitle: Text(_products[index].description),
                            onChanged: (productIndex) {
                              setSelectedProduct(productIndex);
                            },
                            activeColor: Colors.red,
                            secondary: Text(_products[index].price),
                          ),
                        ))),
              ),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80),
                      ),
                      child: TextButton(
                        onPressed: () {
                          iApEngine
                              .handlePurchase(_products[selectedProduct ?? 0]);
                        },
                        child: Text(
                          "Buy $reward",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          )),
        ),
      );
}
