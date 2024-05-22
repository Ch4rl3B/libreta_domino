import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:libreta_domino/core/constants/strings.dart';
import 'package:libreta_domino/core/database/database.dart';
import 'package:libreta_domino/core/di/di.dart';
import 'package:libreta_domino/features/game/data/adapters/game.dart';
import 'package:libreta_domino/features/settings/data/adapters/settings.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../mocks/method_channels.dart';
import '../../mocks/mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockLogger logger;
  late MockFlutterSecureStorage secureStorage;

  setUpAll(setupMethodChannels);

  setUp(() {
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
  });

  group('Database setup', () {
    setUp(() async {
      await setUpTestHive();
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    test('should setup Database with encryption key', () async {
      // Arrange
      final encryptionKey = Hive.generateSecureKey();
      final encryptionKeyString = base64UrlEncode(encryptionKey);

      when(secureStorage.read(key: anyNamed('key')))
          .thenAnswer((_) => Future<String?>.value(encryptionKeyString));

      // Act
      final database = await Database.setup();

      // Assert
      expect(database.gameBox.isOpen, isTrue);
      expect(database.settingsBox.isOpen, isTrue);

      verify(secureStorage.read(key: Strings.encryptionKey));
    });

    test('should generate and save encryption key if not exists', () async {
      // Arrange
      when(secureStorage.read(key: anyNamed('key')))
          .thenAnswer((_) async => null);

      when(
        secureStorage.write(
          key: anyNamed('key'),
          value: anyNamed('value'),
        ),
      ).thenAnswer((_) => Future.value());

      // Act
      final database = await Database.setup();

      // Assert
      expect(database.gameBox.isOpen, isTrue);
      expect(database.settingsBox.isOpen, isTrue);

      verify(secureStorage.read(key: Strings.encryptionKey)).called(1);
      verify(
        secureStorage.write(
          key: Strings.encryptionKey,
          value: anyNamed('value'),
        ),
      );
    });
  });

  group('flush changes', () {
    late MockBox<Game> mockGameBox;
    late MockBox<Settings> mockSettingsBox;

    setUp(() {
      mockGameBox = MockBox<Game>();
      mockSettingsBox = MockBox<Settings>();
    });

    test('should flush gameBox and settingsBox', () async {
      // Arrange
      final database = Database(
        gameBox: mockGameBox,
        settingsBox: mockSettingsBox,
      );

      // Act
      database.flush();
      await Future.delayed(1.seconds);

      // Assert
      verify(mockGameBox.flush()).called(1);
      verify(mockSettingsBox.flush()).called(1);
    });
  });
}
