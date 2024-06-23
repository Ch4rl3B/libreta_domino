import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:libreta_domino/core/database/database.dart';
import 'package:libreta_domino/core/di/di.dart';
import 'package:libreta_domino/features/libreta_domino.dart';
import 'package:libreta_domino/features/settings/data/adapters/settings.dart';
import 'package:nb_utils/nb_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    initialize(),
    Hive.initFlutter(),
    initializeParse(),
  ]);
  await setUpDependencyInjection();

  runApp(
    ValueListenableBuilder<Box<Settings>>(
      valueListenable: locator.get<Database>().settingsBox.listenable(),
      builder: (context, box, _) {
        final settings = box.getAt(0)!;
        return LibretaDomino(settings: settings);
      },
    ),
  );
}
