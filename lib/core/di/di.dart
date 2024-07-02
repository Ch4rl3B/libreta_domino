import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:libreta_domino/core/database/database.dart';
import 'package:libreta_domino/core/storage/web_storage.dart';
import 'package:libreta_domino/generated/secrets.dart';
import 'package:logger/logger.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
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

Future<void> initializeParse() async {
  await Parse().initialize(
    Secrets.b4aApplicationId,
    Secrets.b4aParseServerUrl,
    clientKey: Secrets.b4aClientKey,
    debug: true,
    autoSendSessionId: true,
    appName: 'Translations',
    coreStore: await CoreStoreSharedPreferences.getInstance(),
    clientCreator: ({
      required bool sendSessionId,
      SecurityContext? securityContext,
    }) =>
        ParseDioClient(
      sendSessionId: sendSessionId,
      securityContext: securityContext,
    ),
  );
}
