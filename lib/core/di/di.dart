import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:libreta_domino/core/database/database.dart';
import 'package:libreta_domino/core/storage/web_storage.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart' as path;

final locator = GetIt.instance;

final Logger logger = locator.get<Logger>();

Future<void> setUpDependencyInjection() async {
  locator.registerSingleton(Logger());
  if (kIsWeb) {
    locator.registerSingleton<FlutterSecureStorage>(const WebSecureStorage());
  } else {
    locator.registerSingleton(const FlutterSecureStorage());
  }
  locator.registerFactoryAsync<Directory>(path.getTemporaryDirectory);
  locator.registerSingletonAsync<Database>(Database.setup);

  return await locator.allReady();
}
