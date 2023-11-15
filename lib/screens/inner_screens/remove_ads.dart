import 'package:flutter/material.dart';

class RemoveAds extends StatefulWidget {
  const RemoveAds({super.key});

  @override
  State<RemoveAds> createState() => _RemoveAdsState();
}

class _RemoveAdsState extends State<RemoveAds> {
// variables

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("One time purchase"),
      ),
    );
  }
}
