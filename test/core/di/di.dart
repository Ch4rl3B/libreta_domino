import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:libreta_domino/core/database/database.dart';
import 'package:libreta_domino/core/di/di.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;

import '../../mocks/mocks.dart';

export 'package:libreta_domino/core/di/di.dart';

Future<void> setUpTestDependencyInjection() async {
  locator.allowReassignment = true;
  locator.registerSingleton<Logger>(MockLogger());
  final secureStorage = MockFlutterSecureStorage();
  locator.registerSingleton<FlutterSecureStorage>(secureStorage);
  locator.registerFactoryAsync<Directory>(path.getTemporaryDirectory);

  when(
    logger.i(
      any,
      time: anyNamed('time'),
      error: anyNamed('error'),
      stackTrace: anyNamed('stackTrace'),
    ),
  ).thenReturn(null);

  final encryptionKey = Hive.generateSecureKey();
  final encryptionKeyString = base64UrlEncode(encryptionKey);

  when(secureStorage.read(key: anyNamed('key')))
      .thenAnswer((_) => Future<String?>.value(encryptionKeyString));
  when(secureStorage.containsKey(key: anyNamed('key')))
      .thenAnswer((_) async => true);

  locator.registerSingletonAsync<Database>(Database.setup);

  return await locator.allReady();
}

Future<Parse> initializeMockedParse(ParseClient client) async {
  final mockStore = MockCoreStoreSharedPreferences();
  when(mockStore.getStringList(any)).thenAnswer((_) async => null);
  return await Parse().initialize(
    'b4aApplicationId',
    'b4aParseServerUrl',
    clientKey: 'b4aClientKey',
    debug: true,
    autoSendSessionId: true,
    appName: 'Translations',
    appVersion: '1.0.0',
    appPackageName: 'de.ch4rl3b.libretadomino',
    coreStore: mockStore,
    fileDirectory: '',
    clientCreator: ({
      required bool sendSessionId,
      SecurityContext? securityContext,
    }) =>
        client,
  );
}
