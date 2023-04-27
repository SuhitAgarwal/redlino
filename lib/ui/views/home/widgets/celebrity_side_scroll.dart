import 'package:flutter/material.dart';

import '../../../../models/user.dart';
import 'celebrity_card.dart';

class CelebritySideScroll extends StatelessWidget {
  final List<AppUser> celebrities;

  const CelebritySideScroll({
    Key? key,
    required this.celebrities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      primary: false,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: celebrities.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (_, i) => CelebrityCard(
        celebrity: celebrities[i],
      ),
    );
  }
}
