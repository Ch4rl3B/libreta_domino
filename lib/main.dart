import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:libreta_domino/core/di/di.dart';
import 'package:libreta_domino/features/libreta_domino.dart';
import 'package:nb_utils/nb_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    initialize(),
    Hive.initFlutter(),
  ]);
  await setUpDependencyInjection();

  runApp(const LibretaDomino());
}
