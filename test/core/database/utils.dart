import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:libreta_domino/core/database/database.dart';
import 'package:libreta_domino/translations/data/model/app_localization.dart';
import 'package:libreta_domino/translations/data/model/translation.dart';

import '../di/di.dart';

Future<void> setupTestingDB() async {
  if (!locator.isRegistered<Database>()) {
    throw Exception("Database must be registered inside get it");
  }

  final appLocalization = locator.get<Database>().localizationBox;

  final jsonString = await rootBundle.loadString('assets/l10n/l10n.json');
  final jsonResponse = json.decode(jsonString);
  var initialTranslation = AppLocalization.fromJson(jsonResponse);
  initialTranslation = initialTranslation.copyWith(
    data: (jsonResponse['data'] as List)
        .map((e) => Translation.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  await appLocalization.put(
    initialTranslation.version,
    initialTranslation,
  );

  await appLocalization.flush();
}
