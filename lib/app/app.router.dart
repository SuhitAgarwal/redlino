// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../models/user.dart';
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

class Routes {
  static const String initialView = '/';
  static const String signupSigninView = '/signup-signin-view';
  static const String signUpView = '/sign-up-view';
  static const String signInView = '/sign-in-view';
  static const String tutorialView = '/tutorial-view';
  static const String initialWelcomeView = '/initial-welcome-view';
  static const String sentEmailVerificationView =
      '/sent-email-verification-view';
  static const String navbarView = '/navbar-view';
  static const String videoCallView = '/video-call-view';
  static const String buyCoinsView = '/buy-coins-view';
  static const String celebrityDashboardView = '/celebrity-dashboard-view';
  static const String celebrityDetailsView = '/celebrity-details-view';
  static const String privacyPolicyView = '/privacy-policy-view';
  static const String editProfileView = '/edit-profile-view';
  static const all = <String>{
    initialView,
    signupSigninView,
    signUpView,
    signInView,
    tutorialView,
    initialWelcomeView,
    sentEmailVerificationView,
    navbarView,
    videoCallView,
    buyCoinsView,
    celebrityDashboardView,
    celebrityDetailsView,
    privacyPolicyView,
    editProfileView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.initialView, page: InitialView),
    RouteDef(Routes.signupSigninView, page: SignupSigninView),
    RouteDef(Routes.signUpView, page: SignUpView),
    RouteDef(Routes.signInView, page: SignInView),
    RouteDef(Routes.tutorialView, page: TutorialView),
    RouteDef(Routes.initialWelcomeView, page: InitialWelcomeView),
    RouteDef(Routes.sentEmailVerificationView, page: SentEmailVerificationView),
    RouteDef(Routes.navbarView, page: NavbarView),
    RouteDef(Routes.videoCallView, page: VideoCallView),
    RouteDef(Routes.buyCoinsView, page: BuyCoinsView),
    RouteDef(Routes.celebrityDashboardView, page: CelebrityDashboardView),
    RouteDef(Routes.celebrityDetailsView, page: CelebrityDetailsView),
    RouteDef(Routes.privacyPolicyView, page: PrivacyPolicyView),
    RouteDef(Routes.editProfileView, page: EditProfileView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    InitialView: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => const InitialView(),
        settings: data,
      );
    },
    SignupSigninView: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => const SignupSigninView(),
        settings: data,
      );
    },
    SignUpView: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => const SignUpView(),
        settings: data,
      );
    },
    SignInView: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => const SignInView(),
        settings: data,
      );
    },
    TutorialView: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => const TutorialView(),
        settings: data,
      );
    },
    InitialWelcomeView: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => const InitialWelcomeView(),
        settings: data,
      );
    },
    SentEmailVerificationView: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => const SentEmailVerificationView(),
        settings: data,
      );
    },
    NavbarView: (data) {
      var args = data.getArgs<NavbarViewArguments>(nullOk: false);
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => NavbarView(
          key: args.key,
          isCelebrity: args.isCelebrity,
        ),
        settings: data,
      );
    },
    VideoCallView: (data) {
      var args = data.getArgs<VideoCallViewArguments>(nullOk: false);
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => VideoCallView(
          key: args.key,
          celebrity: args.celebrity,
          channelId: args.channelId,
          token: args.token,
        ),
        settings: data,
      );
    },
    BuyCoinsView: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => const BuyCoinsView(),
        settings: data,
      );
    },
    CelebrityDashboardView: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => const CelebrityDashboardView(),
        settings: data,
      );
    },
    CelebrityDetailsView: (data) {
      var args = data.getArgs<CelebrityDetailsViewArguments>(nullOk: false);
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => CelebrityDetailsView(
          key: args.key,
          celebrity: args.celebrity,
          showJoinRoomBtn: args.showJoinRoomBtn,
        ),
        settings: data,
      );
    },
    PrivacyPolicyView: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => const PrivacyPolicyView(),
        settings: data,
      );
    },
    EditProfileView: (data) {
      // var args = data.getArgs<EditProfileViewArguments>(nullOk: false);
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => const EditProfileView(),
          // key: args.key,
          // isCelebrity: args.isCelebrity,),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// NavbarView arguments holder class
class NavbarViewArguments {
  final Key? key;
  final bool isCelebrity;
  NavbarViewArguments({this.key, required this.isCelebrity});
}

/// VideoCallView arguments holder class
class VideoCallViewArguments {
  final Key? key;
  final AppUser celebrity;
  final String channelId;
  final String token;
  VideoCallViewArguments(
      {this.key,
      required this.celebrity,
      required this.channelId,
      required this.token});
}

/// CelebrityDetailsView arguments holder class
class CelebrityDetailsViewArguments {
  final Key? key;
  final AppUser celebrity;
  final bool showJoinRoomBtn;
  CelebrityDetailsViewArguments(
      {this.key, required this.celebrity, this.showJoinRoomBtn = true});
}

// /// EditProfileView arguments holder class
// class EditProfileViewArguments {
//   final Key? key;
//   final bool isCelebrity;
//   EditProfileViewArguments({this.key, required this.isCelebrity});
// }
