import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:numeral/numeral.dart';

class CoinsDisplay extends StatelessWidget {
  final int coins;
  final int? limboCoins;

  const CoinsDisplay({
    Key? key,
    required this.coins,
    this.limboCoins,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buildCoinsAmount() {
      if (limboCoins != null) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoSizeText(
              NumberFormat("###,###").format(coins),
              style: GoogleFonts.rubik(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              maxLines: 1,
            ),
            Text(
              '(+${limboCoins!.numeral(fractionDigits: 1)} pending)',
              style: GoogleFonts.rubik(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        );
      }
      return AutoSizeText(
        NumberFormat("###,###").format(coins),
        style: GoogleFonts.rubik(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        maxLines: 1,
      );
    }

    return Row(
      children: [
        Image.asset(
          'assets/coin.png',
          width: 72,
          height: 72,
        ),
        const SizedBox(width: 8),
        Expanded(child: buildCoinsAmount()),
        const SizedBox(width: 8),
      ],
    );
  }
}
