// Copyright © 2026 Muhammad Hasan Murad. All rights reserved.
// Strictly Confidential. This software and its documentation are the intellectual
// property of Muhammad Hasan Murad. Unauthorized copying, modification, distribution,
// or reverse engineering of this software via any medium is strictly prohibited.
// This software is provided "as is", without warranty of any kind.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../config/app_config.dart';
import '../config/currency_config.dart';

extension CurrencyConverter on num {
  /// 🚀 গ্লোবাল লাইভ এক্সচেঞ্জ কনভার্সন ও কারেন্সি সিম্বল ফরম্যাটিং এক্সটেনশন
  ///
  /// [fromCurrency]: যে কারেন্সিতে পণ্যের আসল দাম সংরক্ষিত আছে (যেমন: 'USD', 'AED', 'BDT')
  /// ব্যবহারকারী যে দেশেই থাকুক না কেন, এটি স্বয়ংক্রিয়ভাবে তার লোকাল কারেন্সিতে
  /// রূপান্তর করে সঠিক সিম্বল (৳, د.إ, $, €, ₹ ইত্যাদি) সহ ফরম্যাট করে দেবে।
  String toLocalCurrency(
    BuildContext context, {
    String fromCurrency = 'USD',
  }) {
    // ১. কারেন্সি কোড ক্লিন ও স্যানিটাইজ করা
    String cleanFromCurrency = fromCurrency.trim().toUpperCase();
    if (cleanFromCurrency.isEmpty || cleanFromCurrency == '\$') {
      cleanFromCurrency = 'USD';
    }

    try {
      final state = context.read<CurrencyBloc>().state;

      // ২. CurrencyBloc সক্রিয় থাকলে লাইভ রেট অনুযায়ী রূপান্তর
      if (state is CurrencyLoaded) {
        double converted = state.convertAmount(toDouble(), cleanFromCurrency);
        return state.formatWithSymbol(converted);
      }
    } catch (_) {
      // BLoC আন-অ্যাভেইলেবল থাকলে নিচে নিরাপদ অফলাইন ফলব্যাকে চলে যাবে
    }

    // ৩. অফলাইন বা প্রাক-লোডিং রেজিলিয়েন্ট ফলব্যাক
    final String localCode = AppConfig.currencyNotifier.value ?? 'AED';
    final CurrencyModel currency = CurrencyRegistry.findByCode(localCode);

    double fallbackAmount = toDouble();

    // প্রাথমিক অফলাইন কনভার্সন অনুপাত (যদি USD বেস থেকে আসে)
    if (cleanFromCurrency != currency.code) {
      final Map<String, double> staticRates = {
        "USD": 1.0,
        "EUR": 0.92,
        "GBP": 0.78,
        "AED": 3.67,
        "SAR": 3.75,
        "BDT": 121.5,
        "INR": 86.8,
        "PKR": 278.5,
        "QAR": 3.64,
        "KWD": 0.31,
        "BHD": 0.38,
        "OMR": 0.38,
        "CAD": 1.43,
        "AUD": 1.58,
        "JPY": 154.2,
        "CNY": 7.24,
        "MYR": 4.45,
        "SGD": 1.35,
        "THB": 34.2,
        "PHP": 58.2,
        "IDR": 16250.0,
        "TRY": 35.8,
        "RUB": 97.4,
        "BRL": 5.85,
        "EGP": 50.4,
        "ZAR": 18.2,
      };

      double fromRate = staticRates[cleanFromCurrency] ?? 1.0;
      double toRate = staticRates[currency.code] ?? 1.0;

      if (fromRate > 0) {
        fallbackAmount = (toDouble() / fromRate) * toRate;
      }
    }

    final int decimals = currency.decimalDigits;
    final format = NumberFormat.currency(
      symbol: '',
      decimalDigits:
          (fallbackAmount == fallbackAmount.roundToDouble() && decimals != 3)
              ? 0
              : decimals,
    );
    final formattedNumber = format.format(fallbackAmount).trim();

    // আরবি/RTL হলে সিম্বল ডানে, অন্যথায় বাঁয়ে বসবে
    if (currency.isRtl) {
      return "$formattedNumber ${currency.symbol}";
    } else {
      return "${currency.symbol} $formattedNumber";
    }
  }
}

/// 🚀 স্ট্রিং টাইপ প্রাইস থেকে সেফ কনভার্সন হেল্পার (ক্র্যাশ প্রিভেন্টর)
extension CurrencyStringConverter on String {
  String toLocalCurrency(
    BuildContext context, {
    String fromCurrency = 'USD',
  }) {
    final cleanStr = replaceAll(RegExp(r'[^0-9.]'), '').trim();
    final parsed = double.tryParse(cleanStr);
    if (parsed == null) return this;
    return parsed.toLocalCurrency(context, fromCurrency: fromCurrency);
  }
}
