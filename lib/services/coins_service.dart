import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:stacked_services/stacked_services.dart';

import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../ui/shared/dialog_service.dart';
import '../ui/shared/snackbar_service.dart';
import '../ui/theme/globals.dart';
import '../utils/collections.dart';
import '../utils/purchase_ext.dart';
import 'notification_service.dart';
import 'user_data_service.dart';

class CoinsService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _functions = FirebaseFunctions.instance;
  final _iap = FlutterInappPurchase.instance;
  final _dataSv = sl<UserDataService>();
  final _dialogSv = sl<DialogService>();
  final _snackSv = sl<SnackbarService>();
  final _notiSv = sl<NotificationService>();
  final _navSv = sl<NavigationService>();
  final _logger = getLogger("CoinsService");

  Future<void> initialize() async {
    try {
      await _iap.consumeAllItems;
    } on Exception catch (e) {
      _logger.e(e);
    }

    FlutterInappPurchase.purchaseError.listen((purchaseError) {
      if (purchaseError == null) return;
      if (purchaseError.code != "E_USER_CANCELLED") {
        _showTransactionFailedDialog(null);
        _notiSv.showTransactionErrorNoti();
      }
      _logger.e(purchaseError.message, purchaseError.code);
    });

    FlutterInappPurchase.purchaseUpdated.listen((purchase) {
      if (purchase == null) return;
      if (purchase.isPurchased) {
        verifyPurchase(purchase);
      }
      if (purchase.isPending) {
        _notiSv.showPendingTransactionNoti(
          int.parse(purchase.productId!.split("_")[0]),
        );
      }
    });
  }

  void _showTransactionFailedDialog(int? amount) {
    String desc;
    if (amount == null) {
      desc = "Your recent transaction could not be verified.";
    } else {
      desc = "Your transaction of $amount coins could not be verified.";
    }
    _dialogSv.showCustomDialog(
      variant: kBasicDialog,
      title: "Transaction error",
      description: desc,
      data: {
        "icon": Icons.error_outline,
        "color": Colors.red,
      },
    );
  }

  void _showTransactionProcessedDialog(int amount) {
    _dialogSv.showCustomDialog(
      variant: kBasicDialog,
      title: "Transaction processed",
      description: "Your transaction of $amount coins has been processed.",
      data: {
        "icon": Icons.check_circle_outline,
        "color": Colors.green,
      },
    );
  }

  Future<void> startCoinTransferFlow({
    required String celebUid,
    required String celebName,
  }) async {
    final r = await _dialogSv.showCustomDialog(
      variant: kSelectCoinsDialog,
    );
    if (r == null) return;
    if (!r.confirmed) return;
    final coins = r.data;
    if (coins == null) return;
    final hasEnough = _dataSv.user!.coins - coins! >= 0;
    if (!hasEnough) {
      _snackSv.showCustomSnackBar(
        message: 'Insufficient balance to send coins to $celebName!',
        variant: SnackbarType.error,
        duration: kSnackbarDuration,
      );
      return;
    }
    try {
      _dialogSv.showCustomDialog(variant: kLoadingDialog);
      await transferCoins(celebUid, coins);
      _navSv.back();
      _snackSv.showCustomSnackBar(
        message: 'Sent $coins coins to $celebName!',
        variant: SnackbarType.success,
        duration: kSnackbarDuration,
      );
      Vibrate.vibrate();
    } on Exception {
      _snackSv.showCustomSnackBar(
        message: 'There was an error sending coins to $celebName!',
        variant: SnackbarType.error,
        duration: kSnackbarDuration,
      );
    }
  }

  Future<void> verifyPurchase(PurchasedItem purchasedItem) async {
    final verified = await _functions.httpsCallable('validatePurchase').call({
      "platform": Platform.isAndroid ? "android" : "ios",
      "productId": purchasedItem.productId,
      "verificationData": Platform.isAndroid
          ? purchasedItem.purchaseToken
          : purchasedItem.transactionReceipt,
    });
    final data = verified.data ?? {};
    final amount = int.parse(purchasedItem.productId!.split("_")[0]);
    if (data['status'] != 200) {
      _showTransactionFailedDialog(amount);
      return;
    }
    await _iap.finishTransaction(purchasedItem, isConsumable: true);
    await addCoins(amount);
    _showTransactionProcessedDialog(amount);
    _notiSv.showCompletedTransactionNoti(amount);
  }

  Future<void> addCoins(int amount) async {
    final coins = _dataSv.user!.coins + amount;
    final user = _dataSv.user!.copyWith(coins: coins);
    await _dataSv.updateUserData(user);
  }

  Future<void> removeDrawing(String celebId) async {
    final userDrawing = _db.getDrawingsCol(celebId).doc(_auth.currentUser!.uid);
    return userDrawing.delete();
  }

  Future<void> transferCoins(String celebUid, int coins) async {
    final call = _functions.httpsCallable('enterDrawing');
    await call({
      "uid": _dataSv.user!.uid,
      "amount": coins,
      "celebUid": celebUid,
    });
  }
}
