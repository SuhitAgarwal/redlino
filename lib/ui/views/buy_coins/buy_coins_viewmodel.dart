import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../services/user_data_service.dart';
import '../../../utils/purchase_ext.dart';
import '../../shared/snackbar_service.dart';
import '../../theme/globals.dart';

class BuyCoinsViewModel extends BaseViewModel {
  final iap = FlutterInappPurchase.instance;
  final dataSv = sl<UserDataService>();
  final _snackSv = sl<SnackbarService>();
  final _logger = getLogger("BuyCoinsViewModel");

  final coinAmounts = [25, 125, 500, 1250, 2500];

  late List<IAPItem> products;

  int get coins => dataSv.user!.coins;

  void initializeModel() async {
    FlutterInappPurchase.purchaseUpdated.listen((purchase) async {
      if (purchase == null) return;

      if (purchase.isPurchased) {
        await Future.delayed(const Duration(seconds: 5));
        notifyListeners();
      }
    });

    try {
      products = await iap.getProducts(
        coinAmounts.map((e) => "${e}_coins").toList(),
      );
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  void buyCoins(String id) {
    try {
      final details = products.firstWhere((element) => element.productId == id);
      iap.requestPurchase(
        details.productId!,
        obfuscatedAccountId: dataSv.user!.uid,
        obfuscatedProfileIdAndroid: dataSv.user!.uid,
      );
    } on StateError {
      _snackSv.showCustomSnackBar(
        message: 'No products found to buy.',
        variant: SnackbarType.error,
        duration: kSnackbarDuration,
      );
    } on Exception catch (e) {
      _logger.e(e.toString());
      _snackSv.showCustomSnackBar(
        message: e.toString(),
        variant: SnackbarType.error,
        duration: kSnackbarDuration,
      );
    }
  }
}
