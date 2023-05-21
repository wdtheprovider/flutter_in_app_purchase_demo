import 'package:flutter/material.dart';

class CustomRadioListTile extends StatelessWidget {
  final int value;
  final int groupValue;
  final Function onChange;
  final String? title;
  final String? subTitle;
  final String? secondTitle;
  final Color? selectedColor;
  final bool? selected;

  const CustomRadioListTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChange,
    this.title,
    this.subTitle,
    this.secondTitle,
    this.selectedColor,
    this.selected,
  });

  @override
  Widget build(BuildContext context) => RadioListTile<int>(
        value: value,
        groupValue: groupValue,
        onChanged: (v) => {},
        secondary: Text(secondTitle ?? ""),
        title: Text(title ?? ""),
        subtitle: Text(subTitle ?? ""),
        selected: selected ?? false,
        selectedTileColor: selectedColor ?? Colors.redAccent,
      );
}
