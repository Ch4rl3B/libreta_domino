import 'package:hive_flutter/hive_flutter.dart';
import 'package:libreta_domino/core/database/database.dart';
import 'package:libreta_domino/core/di/di.dart';
import 'package:libreta_domino/features/settings/data/adapters/settings.dart';

class SplashRepository {
  Box<Settings> get database => locator.get<Database>().settingsBox;

  const SplashRepository();

  Future<void> updateLocale(String locale) async {
    final settings = database.getAt(0);

    await database.putAt(
      0,
      settings!.copyWith(
        locale: locale,
      ),
    );
  }
}
