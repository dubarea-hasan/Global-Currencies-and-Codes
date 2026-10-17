// Copyright © 2026 Muhammad Hasan Murad. All rights reserved.
// Strictly Confidential. This software and its documentation are the intellectual
// property of Muhammad Hasan Murad. Unauthorized copying, modification, distribution,
// or reverse engineering of this software via any medium is strictly prohibited.
// This software is provided "as is", without warranty of any kind.

// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'app_config.dart';

// ============================================================================
// 1️⃣ CURRENCY DATA MODEL
// ============================================================================

class CurrencyModel extends Equatable {
  final String code;
  final String name;
  final String symbol;
  final String countryCode;
  final String flag;
  final bool enabled;
  final int decimalDigits;
  final bool isRtl;

  const CurrencyModel({
    required this.code,
    required this.name,
    required this.symbol,
    required this.countryCode,
    required this.flag,
    this.enabled = true,
    this.decimalDigits = 2,
    this.isRtl = false,
  });

  @override
  List<Object?> get props => [
        code,
        name,
        symbol,
        countryCode,
        flag,
        enabled,
        decimalDigits,
        isRtl,
      ];
}

// ============================================================================
// 2️⃣ GLOBAL CURRENCY REGISTRY (105+ CURRENCIES DATASET & MAPPING ENGINE)
// ============================================================================

class CurrencyRegistry {
  static const CurrencyModel defaultCurrency = CurrencyModel(
    code: 'USD',
    name: 'US Dollar',
    symbol: '\$',
    countryCode: 'US',
    flag: '🇺🇸',
    decimalDigits: 2,
    isRtl: false,
  );

