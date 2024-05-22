import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:libreta_domino/core/database/database.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart' as path;

final locator = GetIt.instance;

final Logger logger = locator.get<Logger>();

Future<void> setUpDependencyInjection() async {
  locator.registerSingleton(Logger());
  locator.registerSingleton(const FlutterSecureStorage());
  locator.registerFactoryAsync<Directory>(path.getTemporaryDirectory);
  locator.registerLazySingletonAsync<Database>(Database.setup);

  return await locator.allReady();
}
