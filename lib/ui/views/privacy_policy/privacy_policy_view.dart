import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../theme/globals.dart';

class PrivacyPolicyView extends StatelessWidget {
  static const privacyPolicyUrl = 'https://www.redlino.com/privacy-policy';

  const PrivacyPolicyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RedLino',
          style: blackTextStyle,
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              launch(privacyPolicyUrl);
            },
            child: const Text(
              'OPEN IN BROWSER',
              style: blackTextStyle,
            ),
          ),
        ],
      ),
      body: WebView(
        initialUrl: privacyPolicyUrl,
        navigationDelegate: (_) => NavigationDecision.prevent,
      ),
    );
  }
}
