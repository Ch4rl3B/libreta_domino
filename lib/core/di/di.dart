import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart' as path;

final locator = GetIt.instance;

final Logger logger = locator.get<Logger>();

Future<void> setUpDependencyInjection() async {
  locator.registerSingleton(Logger());
  locator.registerFactoryAsync<Directory>(path.getTemporaryDirectory);

  return await locator.allReady();
}
