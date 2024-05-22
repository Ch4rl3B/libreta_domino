import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:libreta_domino/features/settings/data/adapters/settings.dart';
import 'package:libreta_domino/features/settings/data/repository/settings_repository.dart';

import '../../../../core/di/di.dart';
import '../../../../mocks/method_channels.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(setupMethodChannels);

  setUp(() async {
    await setUpTestHive();

    await setUpTestDependencyInjection();
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  group('when fetch', () {
    test('gets settings value', () {
      // Arrange
      final settings = Settings();
      const sut = SettingsRepository();

      // Act
      final fetch = sut.fetch();

      // Assert
      expect(fetch, isNotNull);
      expect(fetch, settings);
    });
  });

  group('when save', () {
    test('the previous settings are overwrite', () async {
      // Arrange
      final settings = Settings();
      final newSettings = settings.copyWith(locale: 'es');
      const sut = SettingsRepository();

      // Assert
      expect(sut.fetch(), settings);

      // Act
      await sut.save(newSettings);
      final fetch = sut.fetch();

      // Assert
      expect(fetch, isNotNull);
      expect(fetch, newSettings);
      expect(fetch.locale, 'es');
    });
  });

  group('when listen to the value listenable', () {
    test('on a modification gets notified', () async {
      // Arrange
      final settings = Settings();
      final newSettings = settings.copyWith(locale: 'es');
      const sut = SettingsRepository();

      ValueListenable<Box<Settings>>? listenable;
      Box<Settings>? listened;

      void onData() {
        listened = listenable?.value;
      }

      // Act
      listenable = sut.listenable();
      listenable.addListener(onData);

      await sut.save(newSettings);

      // Assert
      expect(listened, isNotNull);
      expect(listened!.values.first, newSettings);
    });
  });
}