  static const List<CurrencyModel> allCurrencies = [
    CurrencyModel(
        code: "USD",
        name: "US Dollar",
        symbol: "\$",
        countryCode: "US",
        flag: "🇺🇸"),
    CurrencyModel(
        code: "EUR",
        name: "Euro",
        symbol: "€",
        countryCode: "EU",
        flag: "🇪🇺"),
    CurrencyModel(
        code: "GBP",
        name: "British Pound",
        symbol: "£",
        countryCode: "GB",
        flag: "🇬🇧"),
    CurrencyModel(
        code: "BDT",
        name: "Bangladeshi Taka",
        symbol: "৳",
        countryCode: "BD",
        flag: "🇧🇩"),
    CurrencyModel(
        code: "SAR",
        name: "Saudi Riyal",
        symbol: "ر.س",
        countryCode: "SA",
        flag: "🇸🇦",
        isRtl: true),
    CurrencyModel(
        code: "AED",
        name: "UAE Dirham",
        symbol: "د.إ",
        countryCode: "AE",
        flag: "🇦🇪",
        isRtl: true),
    CurrencyModel(
        code: "QAR",
        name: "Qatari Riyal",
        symbol: "ر.ق",
        countryCode: "QA",
        flag: "🇶🇦",
        isRtl: true),
    CurrencyModel(
        code: "KWD",
        name: "Kuwaiti Dinar",
        symbol: "د.ك",
        countryCode: "KW",
        flag: "🇰🇼",
        decimalDigits: 3,
        isRtl: true),
    CurrencyModel(
        code: "BHD",
        name: "Bahraini Dinar",
        symbol: "د.ب",
        countryCode: "BH",
        flag: "🇧🇭",
        decimalDigits: 3,
        isRtl: true),
    CurrencyModel(
        code: "OMR",
        name: "Omani Rial",
        symbol: "ر.ع.",
        countryCode: "OM",
        flag: "🇴🇲",
        decimalDigits: 3,
        isRtl: true),
    CurrencyModel(
        code: "INR",
        name: "Indian Rupee",
        symbol: "₹",
        countryCode: "IN",
        flag: "🇮🇳"),
    CurrencyModel(
        code: "PKR",
        name: "Pakistani Rupee",
        symbol: "₨",
        countryCode: "PK",
        flag: "🇵🇰"),
    CurrencyModel(
        code: "PHP",
        name: "Philippine Peso",
        symbol: "₱",
        countryCode: "PH",
        flag: "🇵🇭"),
    CurrencyModel(
        code: "NPR",
        name: "Nepalese Rupee",
        symbol: "रू",
        countryCode: "NP",
        flag: "🇳🇵"),
    CurrencyModel(
        code: "IDR",
        name: "Indonesian Rupiah",
        symbol: "Rp",
        countryCode: "ID",
        flag: "🇮🇩",
        decimalDigits: 0),
    CurrencyModel(
        code: "EGP",
        name: "Egyptian Pound",
        symbol: "ج.م",
        countryCode: "EG",
        flag: "🇪🇬",
        isRtl: true),
    CurrencyModel(
        code: "CAD",
        name: "Canadian Dollar",
        symbol: "CA\$",
        countryCode: "CA",
        flag: "🇨🇦"),
    CurrencyModel(
        code: "AUD",
        name: "Australian Dollar",
        symbol: "A\$",
        countryCode: "AU",
        flag: "🇦🇺"),
    CurrencyModel(
        code: "JPY",
        name: "Japanese Yen",
        symbol: "¥",
        countryCode: "JP",
        flag: "🇯🇵",
        decimalDigits: 0),
    CurrencyModel(
        code: "CNY",
        name: "Chinese Yuan",
        symbol: "¥",
        countryCode: "CN",
        flag: "🇨🇳"),
    CurrencyModel(
        code: "CHF",
        name: "Swiss Franc",
        symbol: "CHF",
        countryCode: "CH",
        flag: "🇨🇭"),
    CurrencyModel(
        code: "SGD",
        name: "Singapore Dollar",
        symbol: "S\$",
        countryCode: "SG",
        flag: "🇸🇬"),
    CurrencyModel(
        code: "MYR",
        name: "Malaysian Ringgit",
        symbol: "RM",
        countryCode: "MY",
        flag: "🇲🇾"),
    CurrencyModel(
        code: "THB",
        name: "Thai Baht",
        symbol: "฿",
        countryCode: "TH",
        flag: "🇹🇭"),
    CurrencyModel(
        code: "NZD",
        name: "New Zealand Dollar",
        symbol: "NZ\$",
        countryCode: "NZ",
        flag: "🇳🇿"),
    CurrencyModel(
        code: "ZAR",
        name: "South African Rand",
        symbol: "R",
        countryCode: "ZA",
        flag: "🇿🇦"),
    CurrencyModel(
        code: "BRL",
        name: "Brazilian Real",
        symbol: "R\$",
        countryCode: "BR",
        flag: "🇧🇷"),
    CurrencyModel(
        code: "RUB",
        name: "Russian Ruble",
        symbol: "₽",
        countryCode: "RU",
        flag: "🇷🇺"),
    CurrencyModel(
        code: "TRY",
        name: "Turkish Lira",
        symbol: "₺",
        countryCode: "TR",
        flag: "🇹🇷"),
    CurrencyModel(
        code: "MXN",
        name: "Mexican Peso",
        symbol: "MX\$",
        countryCode: "MX",
        flag: "🇲🇽"),
    CurrencyModel(
        code: "KRW",
        name: "South Korean Won",
        symbol: "₩",
        countryCode: "KR",
        flag: "🇰🇷",
        decimalDigits: 0),
    CurrencyModel(
        code: "VND",
        name: "Vietnamese Dong",
        symbol: "₫",
        countryCode: "VN",
        flag: "🇻🇳",
        decimalDigits: 0),
    CurrencyModel(
        code: "NGN",
        name: "Nigerian Naira",
        symbol: "₦",
        countryCode: "NG",
        flag: "🇳🇬"),
    CurrencyModel(
        code: "KES",
        name: "Kenyan Shilling",
        symbol: "KSh",
        countryCode: "KE",
        flag: "🇰🇪"),
    CurrencyModel(
        code: "GHS",
        name: "Ghanaian Cedi",
        symbol: "GH₵",
        countryCode: "GH",
        flag: "🇬🇭"),
    CurrencyModel(
        code: "DZD",
        name: "Algerian Dinar",
        symbol: "د.ج",
        countryCode: "DZ",
        flag: "🇩🇿",
        isRtl: true),
    CurrencyModel(
        code: "MAD",
        name: "Moroccan Dirham",
        symbol: "د.م.",
        countryCode: "MA",
        flag: "🇲🇦",
        isRtl: true),
    CurrencyModel(
        code: "TND",
        name: "Tunisian Dinar",
        symbol: "د.ت",
        countryCode: "TN",
        flag: "🇹🇳",
        decimalDigits: 3,
        isRtl: true),
    CurrencyModel(
        code: "IQD",
        name: "Iraqi Dinar",
        symbol: "ع.د",
        countryCode: "IQ",
        flag: "🇮🇶",
        decimalDigits: 3,
        isRtl: true),
    CurrencyModel(
        code: "JOD",
        name: "Jordanian Dinar",
        symbol: "د.ا",
        countryCode: "JO",
        flag: "🇯🇴",
        decimalDigits: 3,
        isRtl: true),
    CurrencyModel(
        code: "LBP",
        name: "Lebanese Pound",
        symbol: "ل.ل",
        countryCode: "LB",
        flag: "🇱🇧",
        isRtl: true),
    CurrencyModel(
        code: "LYD",
        name: "Libyan Dinar",
        symbol: "ل.د",
        countryCode: "LY",
        flag: "🇱🇾",
        decimalDigits: 3,
        isRtl: true),
    CurrencyModel(
        code: "YER",
        name: "Yemeni Rial",
        symbol: "﷼",
        countryCode: "YE",
        flag: "🇾🇪",
        isRtl: true),
    CurrencyModel(
        code: "AFN",
        name: "Afghan Afghani",
        symbol: "؋",
        countryCode: "AF",
        flag: "🇦🇫",
        isRtl: true),
    CurrencyModel(
        code: "ALL",
        name: "Albanian Lek",
        symbol: "L",
        countryCode: "AL",
        flag: "🇦🇱"),
    CurrencyModel(
        code: "AMD",
        name: "Armenian Dram",
        symbol: "֏",
        countryCode: "AM",
        flag: "🇦🇲"),
    CurrencyModel(
        code: "AOA",
        name: "Angolan Kwanza",
        symbol: "Kz",
        countryCode: "AO",
        flag: "🇦🇴"),
    CurrencyModel(
        code: "ARS",
        name: "Argentine Peso",
        symbol: "\$",
        countryCode: "AR",
        flag: "🇦🇷"),
    CurrencyModel(
        code: "AZN",
        name: "Azerbaijani Manat",
        symbol: "₼",
        countryCode: "AZ",
        flag: "🇦🇿"),
    CurrencyModel(
        code: "BAM",
        name: "Bosnia-Herzegovina Mark",
        symbol: "KM",
        countryCode: "BA",
        flag: "🇧🇦"),
    CurrencyModel(
        code: "BBD",
        name: "Barbadian Dollar",
        symbol: "Bds\$",
        countryCode: "BB",
        flag: "🇧🇧"),
    CurrencyModel(
        code: "BGN",
        name: "Bulgarian Lev",
        symbol: "лв",
        countryCode: "BG",
        flag: "🇧🇬"),
    CurrencyModel(
        code: "BIF",
        name: "Burundian Franc",
        symbol: "FBu",
        countryCode: "BI",
        flag: "🇧🇮",
        decimalDigits: 0),
    CurrencyModel(
        code: "BND",
        name: "Brunei Dollar",
        symbol: "B\$",
        countryCode: "BN",
        flag: "🇧🇳"),
    CurrencyModel(
        code: "BOB",
        name: "Bolivian Boliviano",
        symbol: "Bs",
        countryCode: "BO",
        flag: "🇧🇴"),
    CurrencyModel(
        code: "BSD",
        name: "Bahamian Dollar",
        symbol: "B\$",
        countryCode: "BS",
        flag: "🇧🇸"),
    CurrencyModel(
        code: "BTN",
        name: "Bhutanese Ngultrum",
        symbol: "Nu.",
        countryCode: "BT",
        flag: "🇧🇹"),
    CurrencyModel(
        code: "BWP",
        name: "Botswana Pula",
        symbol: "P",
        countryCode: "BW",
        flag: "🇧🇼"),
    CurrencyModel(
        code: "BYN",
        name: "Belarusian Ruble",
        symbol: "Br",
        countryCode: "BY",
        flag: "🇧🇾"),
    CurrencyModel(
        code: "BZD",
        name: "Belize Dollar",
        symbol: "BZ\$",
        countryCode: "BZ",
        flag: "🇧🇿"),
    CurrencyModel(
        code: "CDF",
        name: "Congolese Franc",
        symbol: "FC",
        countryCode: "CD",
        flag: "🇨🇩"),
    CurrencyModel(
        code: "CLP",
        name: "Chilean Peso",
        symbol: "CLP\$",
        countryCode: "CL",
        flag: "🇨🇱",
        decimalDigits: 0),
    CurrencyModel(
        code: "COP",
        name: "Colombian Peso",
        symbol: "COL\$",
        countryCode: "CO",
        flag: "🇨🇴"),
    CurrencyModel(
        code: "CRC",
        name: "Costa Rican Colón",
        symbol: "₡",
        countryCode: "CR",
        flag: "🇨🇷"),
    CurrencyModel(
        code: "CUP",
        name: "Cuban Peso",
        symbol: "\$",
        countryCode: "CU",
        flag: "🇨🇺"),
    CurrencyModel(
        code: "CVE",
        name: "Cape Verdean Escudo",
        symbol: "Esc",
        countryCode: "CV",
        flag: "🇨🇻"),
    CurrencyModel(
        code: "CZK",
        name: "Czech Koruna",
        symbol: "Kč",
        countryCode: "CZ",
        flag: "🇨🇿"),
    CurrencyModel(
        code: "DJF",
        name: "Djiboutian Franc",
        symbol: "Fdj",
        countryCode: "DJ",
        flag: "🇩🇯",
        decimalDigits: 0),
    CurrencyModel(
        code: "DKK",
        name: "Danish Krone",
        symbol: "kr",
        countryCode: "DK",
        flag: "🇩🇰"),
    CurrencyModel(
        code: "DOP",
        name: "Dominican Peso",
        symbol: "RD\$",
        countryCode: "DO",
        flag: "🇩🇴"),
    CurrencyModel(
        code: "ETB",
        name: "Ethiopian Birr",
        symbol: "Br",
        countryCode: "ET",
        flag: "🇪🇹"),
    CurrencyModel(
        code: "FJD",
        name: "Fijian Dollar",
        symbol: "FJ\$",
        countryCode: "FJ",
        flag: "🇫🇯"),
    CurrencyModel(
        code: "GEL",
        name: "Georgian Lari",
        symbol: "₾",
        countryCode: "GE",
        flag: "🇬🇪"),
    CurrencyModel(
        code: "GMD",
        name: "Gambian Dalasi",
        symbol: "D",
        countryCode: "GM",
        flag: "🇬🇲"),
    CurrencyModel(
        code: "GNF",
        name: "Guinean Franc",
        symbol: "FG",
        countryCode: "GN",
        flag: "🇬🇳",
        decimalDigits: 0),
    CurrencyModel(
        code: "GTQ",
        name: "Guatemalan Quetzal",
        symbol: "Q",
        countryCode: "GT",
        flag: "🇬🇹"),
    CurrencyModel(
        code: "GYD",
        name: "Guyanese Dollar",
        symbol: "G\$",
        countryCode: "GY",
        flag: "🇬🇾"),
    CurrencyModel(
        code: "HKD",
        name: "Hong Kong Dollar",
        symbol: "HK\$",
        countryCode: "HK",
        flag: "🇭🇰"),
    CurrencyModel(
        code: "HNL",
        name: "Honduran Lempira",
        symbol: "L",
        countryCode: "HN",
        flag: "🇭🇳"),
    CurrencyModel(
        code: "HTG",
        name: "Haitian Gourde",
        symbol: "G",
        countryCode: "HT",
        flag: "🇭🇹"),
    CurrencyModel(
        code: "HUF",
        name: "Hungarian Forint",
        symbol: "Ft",
        countryCode: "HU",
        flag: "🇭🇺",
        decimalDigits: 0),
    CurrencyModel(
        code: "ILS",
        name: "Israeli Shekel",
        symbol: "₪",
        countryCode: "IL",
        flag: "🇮🇱"),
    CurrencyModel(
        code: "ISK",
        name: "Icelandic Króna",
        symbol: "kr",
        countryCode: "IS",
        flag: "🇮🇸",
        decimalDigits: 0),
    CurrencyModel(
        code: "JMD",
        name: "Jamaican Dollar",
        symbol: "J\$",
        countryCode: "JM",
        flag: "🇯🇲"),
    CurrencyModel(
        code: "KGS",
        name: "Kyrgyzstani Som",
        symbol: "с",
        countryCode: "KG",
        flag: "🇰🇬"),
    CurrencyModel(
        code: "KHR",
        name: "Cambodian Riel",
        symbol: "៛",
        countryCode: "KH",
        flag: "🇰🇭"),
    CurrencyModel(
        code: "KMF",
        name: "Comorian Franc",
        symbol: "CF",
        countryCode: "KM",
        flag: "🇰🇲",
        decimalDigits: 0),
    CurrencyModel(
        code: "KZT",
        name: "Kazakhstani Tenge",
        symbol: "₸",
        countryCode: "KZ",
        flag: "🇰🇿"),
    CurrencyModel(
        code: "LAK",
        name: "Lao Kip",
        symbol: "₭",
        countryCode: "LA",
        flag: "🇱🇦",
        decimalDigits: 0),
    CurrencyModel(
        code: "LKR",
        name: "Sri Lankan Rupee",
        symbol: "Rs",
        countryCode: "LK",
        flag: "🇱🇰"),
    CurrencyModel(
        code: "LRD",
        name: "Liberian Dollar",
        symbol: "L\$",
        countryCode: "LR",
        flag: "🇱🇷"),
    CurrencyModel(
        code: "LSL",
        name: "Lesotho Loti",
        symbol: "L",
        countryCode: "LS",
        flag: "🇱🇸"),
    CurrencyModel(
        code: "MDL",
        name: "Moldovan Leu",
        symbol: "L",
        countryCode: "MD",
        flag: "🇲🇩"),
    CurrencyModel(
        code: "MGA",
        name: "Malagasy Ariary",
        symbol: "Ar",
        countryCode: "MG",
        flag: "🇲🇬",
        decimalDigits: 0),
    CurrencyModel(
        code: "MKD",
        name: "Macedonian Denar",
        symbol: "ден",
        countryCode: "MK",
        flag: "🇲🇰"),
    CurrencyModel(
        code: "MMK",
        name: "Myanmar Kyat",
        symbol: "K",
        countryCode: "MM",
        flag: "🇲🇲",
        decimalDigits: 0),
    CurrencyModel(
        code: "MNT",
        name: "Mongolian Tögrög",
        symbol: "₮",
        countryCode: "MN",
        flag: "🇲🇳"),
    CurrencyModel(
        code: "MOP",
        name: "Macanese Pataca",
        symbol: "MOP\$",
        countryCode: "MO",
        flag: "🇲🇴"),
    CurrencyModel(
        code: "MRU",
        name: "Mauritanian Ouguiya",
        symbol: "UM",
        countryCode: "MR",
        flag: "🇲🇷"),
    CurrencyModel(
        code: "MUR",
        name: "Mauritian Rupee",
        symbol: "₨",
        countryCode: "MU",
        flag: "🇲🇺"),
    CurrencyModel(
        code: "MVR",
        name: "Maldivian Rufiyaa",
        symbol: "Rf",
        countryCode: "MV",
        flag: "🇲🇻"),
    CurrencyModel(
        code: "MWK",
        name: "Malawian Kwacha",
        symbol: "MK",
        countryCode: "MW",
        flag: "🇲🇼"),
    CurrencyModel(
        code: "MZN",
        name: "Mozambican Metical",
        symbol: "MT",
        countryCode: "MZ",
        flag: "🇲🇿"),
    CurrencyModel(
        code: "NAD",
        name: "Namibian Dollar",
        symbol: "N\$",
        countryCode: "NA",
        flag: "🇳🇦"),
    CurrencyModel(
        code: "NIO",
        name: "Nicaraguan Córdoba",
        symbol: "C\$",
        countryCode: "NI",
        flag: "🇳🇮"),
    CurrencyModel(
        code: "NOK",
        name: "Norwegian Krone",
        symbol: "kr",
        countryCode: "NO",
        flag: "🇳🇴"),
    CurrencyModel(
        code: "PAB",
        name: "Panamanian Balboa",
        symbol: "B/.",
        countryCode: "PA",
        flag: "🇵🇦"),
    CurrencyModel(
        code: "PEN",
        name: "Peruvian Sol",
        symbol: "S/.",
        countryCode: "PE",
        flag: "🇵🇪"),
    CurrencyModel(
        code: "PGK",
        name: "Papua New Guinean Kina",
        symbol: "K",
        countryCode: "PG",
        flag: "🇵🇬"),
    CurrencyModel(
        code: "PLN",
        name: "Polish Złoty",
        symbol: "zł",
        countryCode: "PL",
        flag: "🇵🇱"),
    CurrencyModel(
        code: "PYG",
        name: "Paraguayan Guaraní",
        symbol: "₲",
        countryCode: "PY",
        flag: "🇵🇾",
        decimalDigits: 0),
    CurrencyModel(
        code: "RON",
        name: "Romanian Leu",
        symbol: "lei",
        countryCode: "RO",
        flag: "🇷🇴"),
    CurrencyModel(
        code: "RSD",
        name: "Serbian Dinar",
        symbol: "дин.",
        countryCode: "RS",
        flag: "🇷🇸"),
    CurrencyModel(
        code: "RWF",
        name: "Rwandan Franc",
        symbol: "FRw",
        countryCode: "RW",
        flag: "🇷🇼",
        decimalDigits: 0),
    CurrencyModel(
        code: "SBD",
        name: "Solomon Islands Dollar",
        symbol: "SI\$",
        countryCode: "SB",
        flag: "🇸🇧"),
    CurrencyModel(
        code: "SCR",
        name: "Seychellois Rupee",
        symbol: "SR",
        countryCode: "SC",
        flag: "🇸🇨"),
    CurrencyModel(
        code: "SDG",
        name: "Sudanese Pound",
        symbol: "ج.س.",
        countryCode: "SD",
        flag: "🇸🇩",
        isRtl: true),
    CurrencyModel(
        code: "SEK",
        name: "Swedish Krona",
        symbol: "kr",
        countryCode: "SE",
        flag: "🇸🇪"),
    CurrencyModel(
        code: "SLL",
        name: "Sierra Leonean Leone",
        symbol: "Le",
        countryCode: "SL",
        flag: "🇸🇱"),
    CurrencyModel(
        code: "SOS",
        name: "Somali Shilling",
        symbol: "Sh.So.",
        countryCode: "SO",
        flag: "🇸🇴"),
    CurrencyModel(
        code: "SRD",
        name: "Surinamese Dollar",
        symbol: "Sr\$",
        countryCode: "SR",
        flag: "🇸🇷"),
    CurrencyModel(
        code: "SSP",
        name: "South Sudanese Pound",
        symbol: "SS£",
        countryCode: "SS",
        flag: "🇸🇸"),
    CurrencyModel(
        code: "STN",
        name: "São Tomé and Príncipe Dobra",
        symbol: "Db",
        countryCode: "ST",
        flag: "🇸🇹"),
    CurrencyModel(
        code: "SYP",
        name: "Syrian Pound",
        symbol: "£S",
        countryCode: "SY",
        flag: "🇸🇾",
        isRtl: true),
    CurrencyModel(
        code: "SZL",
        name: "Swazi Lilangeni",
        symbol: "L",
        countryCode: "SZ",
        flag: "🇸🇿"),
    CurrencyModel(
        code: "TJS",
        name: "Tajikistani Somoni",
        symbol: "ЅМ",
        countryCode: "TJ",
        flag: "🇹🇯"),
    CurrencyModel(
        code: "TMT",
        name: "Turkmenistani Manat",
        symbol: "m",
        countryCode: "TM",
        flag: "🇹🇲"),
    CurrencyModel(
        code: "TOP",
        name: "Tongan Paʻanga",
        symbol: "T\$",
        countryCode: "TO",
        flag: "🇹🇴"),
    CurrencyModel(
        code: "TTD",
        name: "Trinidad & Tobago Dollar",
        symbol: "TT\$",
        countryCode: "TT",
        flag: "🇹🇹"),
    CurrencyModel(
        code: "TWD",
        name: "New Taiwan Dollar",
        symbol: "NT\$",
        countryCode: "TW",
        flag: "🇹🇼"),
    CurrencyModel(
        code: "TZS",
        name: "Tanzanian Shilling",
        symbol: "TSh",
        countryCode: "TZ",
        flag: "🇹🇿"),
    CurrencyModel(
        code: "UAH",
        name: "Ukrainian Hryvnia",
        symbol: "₴",
        countryCode: "UA",
        flag: "🇺🇦"),
    CurrencyModel(
        code: "UGX",
        name: "Ugandan Shilling",
        symbol: "USh",
        countryCode: "UG",
        flag: "🇺🇬",
        decimalDigits: 0),
    CurrencyModel(
        code: "UYU",
        name: "Uruguayan Peso",
        symbol: "\$U",
        countryCode: "UY",
        flag: "🇺🇾"),
    CurrencyModel(
        code: "UZS",
        name: "Uzbekistani Som",
        symbol: "so'm",
        countryCode: "UZ",
        flag: "🇺🇿"),
    CurrencyModel(
        code: "VES",
        name: "Venezuelan Bolívar",
        symbol: "Bs.S",
        countryCode: "VE",
        flag: "🇻🇪"),
    CurrencyModel(
        code: "VUV",
        name: "Vanuatu Vatu",
        symbol: "VT",
        countryCode: "VU",
        flag: "🇻🇺",
        decimalDigits: 0),
    CurrencyModel(
        code: "WST",
        name: "Samoan Tala",
        symbol: "WS\$",
        countryCode: "WS",
        flag: "🇼🇸"),
    CurrencyModel(
        code: "XAF",
        name: "Central African CFA Franc",
        symbol: "FCFA",
        countryCode: "CM",
        flag: "🇨🇲",
        decimalDigits: 0),
    CurrencyModel(
        code: "XCD",
        name: "East Caribbean Dollar",
        symbol: "EC\$",
        countryCode: "AG",
        flag: "🇦🇬"),
    CurrencyModel(
        code: "XOF",
        name: "West African CFA Franc",
        symbol: "CFA",
        countryCode: "SN",
        flag: "🇸🇳",
        decimalDigits: 0),
    CurrencyModel(
        code: "XPF",
        name: "CFP Franc",
        symbol: "CFPF",
        countryCode: "PF",
        flag: "🇵🇫",
        decimalDigits: 0),
    CurrencyModel(
        code: "ZMW",
        name: "Zambian Kwacha",
        symbol: "ZK",
        countryCode: "ZM",
        flag: "🇿🇲"),
    CurrencyModel(
        code: "ZWL",
        name: "Zimbabwean Dollar",
        symbol: "Z\$",
        countryCode: "ZW",
        flag: "🇿🇼"),
  ];

