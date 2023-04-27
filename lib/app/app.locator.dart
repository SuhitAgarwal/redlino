// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/auth_service.dart';
import '../services/coins_service.dart';
import '../services/link_service.dart';
import '../services/notification_service.dart';
import '../services/room_service.dart';
import '../services/user_data_service.dart';

final sl = StackedLocator.instance;

void setupLocator({String? environment, EnvironmentFilter? environmentFilter}) {
// Register environments
  sl.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  sl.registerLazySingleton(() => AuthService());
  sl.registerLazySingleton(() => UserDataService());
  sl.registerLazySingleton(() => NavigationService());
  sl.registerLazySingleton(() => DialogService());
  sl.registerLazySingleton(() => SnackbarService());
  sl.registerLazySingleton(() => CoinsService());
  sl.registerLazySingleton(() => RoomService());
  sl.registerLazySingleton(() => NotificationService());
  sl.registerLazySingleton(() => LinkService());
  sl.registerLazySingleton(() => FirebaseAuthenticationService());
}
