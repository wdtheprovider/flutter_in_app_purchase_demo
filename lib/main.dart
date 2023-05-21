import 'package:flutter/material.dart';
import 'package:flutter_in_app_purchase_demo/helpers/manage_consumable_items.dart';
import 'package:flutter_in_app_purchase_demo/screens/consumable_items.dart';
import 'package:flutter_in_app_purchase_demo/screens/store.dart';
import 'package:onepref/onepref.dart';
import 'package:provider/provider.dart';

import 'helpers/manage_purchases.dart';
import 'helpers/store_engine.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ManageConsumables(),
        ),
        ChangeNotifierProvider(
          create: (context) => ManagePurchases(),
        ),
        ChangeNotifierProvider(
          create: (context) => IApEngine(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter In App Purchase Demo',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int selectedRadioTile;
  late int selectedRadio;

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
    selectedRadioTile = 0;
    OnePref.init();
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Flutter In App Purchase Demo"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const ConsumableItems()),
                    ),
                  )
                },
                child: const Text(
                  "Consumable Items",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const ConsumableItems()),
                    ),
                  )
                },
                child: const Text(
                  "Non-Consumable Items",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const Store()),
                    ),
                  )
                },
                child: const Text(
                  "Subscriptions",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ));
  }
}
