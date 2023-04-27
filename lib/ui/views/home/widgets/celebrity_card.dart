import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../models/user.dart';
import '../../../theme/globals.dart';
import '../../celeb_details/celeb_details_view.dart';

class CelebrityCard extends StatelessWidget {
  final AppUser celebrity;

  const CelebrityCard({
    Key? key,
    required this.celebrity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      openBuilder: (_, __) {
        return CelebrityDetailsView(
          celebrity: celebrity,
        );
      },
      closedShape: borderRadiusSmShape,
      closedColor: Colors.transparent,
      transitionType: ContainerTransitionType.fadeThrough,
      closedElevation: 0,
      closedBuilder: (context, open) {
        return InkWell(
          onTap: open,
          child: SizedBox(
            height: 240,
            width: 390,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SizedBox(
                      height: 240,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: celebrity.photoURL != null
                                ? CachedNetworkImageProvider(celebrity.photoURL!)
                                : const AssetImage('assets/profile-default.jpg')
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: borderRadiusSm,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          celebrity.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
