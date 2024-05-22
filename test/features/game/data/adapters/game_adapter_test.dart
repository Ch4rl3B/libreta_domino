import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:libreta_domino/core/database/database.dart';
import 'package:libreta_domino/core/di/di.dart';
import 'package:libreta_domino/features/game/data/adapters/game.dart';
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

  test('when saving game object is store in the hive box', () async {
    // Arrange
    expect(database.gameBox.isOpen, isTrue);
    final game = Game.placeholder();

    // Act
    database.gameBox.put(game.id, game);

    // Assert
    expect(database.gameBox.values.length, 1);
    expect(database.gameBox.values.first, game);
  });

  test('when update game object is updated in the hive box', () async {
    // Arrange
    expect(database.gameBox.isOpen, isTrue);
    final game = Game.placeholder();
    final updated = game.copyWith(
      finish: true,
      finishDate: DateTime.now(),
    );

    // Act
    database.gameBox.put(game.id, game);
    database.gameBox.put(game.id, updated);

    // Assert
    expect(database.gameBox.values.length, 1);
    expect(database.gameBox.values.first.finish, true);
  });
}
