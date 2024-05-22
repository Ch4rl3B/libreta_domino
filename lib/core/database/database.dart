import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:libreta_domino/core/constants/constants.dart';
import 'package:libreta_domino/core/constants/strings.dart';
import 'package:libreta_domino/core/di/di.dart';
import 'package:libreta_domino/features/game/data/adapters/game_data_adapter.dart';
import 'package:libreta_domino/features/game/data/adapters/game.dart';
import 'package:libreta_domino/features/settings/data/adapters/settings.dart';

class Database {
  final Box<Game> gameBox;
  final Box<Settings> settingsBox;

  Database._({
    required this.gameBox,
    required this.settingsBox,
  });

  static Future<Database> setup() async {
    final secureStorage = locator.get<FlutterSecureStorage>();
    var encryptionKeyString =
        await secureStorage.read(key: Strings.encryptionKey);
    if (encryptionKeyString == null) {
      final key = Hive.generateSecureKey();
      encryptionKeyString = base64UrlEncode(key);
      await secureStorage.write(
        key: Strings.encryptionKey,
        value: encryptionKeyString,
      );
    }
    final keyUInt8List = base64Url.decode(encryptionKeyString);

    // Setup adapters
    if (!Hive.isAdapterRegistered(Constants.gameTypeId)) {
      Hive.registerAdapter(GameDataAdapter());
    }
    if (!Hive.isAdapterRegistered(Constants.settingsTypeId)) {
      Hive.registerAdapter(SettingsDataAdapter());
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

    logger.i('>>> Database setup completed!');
    return Database._(
      gameBox: gameBox,
      settingsBox: settingsBox,
    );
  }
}
