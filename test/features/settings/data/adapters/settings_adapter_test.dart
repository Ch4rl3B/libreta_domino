import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:libreta_domino/core/database/database.dart';
import 'package:libreta_domino/core/di/di.dart';
import 'package:libreta_domino/features/settings/data/adapters/settings.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks/method_channels.dart';
import '../../../../mocks/mocks.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockLogger logger;
  late MockFlutterSecureStorage secureStorage;
  late Database database;

  setUpAll(setupMethodChannels);

  setUp(() async {
    await setUpTestHive();

    logger = MockLogger();
    secureStorage = MockFlutterSecureStorage();

    locator.allowReassignment = true;
    locator.registerSingleton<Logger>(logger);
    locator.registerSingleton<FlutterSecureStorage>(secureStorage);

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

    database = await Database.setup();
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  test('when saving settings object is store in the hive box', () async {
    // Arrange
    expect(database.settingsBox.isOpen, isTrue);
    final settings = Settings();

    // Act
    database.settingsBox.add(settings);

    // Assert
    expect(database.settingsBox.values.length, 1);
    expect(database.settingsBox.values.first, settings);
  });

  test('when update settings object is updated in the hive box', () async {
    // Arrange
    expect(database.settingsBox.isOpen, isTrue);
    final settings = Settings();
    final updated = settings.copyWith(
      locale: 'en',
      brightness: 0,
      textScale: 24,
    );

    // Act
    database.settingsBox.add(settings);
    database.settingsBox.putAt(0, updated);

    // Assert
    expect(database.settingsBox.values.length, 1);
    expect(database.settingsBox.values.first, updated);
  });
}