  // 🚀 Fast Lookup Maps
  static final Map<String, CurrencyModel> _byCode = {
    for (var c in allCurrencies) c.code.toUpperCase(): c,
  };

  static final Map<String, CurrencyModel> _byCountryCode = {
    for (var c in allCurrencies) c.countryCode.toUpperCase(): c,
  };

  // 🚀 Comprehensive Country Name to Currency Code Map
  static final Map<String, String> _countryNameToCode = {
    "UNITED ARAB EMIRATES": "AED",
    "UAE": "AED",
    "SAUDI ARABIA": "SAR",
    "KSA": "SAR",
    "BANGLADESH": "BDT",
    "UNITED STATES": "USD",
    "USA": "USD",
    "UNITED KINGDOM": "GBP",
    "UK": "GBP",
    "INDIA": "INR",
    "PAKISTAN": "PKR",
    "QATAR": "QAR",
    "KUWAIT": "KWD",
    "BAHRAIN": "BHD",
    "OMAN": "OMR",
    "CANADA": "CAD",
    "AUSTRALIA": "AUD",
    "GERMANY": "EUR",
    "FRANCE": "EUR",
    "ITALY": "EUR",
    "SPAIN": "EUR",
    "NETHERLANDS": "EUR",
    "BELGIUM": "EUR",
    "PORTUGAL": "EUR",
    "IRELAND": "EUR",
    "AUSTRIA": "EUR",
    "GREECE": "EUR",
    "FINLAND": "EUR",
    "SINGAPORE": "SGD",
    "MALAYSIA": "MYR",
    "THAILAND": "THB",
    "PHILIPPINES": "PHP",
    "INDONESIA": "IDR",
    "VIETNAM": "VND",
    "CHINA": "CNY",
    "JAPAN": "JPY",
    "SOUTH KOREA": "KRW",
    "KOREA": "KRW",
    "TURKEY": "TRY",
    "EGYPT": "EGP",
    "SOUTH AFRICA": "ZAR",
    "NIGERIA": "NGN",
    "KENYA": "KES",
    "BRAZIL": "BRL",
    "RUSSIA": "RUB",
    "MEXICO": "MXN",
    "SWITZERLAND": "CHF",
    "NEW ZEALAND": "NZD",
    "NEPAL": "NPR",
    "SRI LANKA": "LKR",
    "JORDAN": "JOD",
    "LEBANON": "LBP",
    "IRAQ": "IQD",
    "ALGERIA": "DZD",
    "MOROCCO": "MAD",
    "TUNISIA": "TND",
    "LIBYA": "LYD",
    "YEMEN": "YER",
    "AFGHANISTAN": "AFN",
  };

