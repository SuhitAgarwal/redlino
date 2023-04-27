import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../shared/coins_display.dart';
import '../../shared/profile_pic.dart';
import '../../theme/globals.dart';
import 'profile_viewmodel.dart';
import 'widgets/social_media.dart';

class ProfileView extends StatelessWidget {
  final bool isCelebrity;
  const ProfileView({
    Key? key,
    required this.isCelebrity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      builder: (context, model, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFC5D0EC),
            title: const Text('Profile', style: blackTextStyle),
            actions: [
              IconButton(
                onPressed: model.edit,
                tooltip: 'Edit profile',
                icon: const Icon(Icons.edit),
                splashRadius: 24,
              ),
              IconButton(
                onPressed: model.signOut,
                tooltip: 'Sign out',
                icon: const Icon(Icons.exit_to_app),
                splashRadius: 24,
              ),
            ],
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: DecoratedBox(
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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 36),
              children: [
                Center(
                  child: ProfilePic(
                    url: model.appUser.photoURL,
                    size: 54,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  model.appUser.name,
                  style: textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                if (model.appUser.isCelebrity) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      model.appUser.celebrityInfo!.bio ?? "No bio yet...",
                      style: blackTextStyle,
                    ),
                  ),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: model.goToCelebDetailsView,
                      style: TextButton.styleFrom(
                        backgroundColor: red,
                      ),
                      child: const Text(
                        'Preview explore',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 36),
                Text(
                  'Your wallet',
                  style: textTheme.headline6,
                ),
                Row(
                  // alignment: WrapAlignment.spaceBetween,
                  // crossAxisAlignment: WrapCrossAlignment.center,
                  // runSpacing: 16.0,
                  children: [
                    Expanded(
                      child: CoinsDisplay(
                        coins: model.appUser.coins,
                        limboCoins: model.appUser.celebrityInfo?.limboCoins,
                      ),
                    ),
                    TextButton(
                      // onPressed: model.goToBuyCoinsView,
                      onPressed: model.handleGetCoins,
                      child: const Text(
                        'Get coins',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: red,
                        minimumSize: const Size(100, 36),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),
                if (isCelebrity)
                  Text(
                    'Your socials',
                    style: textTheme.headline6,
                  ),
                if (isCelebrity)
                  const SizedBox(height: 8),
                if (isCelebrity)
                  SocialMediaDisplay(
                    svgPath: 'assets/tiktok-logo.svg',
                    username: model.appUser.socials?.tiktok,
                    onTap: model.appUser.socials?.tiktok != null
                        ? model.launchTikTok
                        : null,
                  ),
                if (isCelebrity)
                  const SizedBox(height: 8),
                if (isCelebrity)
                  SocialMediaDisplay(
                    svgPath: 'assets/instagram-logo.svg',
                    username: model.appUser.socials?.instagram,
                    onTap: model.appUser.socials?.instagram != null
                        ? model.launchInstagram
                        : null,
                  ),
                if (isCelebrity)
                  const SizedBox(height: 8),
                if (isCelebrity)
                  SocialMediaDisplay(
                    svgPath: 'assets/snapchat-logo.svg',
                    username: model.appUser.socials?.snapchat,
                    onTap: model.appUser.socials?.snapchat != null
                        ? model.launchSnapchat
                        : null,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
