import 'dart:io';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

extension PurchaseItemExt on PurchasedItem {
  bool get isPurchased {
    if (Platform.isIOS) {
      return transactionStateIOS == TransactionState.purchased;
    }
    if (Platform.isAndroid) {
      return purchaseStateAndroid == PurchaseState.purchased;
    }
    return false;
  }

  bool get isPending {
    if (Platform.isIOS) {
      return transactionStateIOS == TransactionState.purchasing;
    }
    if (Platform.isAndroid) {
      return purchaseStateAndroid == PurchaseState.pending;
    }
    return false;
  }
}