  /// 🔎 Find Currency by Currency Code (e.g., 'AED', 'BDT', 'USD')
  static CurrencyModel findByCode(String? code) {
    if (code == null || code.trim().isEmpty) return defaultCurrency;
    return _byCode[code.trim().toUpperCase()] ?? defaultCurrency;
  }

  /// 🔎 Find Currency by Country Code (e.g., 'AE', 'BD', 'US')
  static CurrencyModel findByCountryCode(String? countryCode) {
    if (countryCode == null || countryCode.trim().isEmpty)
      return defaultCurrency;
    return _byCountryCode[countryCode.trim().toUpperCase()] ?? defaultCurrency;
  }

  /// 🔎 Find Currency by Country Name or Country Code (e.g., 'United Arab Emirates', 'Bangladesh')
  static CurrencyModel findByCountryName(String? countryName) {
    if (countryName == null || countryName.trim().isEmpty)
      return defaultCurrency;
    final normalized = countryName.trim().toUpperCase();

    // 1. Direct country name match
    if (_countryNameToCode.containsKey(normalized)) {
      final code = _countryNameToCode[normalized]!;
      return findByCode(code);
    }

    // 2. Partial country name match
    for (var entry in _countryNameToCode.entries) {
      if (normalized.contains(entry.key) || entry.key.contains(normalized)) {
        return findByCode(entry.value);
      }
    }

    // 3. ISO Code match fallback
    if (_byCountryCode.containsKey(normalized)) {
      return _byCountryCode[normalized]!;
    }

    // 4. Currency Code match fallback
    if (_byCode.containsKey(normalized)) {
      return _byCode[normalized]!;
    }

    return defaultCurrency;
  }

