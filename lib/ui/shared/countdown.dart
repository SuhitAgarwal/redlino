import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class CountdownDisplay extends StatelessWidget {
  final DateTime to;
  final Color? color;
  final TextStyle style;

  const CountdownDisplay({
    Key? key,
    required this.to,
    this.color,
    this.style = const TextStyle(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CountdownDisplayViewModel>.reactive(
      viewModelBuilder: () => CountdownDisplayViewModel(to: to),
      fireOnModelReadyOnce: true,
      onModelReady: (model) => model.initializeModel(),
      builder: (context, model, _) {
        return GestureDetector(
          onTap: model.toggle,
          child: Text(
            model.text,
            style: style.copyWith(color: color),
          ),
        );
      },
    );
  }
}

class CountdownDisplayViewModel extends BaseViewModel {
  final DateTime to;

  late Timer timer;
  late DateTime toInUtc;
  late Duration dif;

  DateTime now = DateTime.now().toUtc();
  String mode = "short";

  CountdownDisplayViewModel({required this.to});

  void initializeModel() {
    toInUtc = to.toUtc();
    dif = toInUtc.difference(now);
    timer = Timer.periodic(const Duration(seconds: 1), (_) => countdown());
  }

  void countdown() {
    now = DateTime.now().toUtc();
    dif = toInUtc.difference(now);
    if (dif.isNegative) {
      timer.cancel();
    }
    notifyListeners();
  }

  String get text {
    if (mode == "long" || dif.isNegative) {
      return DateFormat.yMd().add_jms().format(to.toLocal());
    }

    var d = dif.inDays;
    var h = dif.inHours.remainder(24);
    var m = dif.inMinutes.remainder(60);
    var s = dif.inSeconds.remainder(60);
    var value = "";

    if (d > 0) value += "${d}d ";
    if (h > 0) value += "${h}h ";
    if (m > 0) value += "${m}m ";
    value += "${s}s";

    return value;
  }

  void toggle() {
    if (mode == "short") {
      mode = "long";
    } else {
      mode = "short";
    }
    notifyListeners();
  }
}
