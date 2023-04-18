import 'package:flutter/material.dart';

class InAppPurchase extends StatefulWidget {
  const InAppPurchase({super.key});

  @override
  State<InAppPurchase> createState() => _InAppPurchaseState();
}

class _InAppPurchaseState extends State<InAppPurchase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Store"),
      ),
    );
  }
}
