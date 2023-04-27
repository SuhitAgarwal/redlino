import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import '../../shared/back_button.dart';
import '../../theme/globals.dart';
import 'buy_coins_viewmodel.dart';
import 'widgets/item.dart';

class BuyCoinsView extends StatelessWidget {
  const BuyCoinsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buildError(dynamic error) {
      return DecoratedBox(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 36),
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: CustomBackButton(backgroundColor: Colors.white),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'There was an error fetching products from the store.',
                    style: textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: ViewModelBuilder<BuyCoinsViewModel>.reactive(
        viewModelBuilder: () => BuyCoinsViewModel(),
        fireOnModelReadyOnce: true,
        onModelReady: (model) => model.initializeModel(),
        builder: (context, model, _) {
          if (model.hasError) {
            return buildError(model.modelError);
          }

          return DecoratedBox(
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
              children: [
                const SizedBox(height: 36),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: CustomBackButton(backgroundColor: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'My Wallet',
                    style: textTheme.headline4,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        'assets/coin.png',
                        height: 96,
                      ),
                      const SizedBox(height: 16),
                      AutoSizeText(
                        NumberFormat("###,###").format(model.coins),
                        style: textTheme.headline3!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxFontSize: 36,
                        minFontSize: 12,
                        maxLines: 1,
                      ),
                      Text(
                        'Total Star Coins',
                        style: textTheme.headline6!.copyWith(
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Divider(color: Colors.white),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Buy Coins',
                    style: textTheme.headline5,
                  ),
                ),
                const SizedBox(height: 32),
                CoinPurchaseItem(
                  coinAmount: 25,
                  price: 1.99,
                  onTap: () => model.buyCoins('25_coins'),
                ),
                const SizedBox(height: 4),
                CoinPurchaseItem(
                  coinAmount: 125,
                  price: 6.99,
                  onTap: () => model.buyCoins('125_coins'),
                ),
                const SizedBox(height: 4),
                CoinPurchaseItem(
                  coinAmount: 500,
                  price: 25.99,
                  onTap: () => model.buyCoins('500_coins'),
                ),
                const SizedBox(height: 4),
                CoinPurchaseItem(
                  coinAmount: 1250,
                  price: 64.99,
                  onTap: () => model.buyCoins('1250_coins'),
                ),
                const SizedBox(height: 4),
                CoinPurchaseItem(
                  coinAmount: 2500,
                  price: 129.99,
                  onTap: () => model.buyCoins('2500_coins'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
