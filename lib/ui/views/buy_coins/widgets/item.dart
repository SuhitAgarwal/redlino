import 'package:flutter/material.dart';

import '../../../theme/globals.dart';

class CoinPurchaseItem extends StatelessWidget {
  final int coinAmount;
  final double price;
  final VoidCallback onTap;

  const CoinPurchaseItem({
    Key? key,
    required this.coinAmount,
    required this.price,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const SizedBox(width: 16),
            Image.asset('assets/coin.png', height: 48, width: 48),
            const SizedBox(width: 8),
            Text(
              '$coinAmount coins',
              style: textTheme.headline6,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFFEB5757),
              shape: maxBorderRadiusShape,
              minimumSize: const Size(100, 36),
            ),
            child: Text('\$$price'),
          ),
        ),
      ],
    );
  }
}
