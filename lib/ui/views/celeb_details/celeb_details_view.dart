import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numeral/numeral.dart';
import 'package:stacked/stacked.dart';

import '../../../models/user.dart';
import '../../../utils/string_utils.dart';
import '../../shared/back_button.dart';
import '../../shared/countdown.dart';
import '../../shared/icon_button.dart';
import '../../shared/profile_pic.dart';
import '../../theme/globals.dart';
import 'celeb_details_viewmodel.dart';

class CelebrityDetailsView extends StatelessWidget {
  final AppUser celebrity;
  final bool showJoinRoomBtn;

  const CelebrityDetailsView({
    Key? key,
    required this.celebrity,
    this.showJoinRoomBtn = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return ViewModelBuilder<CelebrityDetailsViewModel>.reactive(
      viewModelBuilder: () => CelebrityDetailsViewModel(celebrity),
      fireOnModelReadyOnce: true,
      onModelReady: (model) => model.initializeModel(),
      builder: (context, model, _) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: height * 0.4,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                      child: ProfilePicSquare(
                        url: celebrity.photoURL,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: height * 0.375,
                      ),
                    ),
                    if (showJoinRoomBtn)
                      Positioned.fill(
                        bottom: 0,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            onPressed: model.joinRoom,
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xFFF48282),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              shape: maxBorderRadiusShape,
                            ),
                            child: Text(
                              'JOIN LOBBY',
                              style: GoogleFonts.mPlusRounded1c(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ),
                    const Positioned(
                      top: 36,
                      left: 20,
                      child: CustomBackButton(backgroundColor: Colors.white),
                    ),
                    if (!model.isCelebrity)
                      Positioned(
                        top: 36,
                        right: 20,
                        child: CustomIconButton(
                          onTap: model.isBusy ? null : model.toggleFavorite,
                          icon: model.isFavorited
                              ? Icons.favorite
                              : Icons.favorite_border,
                          backgroundColor: Colors.black38,
                          iconColor: Colors.red.shade300,
                        ),
                      ),
                  ],
                ),
              ),
              ListView(
                primary: false,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              model.info.isActive ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        celebrity.name.overflow,
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(height: 1.5),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (celebrity.socials != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (celebrity.socials!.instagram != null)
                          IconButton(
                            onPressed: model.launchInstagram,
                            splashRadius: 24,
                            tooltip: 'Instagram',
                            icon: SvgPicture.asset(
                              'assets/instagram-logo.svg',
                              width: 32,
                            ),
                          ),
                        const SizedBox(width: 16),
                        if (celebrity.socials!.snapchat != null)
                          IconButton(
                            onPressed: model.launchSnapchat,
                            splashRadius: 24,
                            tooltip: 'Snapchat',
                            icon: SvgPicture.asset(
                              'assets/snapchat-logo.svg',
                              width: 32,
                            ),
                          ),
                        const SizedBox(width: 16),
                        if (celebrity.socials!.tiktok != null)
                          IconButton(
                            onPressed: model.launchTikTok,
                            splashRadius: 24,
                            tooltip: 'TikTok',
                            icon: SvgPicture.asset(
                              'assets/tiktok-logo.svg',
                              width: 32,
                            ),
                          ),
                      ],
                    ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    model.info.bio ?? "No bio here!",
                    maxLines: 2,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    runSpacing: 16.0,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(Icons.favorite, color: Colors.red.shade300),
                          const SizedBox(width: 8),
                          Text(
                            '${celebrity.celebrityInfo!.favorites.numeral()} Favorites',
                            style: const TextStyle(
                              color: gray,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      // Wrap(
                      //   crossAxisAlignment: WrapCrossAlignment.center,
                      //   children: [
                      //     Icon(Icons.devices, color: Colors.blue.shade300),
                      //     const SizedBox(width: 8),
                      //     const Text(
                      //       '100,000 Online now',
                      //       style: TextStyle(
                      //         color: gray,
                      //         fontWeight: FontWeight.w500,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        'Meet and greet starts:',
                        style: blackTextStyle,
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.red.shade300,
                          borderRadius: borderRadiusSm,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: model.info.meetAndGreetStart != null
                              ? CountdownDisplay(
                                  to: model.info.meetAndGreetStart!,
                                  style: textTheme.headline6!,
                                )
                              : Text(
                                  'N/A',
                                  style: textTheme.headline6!,
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        'Drawing coin count:',
                        style: blackTextStyle,
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.green.shade300,
                          borderRadius: borderRadiusSm,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            model.info.limboCoins.numeral(
                              fractionDigits: 2,
                            ),
                            style: textTheme.headline6,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        'Calls count:',
                        style: blackTextStyle,
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: borderRadiusSm,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${model.info.calls}",
                            style: textTheme.headline6,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (celebrity.uid != model.user.uid) ...[
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: model.handleSendCoins,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red.shade300,
                      ),
                      child: const Text('Send star coins'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