  /// 🔎 Auto-Detect Currency from System Locale (e.g. 'en_US', 'ar_AE', 'bn_BD')
  static CurrencyModel findByLocale(String localeName) {
    try {
      final parts = localeName.split(RegExp(r'[_-]'));
      if (parts.length >= 2) {
        final countryIso = parts[1].toUpperCase();
        if (_byCountryCode.containsKey(countryIso)) {
          return _byCountryCode[countryIso]!;
        }
      }
    } catch (_) {}
    return defaultCurrency;
  }
}

// ============================================================================
// 3️⃣ BLoC EVENTS & STATES
// ============================================================================

abstract class CurrencyEvent extends Equatable {
  const CurrencyEvent();

  @override
  List<Object?> get props => [];
}

class LoadCurrencyData extends CurrencyEvent {
  final String? preferredCurrencyOrCountry;

  const LoadCurrencyData([this.preferredCurrencyOrCountry]);

  @override
  List<Object?> get props => [preferredCurrencyOrCountry];
}

class ChangeCurrencyEvent extends CurrencyEvent {
  final String currencyCode;

  const ChangeCurrencyEvent(this.currencyCode);

  @override
  List<Object?> get props => [currencyCode];
}

class ChangeCurrencyByCountryEvent extends CurrencyEvent {
  final String countryNameOrIso;

