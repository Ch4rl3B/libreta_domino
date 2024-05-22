import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:libreta_domino/core/database/database.dart';
import 'package:libreta_domino/core/di/di.dart';
import 'package:libreta_domino/features/settings/data/adapters/settings.dart';

class SettingsRepository {
  Box<Settings> get database => locator.get<Database>().settingsBox;

  const SettingsRepository();

  Future<void> save(Settings settings) async {
    await database.putAt(0, settings);
  }

  Settings fetch() {
    return database.values.first;
  }

  ValueListenable<Box<Settings>> listenable() {
    return database.listenable(keys: [0]);
  }
}
