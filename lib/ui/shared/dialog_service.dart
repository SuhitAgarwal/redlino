import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../theme/globals.dart';
import 'profile_pic.dart';

const kSelectCoinsDialog = 'selectCoins';
const kNoWithdrawDialog = 'noWithdraw';
const kNoCoinPurchaseDialog = 'noCoinPurchase';
const kMeetCelebDialog = 'meetCeleb';
const kConfirmationDialog = 'confirmationDialog';
const kBasicDialog = 'basicDialog';
const kLoadingDialog = 'loadingDialog';

void setupDialogService() {
  final ds = sl<DialogService>();

  ds.registerCustomDialogBuilders({
    kSelectCoinsDialog: (ctx, req, res) => _SelectCoinsDialog(res: res),
    kNoWithdrawDialog: (_, __, res) => _NoWithdrawDialog(res: res),
    kNoCoinPurchaseDialog: (_, __, res) => _NoCoinPurchaseDialog(res: res),
    kMeetCelebDialog: (_, req, res) => _MeetCelebDialog(req: req, res: res),
    kConfirmationDialog: (_, req, res) =>
        _CustomConfirmationDialog(req: req, res: res),
    kBasicDialog: (_, req, res) => _CustomBasicDialog(req: req, res: res),
    kLoadingDialog: (_, req, res) => _LoadingDialog(req: req, res: res),
  });
}

class _SelectCoinsDialog extends StatelessWidget {
  final void Function(DialogResponse) res;