  const ChangeCurrencyByCountryEvent(this.countryNameOrIso);

  @override
  List<Object?> get props => [countryNameOrIso];
}

abstract class CurrencyState extends Equatable {
  const CurrencyState();

  @override
  List<Object?> get props => [];
}

class CurrencyInitial extends CurrencyState {}

class CurrencyLoading extends CurrencyState {}

class CurrencyLoaded extends CurrencyState {
  final String localCurrencyCode;
  final String localCurrencySymbol;
  final Map<String, dynamic> exchangeRates;
  final CurrencyModel currencyModel;

  CurrencyLoaded({
    required this.localCurrencyCode,
    required this.localCurrencySymbol,
    required this.exchangeRates,
    CurrencyModel? model,
  }) : currencyModel = model ?? CurrencyRegistry.findByCode(localCurrencyCode);

  /// 🧮 🚀 SMART CONVERSION: Item Currency -> USD -> Local Currency
  double convertAmount(double itemPrice, String itemCurrency) {
    if (itemPrice <= 0) return 0.0;
    final cleanItemCurrency = itemCurrency.trim().toUpperCase();
    final cleanLocalCurrency = localCurrencyCode.trim().toUpperCase();

    if (cleanItemCurrency == cleanLocalCurrency) {
      return itemPrice;
    }

    if (!exchangeRates.containsKey(cleanItemCurrency) ||
        !exchangeRates.containsKey(cleanLocalCurrency)) {
      return itemPrice;
    }

    try {
      double itemRateVsUSD =
          (exchangeRates[cleanItemCurrency] as num).toDouble();
      double localRateVsUSD =
          (exchangeRates[cleanLocalCurrency] as num).toDouble();

      if (itemRateVsUSD <= 0) return itemPrice;

      double priceInUSD = itemPrice / itemRateVsUSD;
      return priceInUSD * localRateVsUSD;
    } catch (_) {
      return itemPrice;
    }
  }

