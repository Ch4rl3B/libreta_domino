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
import 'package:libreta_domino/translations/data/model/app_localization.dart';
import 'package:mockito/mockito.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../mocks/mocks.dart';
import '../di/di.dart';

void main() async {
  await setUpTestHive();
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFlutterSecureStorage secureStorage;

  setUpAll(setUpTestDependencyInjection);

  setUp(() {
    secureStorage =
        locator.get<FlutterSecureStorage>() as MockFlutterSecureStorage;
  });

  group('Database setup', () {
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
      when(secureStorage.containsKey(key: anyNamed('key')))
          .thenAnswer((_) async => false);

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
    late MockBox<AppLocalization> localizationBox;

    setUp(() {
      mockGameBox = MockBox<Game>();
      mockSettingsBox = MockBox<Settings>();
      localizationBox = MockBox<AppLocalization>();
    });

    test('should flush gameBox and settingsBox', () async {
      // Arrange
      final database = Database(
        gameBox: mockGameBox,
        settingsBox: mockSettingsBox,
        localizationBox: localizationBox,
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
