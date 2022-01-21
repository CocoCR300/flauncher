import 'package:flutter/scheduler.dart';

class TickerModel {
  final TickerProvider? _tickerProvider;

  TickerModel(this._tickerProvider);

  TickerProvider? get tickerProvider => _tickerProvider;
}