  /// 📝 RTL & Decimal Aware Currency Formatting
  String formatWithSymbol(double amountInLocal) {
    final int decimals = currencyModel.decimalDigits;

    final format = NumberFormat.currency(
      symbol: '',
      decimalDigits:
          (amountInLocal == amountInLocal.roundToDouble() && decimals != 3)
              ? 0
              : decimals,
    );
    final formattedNumber = format.format(amountInLocal).trim();

    if (currencyModel.isRtl) {
      return "$formattedNumber $localCurrencySymbol";
    } else {
      return "$localCurrencySymbol $formattedNumber";
    }
  }

  @override
  List<Object?> get props => [
        localCurrencyCode,
        localCurrencySymbol,
        exchangeRates,
        currencyModel,
      ];
}

class CurrencyError extends CurrencyState {
  final String message;
  final String localCurrencyCode;
  final String localCurrencySymbol;

  const CurrencyError(
    this.message,
    this.localCurrencyCode,
    this.localCurrencySymbol,
  );

  @override
  List<Object?> get props => [message, localCurrencyCode, localCurrencySymbol];
}

// ============================================================================
// 4️⃣ EXCHANGE RATE SERVICE (LIVE REST API WITH USD BASE)
// ============================================================================

class ExchangeRateService {
  final Dio _dio;

