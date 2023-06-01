import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void openSnackBar({context, title, btnName, message, color, bgColor}) {
  Platform.isAndroid
      ? ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: bgColor,
            content: Text(
              message,
            ),
          ),
        )
      : showCupertinoDialog<bool>(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text(
              title,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      message,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  btnName,
                ),
              )
            ],
          ),
        );
}
