import 'dart:ui';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'package:libreta_domino/core/database/database.dart';
import 'package:libreta_domino/core/di/di.dart';
import 'package:libreta_domino/translations/data/model/app_localization.dart';
import 'package:libreta_domino/translations/data/model/translation.dart';
import 'package:libreta_domino/translations/domain/entities/message_lookup.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TranslationsRepository {
  const TranslationsRepository();

  Box<AppLocalization> get appLocalizationBox =>
      locator.get<Database>().localizationBox;

  List<Locale> supportedLocales() {
    final translations = appLocalizationBox.values.first.data;
    final response = translations.fold<List<Locale>>(<Locale>[], (list, tran) {
      Locale? locale;
      if (tran.locale.contains('_')) {
        final split = tran.locale.split('_');
        locale = Locale.fromSubtags(
          languageCode: split[0].toLowerCase(),
          countryCode: split[1],
        );
      } else {
        locale = Locale.fromSubtags(
          languageCode: tran.locale.toLowerCase(),
        );
      }

      if (!list.contains(locale)) {
        list.add(locale);
      }

      return list;
    });
    return response;
  }

  String? translate(String locale, String key) {
    try {
      final translations = appLocalizationBox.values.first.data;
      return translations
          .firstWhere((e) => e.locale == locale && e.key == key)
          .value;
    } catch (_) {
      return null;
    }
  }

  MessageLookupByLibrary? getTranslations(String locale) {
    try {
      final translations = appLocalizationBox.values.first.data;
      final messages = translations.where(
        (e) => e.locale == locale,
      );

      return MessageLookup(
        locale,
        messages.toList(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> fetchTranslations() async {
    final parameters = appLocalizationBox.values.first;
    final function = ParseCloudFunction('version');
    final parseResponse = await function.execute(
      parameters: parameters.toJson(),
    );
    if (parseResponse.success &&
        parseResponse.result != null &&
        (parseResponse.result as Map).isNotEmpty) {
      var appLocalizations = AppLocalization.fromJson(parseResponse.result);
      if (appLocalizations.version != parameters.version) {
        appLocalizations = appLocalizations.copyWith(
          data: ((parseResponse.result as Map)['data'] as List)
              .map((e) => Translation.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
        await appLocalizationBox.put(
          appLocalizations.version,
          appLocalizations,
        );
        await appLocalizationBox.delete(parameters.version);
        await appLocalizationBox.flush();
        return true;
      }
    }
    return false;
  }
}