  ExchangeRateService()
      : _dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ));

  Future<Map<String, dynamic>> fetchLiveRates() async {
    try {
      const String url = "https://open.er-api.com/v6/latest/USD";
      final response = await _dio.get(url);

      if (response.statusCode == 200 && response.data != null) {
        final rates = response.data['rates'];
        if (rates is Map) {
          return Map<String, dynamic>.from(rates);
        }
      }
      throw Exception("Invalid exchange rate payload");
    } catch (e) {
      debugPrint("⚠️ Exchange Rate Live Fetch Fallback: $e");
      return _getFallbackStaticRates();
    }
  }

  Map<String, dynamic> _getFallbackStaticRates() {
    return {
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
  }
}

// ============================================================================
// 5️⃣ CURRENCY BLOC (AUTO-DETECTION & GLOBAL SYNCHRONIZATION)
// ============================================================================

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final ExchangeRateService _exchangeRateService;
  Map<String, dynamic> _cachedRates = {};

  CurrencyBloc(this._exchangeRateService) : super(CurrencyInitial()) {
    on<LoadCurrencyData>(_onLoadCurrencyData);
    on<ChangeCurrencyEvent>(_onChangeCurrency);
    on<ChangeCurrencyByCountryEvent>(_onChangeCurrencyByCountry);
  }

  Future<void> _onLoadCurrencyData(
    LoadCurrencyData event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(CurrencyLoading());

    CurrencyModel resolvedCurrency = CurrencyRegistry.defaultCurrency;

    // 🚀 1. If explicit currency/country requested
    if (event.preferredCurrencyOrCountry != null &&
        event.preferredCurrencyOrCountry!.isNotEmpty) {
      resolvedCurrency =
          CurrencyRegistry.findByCountryName(event.preferredCurrencyOrCountry!);
    }
    // 🚀 2. Check AppConfig country/currency notifiers
    else if (AppConfig.countryNotifier.value != null &&
        AppConfig.countryNotifier.value!.isNotEmpty) {
      resolvedCurrency =
          CurrencyRegistry.findByCountryName(AppConfig.countryNotifier.value!);
    }
    // 🚀 3. System device locale auto-detection
    else {
      try {
        final defaultLocale = Platform.localeName;
        resolvedCurrency = CurrencyRegistry.findByLocale(defaultLocale);
      } catch (_) {
        resolvedCurrency =
            CurrencyRegistry.findByCountryName("United Arab Emirates");
      }
    }

    // Synchronize AppConfig global notifier
    AppConfig.currencyNotifier.value = resolvedCurrency.code;

    // Fetch live exchange rates
    try {
      if (_cachedRates.isEmpty) {
        _cachedRates = await _exchangeRateService.fetchLiveRates();
      }

      emit(CurrencyLoaded(
        localCurrencyCode: resolvedCurrency.code,
        localCurrencySymbol: resolvedCurrency.symbol,
        exchangeRates: _cachedRates,
        model: resolvedCurrency,
      ));
    } catch (e) {
      emit(CurrencyError(
        "Could not load live exchange rates",
        resolvedCurrency.code,
        resolvedCurrency.symbol,
      ));
    }
  }

  void _onChangeCurrency(
    ChangeCurrencyEvent event,
    Emitter<CurrencyState> emit,
  ) {
    final currency = CurrencyRegistry.findByCode(event.currencyCode);
    AppConfig.currencyNotifier.value = currency.code;

    if (_cachedRates.isNotEmpty) {
      emit(CurrencyLoaded(
        localCurrencyCode: currency.code,
        localCurrencySymbol: currency.symbol,
        exchangeRates: _cachedRates,
        model: currency,
      ));
    } else {
      add(LoadCurrencyData(currency.code));
    }
  }

  void _onChangeCurrencyByCountry(
    ChangeCurrencyByCountryEvent event,
    Emitter<CurrencyState> emit,
  ) {
    final currency = CurrencyRegistry.findByCountryName(event.countryNameOrIso);
    AppConfig.currencyNotifier.value = currency.code;

    if (_cachedRates.isNotEmpty) {
      emit(CurrencyLoaded(
        localCurrencyCode: currency.code,
        localCurrencySymbol: currency.symbol,
        exchangeRates: _cachedRates,
        model: currency,
      ));
    } else {
      add(LoadCurrencyData(currency.code));
    }
  }
}
