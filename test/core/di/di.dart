import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:libreta_domino/core/database/database.dart';
import 'package:libreta_domino/core/di/di.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider/path_provider.dart' as path;

import '../../mocks/mocks.dart';

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
