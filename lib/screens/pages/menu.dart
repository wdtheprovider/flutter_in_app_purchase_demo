import 'package:flutter/material.dart';
import 'package:flutter_in_app_purchase_demo/screens/inner_screens/consumable_items.dart';
import 'package:flutter_in_app_purchase_demo/screens/inner_screens/non_consumable_items.dart';
import 'package:flutter_in_app_purchase_demo/screens/inner_screens/subscription.dart';
import 'package:onepref/onepref.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25.0,
          vertical: 25.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                btn(
                    "Buy Subscriptions",
                    () => {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Subscriptions()))
                        }),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                  child: Text(
                    "Subscriptions products, where users will choose subscriptions based on the duration.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                btn(
                    "Buy Consumable Items",
                    () => {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ConsumableItems()))
                        }),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                  child: Text(
                    "These items are products that a user can purchase unlimited times. so my example is based on coins.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                btn(
                    "Buy Non-Consumable Items",
                    () => {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const NonConsumable()))
                        }),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                  child: Text(
                    "These items are products that a user can ONLY purchase ONCE and Own it life time. so my example will be remove ads.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget btn(String btnTile, Function ontap) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: OnClickAnimation(
              onTap: ontap,
              child: Card(
                color: Colors.amber,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    btnTile,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
            ),
          ),
        ],
      );
}
