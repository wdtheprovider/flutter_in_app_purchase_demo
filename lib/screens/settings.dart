import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/constants.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  //https://dingi.icu/pages/flutter-in-app-demo_privacy_policy.php

  @override
  Widget build(BuildContext context) => SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Supported Platforms'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.android,
                      color: Colors.green,
                      size: 50,
                    ),
                    Icon(
                      Icons.phone_iphone,
                      color: Colors.blue,
                      size: 50,
                    ),
                    Icon(
                      Icons.laptop_mac,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ],
                ),
                title: const Text(''),
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Settings'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.language),
                title: Text(
                  'About',
                  style: TextStyle(
                      color: Constants.txtColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                value: Text(
                  'Showing examples of all in-app purchases using the latest in_app_purchase package.',
                  style: TextStyle(color: Constants.txtColor, fontSize: 14),
                ),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.link_sharp),
                title: Text(
                  'Privacy Policy',
                  style: TextStyle(
                      color: Constants.txtColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                value: Text(
                  'View Link',
                  style: TextStyle(color: Constants.txtColor, fontSize: 14),
                ),
                onPressed: (c) => {
                  _launchInBrowser(
                    Uri(
                        scheme: 'https',
                        host: 'www.dingi.icu',
                        path: 'pages/flutter-in-app-demo_privacy_policy.php/'),
                  )
                },
              ),
              SettingsTile.navigation(
                title: const Text(
                  'Features Covered',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
                value: Text(
                    style: TextStyle(color: Constants.txtColor, fontSize: 16),
                    '\n- Buy Consumables Items.\n\n- Buy Non-consumable items.\n\n- Buy Remove Ads (Admob).\n\n- Buy Subscriptions.\n\n- Auto Restore Subscriptions.\n\n- Manual Restore Purchase.'),
              ),
            ],
          ),
        ],
      );
}

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}
