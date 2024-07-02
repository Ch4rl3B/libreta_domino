import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:libreta_domino/core/database/database.dart';
import 'package:libreta_domino/translations/domain/entities/l10n.dart';
import 'package:libreta_domino/translations/domain/entities/message_lookup.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/di/di.dart';
import '../../../mocks/mocks.dart';
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
          value: 'valorPrueba',
        ),
      ],
    );

    final box = locator.get<Database>().localizationBox;
    await box.put(appLocalizations.version, appLocalizations);
  });

  test('supportedLocales returns correct list of locales', () {
    final supportedLocales = L10n.delegate.supportedLocales;
    expect(supportedLocales, contains(const Locale('en')));
    expect(supportedLocales, contains(const Locale('es')));
  });

  test('load loads the correct localization', () async {
    final localization = await L10n.load(const Locale('en'));

    expect(localization.translate('testKey'), 'testValue');
  });

  group('test for translate method', () {
    test('translate the message correct', () async {
      final localization = await L10n.load(const Locale('en'));

      final response = localization.translate('testKey');

      expect(response, 'testValue');
    });

    test('return default value if message is not found', () async {
      final localization = await L10n.load(const Locale('en'));

      final response = localization.translate('invalidKey', 'defaultMessage');

      expect(response, 'defaultMessage');
    });

    test('return the key if message is not found and default not provided',
        () async {
      final localization = await L10n.load(const Locale('en'));

      final response = localization.translate('invalidKey');

      expect(response, 'invalidKey');
    });
  });

  group('test for fetch translations method', () {
    final parseClient = MockParseClient();
    setUp(() async {
      await initializeMockedParse(parseClient);
    });

    test('return true if a new version is fetch', () async {
      // Arrange
      final responseMap = {
        "appId": "libretadomino",
        "version": 2,
        "data": [
          {
            "id": "en_hello",
            "locale": "en",
            "key": "hello",
            "value": "Hi",
            "pluralize": false,
            "parametrized": false,
            "parameterKeys": "",
          },
        ],
      };
      when(
        parseClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => ParseNetworkResponse(
          data: jsonEncode(responseMap),
          statusCode: 200,
        ),
      );
      final localization = await L10n.load(const Locale('en'));

      // Act
      final response = await localization.fetchTranslations();

      expect(response, true);
    });

    test('return false if there is not a new version', () async {
      // Arrange
      final responseMap = {
        "appId": "libretadomino",
        "version": 1,
        "data": [],
      };
      when(
        parseClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => ParseNetworkResponse(
          data: jsonEncode(responseMap),
          statusCode: 200,
        ),
      );
      final localization = await L10n.load(const Locale('en'));

      // Act
      final response = await localization.fetchTranslations();

      expect(response, false);
    });

    test('return false if there was an error', () async {
      // Arrange
      when(
        parseClient.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => ParseNetworkResponse(
          data: 'error',
          statusCode: 500,
        ),
      );
      final localization = await L10n.load(const Locale('en'));

      // Act
      final response = await localization.fetchTranslations();

      expect(response, false);
    });
  });

  test('change locale loads the correct localization', () async {
    final localization = await L10n.load(const Locale('en'));

    localization.changeLocale('es');

    expect(localization.translate('testKey'), 'valorPrueba');
  });

  test('change locale does not work with invalid locale', () async {
    final localization = await L10n.load(const Locale('en'));

    localization.changeLocale('fr');

    expect(localization.translate('testKey'), 'testValue');
  });
}
