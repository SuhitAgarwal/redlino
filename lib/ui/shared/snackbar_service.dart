import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../theme/globals.dart';

enum SnackbarType { error, success, info }

void setupSnackbarService() {
  final snackService = sl<SnackbarService>();

  final errorConfig = SnackbarConfig(
    icon: const Icon(Icons.error_outline, color: red),
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    borderRadius: 8,
    instantInit: true,
  );

  final successConfig = SnackbarConfig(
    icon: const Icon(Icons.check_circle_outline, color: Colors.green),
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    borderRadius: 8,
    instantInit: true,
  );

  final infoConfig = SnackbarConfig(
    icon: const Icon(Icons.info_outline, color: Colors.white),
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    borderRadius: 8,
    instantInit: true,
  );

  snackService.registerCustomSnackbarConfig(
    variant: SnackbarType.error,
    config: errorConfig,
  );
  snackService.registerCustomSnackbarConfig(
    variant: SnackbarType.success,
    config: successConfig,
  );
  snackService.registerCustomSnackbarConfig(
    variant: SnackbarType.info,
    config: infoConfig,
  );
}
