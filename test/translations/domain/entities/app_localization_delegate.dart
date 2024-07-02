import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hive_test/hive_test.dart';
import 'package:libreta_domino/core/database/database.dart';
import 'package:libreta_domino/translations/domain/entities/app_localization_delegate.dart';
import 'package:libreta_domino/translations/domain/entities/message_lookup.dart';
import 'package:mockito/mockito.dart';

import '../../../core/di/di.dart';
import '../../values.dart';

// Mock for MessageLookup
class MockMessageLookup extends Mock implements MessageLookup {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await setUpTestHive();
    await setUpTestDependencyInjection();

    final appLocalizations = appLocalizationWithValue.copyWith(
      data: [
        translationWithData,
        translationWithData.copyWith(
          id: 'es_testKey',
          locale: 'es',
        ),
      ],
    );

    final box = locator.get<Database>().localizationBox;
    await box.put(appLocalizations.version, appLocalizations);
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  group('AppLocalizationDelegate', () {
    const delegate = AppLocalizationDelegate();

    test('isSupported returns true for supported locales', () {
      expect(delegate.isSupported(const Locale('en')), isTrue);
      expect(delegate.isSupported(const Locale('es')), isTrue);
    });

    test('isSupported returns false for unsupported locales', () {
      expect(delegate.isSupported(const Locale('fr')), isFalse);
    });

    test('shouldReload returns false', () {
      expect(delegate.shouldReload(delegate), isFalse);
    });

    test('load loads the correct localization', () async {
      final localization = await delegate.load(const Locale('en'));

      expect(localization.translate('test'), 'test');
    });
  });
}
