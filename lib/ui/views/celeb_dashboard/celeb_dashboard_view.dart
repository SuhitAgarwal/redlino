import 'package:fcm_config/fcm_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import '../../shared/coins_display.dart';
import '../../shared/countdown.dart';
import '../../shared/profile_pic.dart';
import '../../theme/globals.dart';
import 'celeb_dashboard_viewmodel.dart';

class CelebrityDashboardView extends StatelessWidget {
  const CelebrityDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: ViewModelBuilder<CelebrityDashboardViewModel>.reactive(
        viewModelBuilder: () => CelebrityDashboardViewModel(),
        builder: (context, model, _) {
          if (model.isBusy) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          return FCMNotificationListener(
            onNotification: (msg, _) {
              if (msg.from == "/topics/drawings") {
                return;
              }
              switch (msg.data['code']) {
                case "draw-user-not-found":
                  model.showNoDrawUserFoundDialog();
                  break;
                case "draw-user-found":
                  model.joinPrivateRoom();
                  break;
              }
            },
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFC5D0EC),
                    Color(0xFFFFFFFF),
                  ],
                  stops: [0.75, 1.00],
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                children: [
                  const SizedBox(height: 72),
                  Align(
                    alignment: Alignment.topLeft,
                    child: ProfilePic(
                      url: model.user.photoURL,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome back,\n${model.firstName}',
                    overflow: TextOverflow.clip,
                    style: GoogleFonts.rubik(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: CoinsDisplay(
                          coins: model.user.coins,
                          limboCoins: model.user.celebrityInfo?.limboCoins,
                        ),
                      ),
                      TextButton(
                        onPressed: model.handleWithdraw,
                        style: TextButton.styleFrom(backgroundColor: red),
                        child: const Text(
                          'Cash out',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: model.isActive,
                    onChanged: model.updateActiveStatus,
                    title: Text(
                      'Active Status',
                      style: textTheme.headline6,
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Meet and greet start',
                      style: textTheme.headline6,
                    ),
                    onTap: model.goToEditProfile,
                    leading: const Icon(
                      Icons.schedule_outlined,
                      color: Colors.black,
                    ),
                    subtitle: model.info.meetAndGreetStart != null
                        ? CountdownDisplay(
                            to: model.info.meetAndGreetStart!,
                            color: Colors.black,
                          )
                        : const Text('No date', style: blackTextStyle),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: model.goToEditProfile,
                    title: Text(
                      'Call count',
                      style: textTheme.headline6,
                    ),
                    leading: const Icon(
                      Icons.video_call_outlined,
                      color: Colors.black,
                    ),
                    subtitle: Text(
                      "${model.info.calls}",
                      style: blackTextStyle,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: model.handlePrivateRoomPress,
                    style: TextButton.styleFrom(
                      backgroundColor: red,
                      fixedSize: const Size.fromHeight(72),
                    ),
                    child: const Text(
                      'Join Private Room',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: model.joinRandomRoom,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      fixedSize: const Size.fromHeight(72),
                    ),
                    child: const Text(
                      'Join Random Lobby',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
