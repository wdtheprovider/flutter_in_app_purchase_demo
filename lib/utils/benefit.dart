import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Benefit extends StatelessWidget {
  String title;
  IconData icon;
  double? spaceBetween;
  double? iconSize;
  Color? iconColor;
  Color? iconBackgroundColor;
  TextStyle? titleStyle;

  Benefit({
    super.key,
    required this.title,
    required this.icon,
    this.iconSize,
    this.iconColor,
    this.iconBackgroundColor,
    this.spaceBetween,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: iconBackgroundColor ?? Colors.orange,
              ),
              child: Icon(
                Icons.check,
                color: iconColor ?? Colors.white,
                size: iconSize ?? 20,
              ),
            ),
            SizedBox(
              width: spaceBetween ?? 20,
            ),
            Text(
              title,
              style: titleStyle,
            ),
          ],
        ),
      );
}
