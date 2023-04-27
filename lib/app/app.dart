import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/auth_service.dart';
import '../services/coins_service.dart';
import '../services/link_service.dart';
import '../services/notification_service.dart';
import '../services/room_service.dart';
import '../services/user_data_service.dart';
import '../ui/views/buy_coins/buy_coins_view.dart';
import '../ui/views/celeb_dashboard/celeb_dashboard_view.dart';
import '../ui/views/celeb_details/celeb_details_view.dart';
import '../ui/views/edit_profile/edit_profile_view.dart';
import '../ui/views/initial/initial_view.dart';
import '../ui/views/initial_welcome/initial_welcome_view.dart';
import '../ui/views/navbar/navbar_view.dart';
import '../ui/views/privacy_policy/privacy_policy_view.dart';
import '../ui/views/sent_email_verification/sent_email_verification_view.dart';
import '../ui/views/signin/signin_view.dart';
import '../ui/views/signup/signup_view.dart';
import '../ui/views/signup_signin/signup_signin_view.dart';
import '../ui/views/tutorial/tutorial_view.dart';
import '../ui/views/video_call/video_call_view.dart';

@StackedApp(
  routes: [
    AdaptiveRoute(page: InitialView, initial: true),
    AdaptiveRoute(page: SignupSigninView),
    AdaptiveRoute(page: SignUpView),
    AdaptiveRoute(page: SignInView),
    AdaptiveRoute(page: TutorialView),
    AdaptiveRoute(page: InitialWelcomeView),
    AdaptiveRoute(page: SentEmailVerificationView),
    AdaptiveRoute(page: NavbarView),
    AdaptiveRoute(page: VideoCallView),
    AdaptiveRoute(page: BuyCoinsView),
    AdaptiveRoute(page: CelebrityDashboardView),
    AdaptiveRoute(page: CelebrityDetailsView),
    AdaptiveRoute(page: PrivacyPolicyView),
    AdaptiveRoute(page: EditProfileView),
  ],
  locatorName: 'sl',
  dependencies: [
    LazySingleton(classType: AuthService),
    LazySingleton(classType: UserDataService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: CoinsService),
    LazySingleton(classType: RoomService),
    LazySingleton(classType: NotificationService),
    LazySingleton(classType: LinkService),
    LazySingleton(classType: FirebaseAuthenticationService),
  ],
  logger: StackedLogger(),
)
class App {}
