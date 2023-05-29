import 'package:flutter/material.dart';
import 'package:flutter_in_app_purchase_demo/screens/consumable_items.dart';
import 'package:flutter_in_app_purchase_demo/screens/subscription.dart';

import '../utils/on_click_animation.dart';

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
            btn("Buy Remove Ads", () => {}),
            btn(
                "Buy Subscriptions",
                () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Subscriptions()))
                    }),
            btn(
                "Buy Consumable Items",
                () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ConsumableItems()))
                    }),
            btn("Buy Non-Consumable Items", () => {}),
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
