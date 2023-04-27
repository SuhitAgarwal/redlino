import 'package:fcm_config/fcm_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../app/app.logger.dart';

Future<void> _messagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  getLogger("NotificationService", printCallingFunctionName: false)
      .i("handing a background message: ${message.messageId}");
}

class NotificationService {
  final _fcm = FCMConfig.instance;
  final _androidNotiDetails = const AndroidNotificationDetails(
    'high_importance_channel',
    "High Importance Notifications",
    'This channel is used for important notifications',
    icon: '@drawable/ic_redlino_noti',
    color: Colors.red,
  );

  Future<void> initialize() async {
    await _fcm.init(
      onBackgroundMessage: _messagingBackgroundHandler,
      androidChannelId: 'high_importance_channel',
      androidChannelName: 'High Importance Notifications',
      androidChannelDescription:
          'This channel is used for important notifications',
      appAndroidIcon: '@drawable/ic_redlino_noti',
    );
    await FCMConfig.messaging.subscribeToTopic('drawings');
  }

  void _showNoti({required String title, required String body}) {
    _fcm.displayNotificationWith(
      title: title,
      body: body,
      android: _androidNotiDetails,
      iOS: const IOSNotificationDetails(),
      web: null,
    );
  }

  void showPendingTransactionNoti(int amount) {
    // TODO save noti locally
    _showNoti(
      title: 'Transaction update',
      body: 'Your transaction of $amount coins is pending.',
    );
  }

  void showCompletedTransactionNoti(int amount) {
    // TODO save noti locally
    _showNoti(
      title: 'Transaction update',
      body: 'Your transaction of $amount coins is completed.',
    );
  }

  void showTransactionErrorNoti() {
    // TODO save noti locally
    _showNoti(
      title: 'Transaction update',
      body: 'Your transaction failed',
    );
  }
}
