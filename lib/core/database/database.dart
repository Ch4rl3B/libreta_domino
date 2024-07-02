import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:libreta_domino/core/constants/constants.dart';
import 'package:libreta_domino/core/constants/strings.dart';
import 'package:libreta_domino/core/di/di.dart';
import 'package:libreta_domino/features/game/data/adapters/game.dart';
import 'package:libreta_domino/features/game/data/adapters/game_data_adapter.dart';
import 'package:libreta_domino/features/settings/data/adapters/settings.dart';
import 'package:libreta_domino/translations/data/adapters/app_localization_adapter.dart';
import 'package:libreta_domino/translations/data/adapters/translation_adapter.dart';
import 'package:libreta_domino/translations/data/model/app_localization.dart';
import 'package:libreta_domino/translations/data/model/translation.dart';

class Database {
  final Box<Game> gameBox;
  final Box<Settings> settingsBox;
  final Box<AppLocalization> localizationBox;

  Database({
    required this.gameBox,
    required this.settingsBox,
    required this.localizationBox,
  });

  static Future<Database> setup() async {
    final secureStorage = locator.get<FlutterSecureStorage>();
    final contains =
        await secureStorage.containsKey(key: Strings.encryptionKey);
    if (!contains) {
      final key = Hive.generateSecureKey();
      await secureStorage.write(
        key: Strings.encryptionKey,
        value: base64UrlEncode(key),
      );
    }
    var encryptionKeyString =
        await secureStorage.read(key: Strings.encryptionKey);
    final keyUInt8List = base64Url.decode(encryptionKeyString!);

    // Setup adapters
    if (!Hive.isAdapterRegistered(Constants.gameTypeId)) {
      Hive.registerAdapter(GameDataAdapter());
    }
    if (!Hive.isAdapterRegistered(Constants.settingsTypeId)) {
      Hive.registerAdapter(SettingsDataAdapter());
    }
    if (!Hive.isAdapterRegistered(Constants.translationsTypeId)) {
      Hive.registerAdapter(TranslationDataAdapter());
    }
    if (!Hive.isAdapterRegistered(Constants.appLocalizationsTypeId)) {
      Hive.registerAdapter(AppLocalizationAdapter());
    }

    // register database box
    final gameBox = await Hive.openBox<Game>(
      'games',
      encryptionCipher: HiveAesCipher(keyUInt8List),
    );
    final settingsBox = await Hive.openBox<Settings>(
      'settings',
      encryptionCipher: HiveAesCipher(keyUInt8List),
    );
    final appLocalization = await Hive.openBox<AppLocalization>(
      'appLocalization',
      encryptionCipher: HiveAesCipher(keyUInt8List),
    );

    if (settingsBox.isEmpty) {
      logger.i('>>> App first run. Added default settings');
      await settingsBox.add(Settings());
    }

    if (appLocalization.isEmpty && !locator.allowReassignment) {
      logger.i('>>> App first run. Added default localizations');
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

      appLocalization.flush();
    }

    logger.i('>>> Database setup completed!');
    return Database(
      gameBox: gameBox,
      settingsBox: settingsBox,
      localizationBox: appLocalization,
    );
  }

  void flush() async {
    await gameBox.flush();
    await settingsBox.flush();
    await localizationBox.flush();
  }
}