  const _SelectCoinsDialog({Key? key, required this.res}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sel = Image.asset('assets/coin.png', width: 32, height: 32);
    final unsel = Image.asset(
      'assets/coin-grayscale.png',
      width: 32,
      height: 32,
    );
    int selectedCoins = 50;
    bool selectedCustom = false;

    final focusNode = FocusNode();
    final controller = TextEditingController();

    return Dialog(
      shape: borderRadiusSmShape,
      child: StatefulBuilder(
        builder: (context, setState) {
          Widget buildTile(int amount) {
            return InkWell(
              onTap: () => setState(() {
                selectedCoins = amount;
                selectedCustom = false;
                focusNode.unfocus();
              }),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    selectedCoins == amount && !selectedCustom ? sel : unsel,
                    const SizedBox(width: 16),
                    Text('$amount', style: blackTextStyle),
                  ],
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              Text(
                'Send coins',
                style: textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Show your support to a creator by sending them coins.',
                style: TextStyle(color: gray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              buildTile(50),
              buildTile(125),
              buildTile(500),
              buildTile(1000),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    selectedCustom ? sel : unsel,
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        onTap: () => setState(() {
                          selectedCustom = true;
                          selectedCoins = 0;
                        }),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                        controller: controller,
                        onChanged: (val) {
                          selectedCoins = int.parse(val);
                          setState(() {});
                        },
                        focusNode: focusNode,
                        validator: (val) {
                          if (!selectedCustom) return null;
                          if (val == null) {
                            return "Value is required";
                          }
                          final i = int.tryParse(val);
                          if (i == null) {
                            return "Must be valid integer";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: blackTextStyle,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => res(DialogResponse(confirmed: false)),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.rubik(
                        color: darkGray,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFEFF1F7),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: selectedCoins > 0
                        ? () => res(
                              DialogResponse(
                                confirmed: true,
                                data: selectedCoins,
                              ),
                            )
                        : null,
                    style: TextButton.styleFrom(
                      backgroundColor: red,
                    ),
                    child: Text(
                      'Send',
                      style: GoogleFonts.rubik(
                        color: const Color(0xFFffe8e8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NoWithdrawDialog extends StatelessWidget {
  final void Function(DialogResponse) res;

  const _NoWithdrawDialog({Key? key, required this.res}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: borderRadiusSmShape,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/withdraw-failure.svg'),
            const SizedBox(height: 16),
            Text(
              'Withdraw disabled',
              style: textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unfortunately, withdrawing is currently disabled in the app.',
              style: TextStyle(color: gray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () => res(DialogResponse(confirmed: true)),
                style: TextButton.styleFrom(backgroundColor: red),
                child: const Text(
                  'Okay',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoCoinPurchaseDialog extends StatelessWidget {
  final void Function(DialogResponse) res;

  const _NoCoinPurchaseDialog({Key? key, required this.res}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: borderRadiusSmShape,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/withdraw-failure.svg'),
            const SizedBox(height: 16),
            Text(
              'Purchase disabled',
              style: textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unfortunately, purchasing coins is currently disabled in the app.',
              style: TextStyle(color: gray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () => res(DialogResponse(confirmed: true)),
                style: TextButton.styleFrom(backgroundColor: red),
                child: const Text(
                  'Okay',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeetCelebDialog extends StatelessWidget {
  final DialogRequest req;
  final void Function(DialogResponse) res;

  const _MeetCelebDialog({
    Key? key,
    required this.req,
    required this.res,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int s = 10;

    return Dialog(
      shape: borderRadiusSmShape,
      child: StatefulBuilder(
        builder: (context, setState) {
          Timer(const Duration(seconds: 1), () {
            if (s == 0) {
              res(DialogResponse(confirmed: false));
              return;
            }
            s--;
            setState(() {});
          });
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfilePic(
                  url: req.imageUrl,
                  size: 128,
                ),
                const SizedBox(height: 16),
                Text(
                  'Meet celebrity',
                  style: textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  "Now's your chance to meet your celebrity! Have fun! "
                  "You have $s seconds to approve this.",
                  style: const TextStyle(color: gray),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => res(DialogResponse(confirmed: false)),
                      child: Text(
                        'Redraw',
                        style: GoogleFonts.rubik(
                          color: darkGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFEFF1F7),
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () => res(DialogResponse(confirmed: true)),
                      style: TextButton.styleFrom(backgroundColor: red),
                      child: const Text(
                        'Join',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CustomConfirmationDialog extends StatelessWidget {
  final DialogRequest req;
  final void Function(DialogResponse) res;

  const _CustomConfirmationDialog({
    Key? key,
    required this.req,
    required this.res,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget displayImage() {
      if (req.imageUrl!.startsWith(RegExp("https?://"))) {
        return Image.network(req.imageUrl!, width: 128);
      } else {
        return Image.asset(req.imageUrl!, width: 128);
      }
    }

    return Dialog(
      shape: borderRadiusSmShape,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (req.imageUrl != null) displayImage(),
            const SizedBox(height: 16),
            Text(
              req.title!,
              style: textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              req.description!,
              style: const TextStyle(color: gray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                TextButton(
                  onPressed: () => res(DialogResponse(confirmed: false)),
                  child: Text(
                    req.secondaryButtonTitle!,
                    style: GoogleFonts.rubik(
                      color: darkGray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFEFF1F7),
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () => res(DialogResponse(confirmed: true)),
                  style: TextButton.styleFrom(backgroundColor: red),
                  child: Text(
                    req.mainButtonTitle!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomBasicDialog extends StatelessWidget {
  final DialogRequest req;
  final void Function(DialogResponse) res;

  const _CustomBasicDialog({
    Key? key,
    required this.req,
    required this.res,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget displayImage() {
      if (req.imageUrl!.startsWith(RegExp("https?://"))) {
        return Image.network(req.imageUrl!, width: 128);
      } else {
        return Image.asset(req.imageUrl!, width: 128);
      }
    }

    Widget displayIcon() {
      return Icon(
        req.data['icon'],
        color: req.data['color'] ?? Colors.black,
        size: 64,
      );
    }

    return Dialog(
      shape: borderRadiusSmShape,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (req.imageUrl != null) displayImage(),
            if (req.data.containsKey('icon')) displayIcon(),
            const SizedBox(height: 16),
            Text(
              req.title!,
              style: textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              req.description!,
              style: const TextStyle(color: gray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () => res(DialogResponse(confirmed: true)),
                style: TextButton.styleFrom(backgroundColor: red),
                child: const Text(
                  'Okay',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingDialog extends StatelessWidget {
  final DialogRequest req;
  final void Function(DialogResponse) res;

  const _LoadingDialog({
    Key? key,
    required this.req,
    required this.res,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Map<String, dynamic>.from(req.data ?? {});

    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        shape: borderRadiusSmShape,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(child: CircularProgressIndicator.adaptive()),
              const SizedBox(height: 16),
              Text(
                'Loading...',
                style: textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              if (data['long'] == true) ...[
                const SizedBox(height: 16),
                const Text(
                  "This may take awhile. Please do not leave the app.",
                  style: TextStyle(color: gray),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
