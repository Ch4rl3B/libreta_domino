import 'dart:convert';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:libreta_domino/core/database/database.dart';
import 'package:libreta_domino/translations/data/model/app_localization.dart';
import 'package:libreta_domino/translations/data/model/translation.dart';
import 'package:libreta_domino/translations/data/repository/translations_repository.dart';
import 'package:libreta_domino/translations/domain/entities/message_lookup.dart';
import 'package:mockito/mockito.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/di/di.dart';
import '../../../mocks/mocks.dart';

class MockParseCloudFunction extends Mock implements ParseCloudFunction {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Database database;
  late Box<AppLocalization> localizationsBox;
  late TranslationsRepository translationsRepository;

  setUp(() async {
    await setUpTestHive();
    await setUpTestDependencyInjection();

    database = locator.get<Database>();
    localizationsBox = database.localizationBox;

    final translations = [
      const Translation(
        id: 'en_hello',
        locale: 'en',
        key: 'hello',
        value: 'Hello',
      ),
      const Translation(
        id: 'es_hello',
        locale: 'es',
        key: 'hello',
        value: 'Hola',
      ),
      const Translation(
        id: 'en_US_color',
        locale: 'en_US',
        key: 'color',
        value: 'Color',
      ),
    ];
    final appLocalization = AppLocalization(data: translations);
    await localizationsBox.put(appLocalization.version, appLocalization);
    await localizationsBox.flush();

    translationsRepository = const TranslationsRepository();
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  test('supportedLocales returns list of supported locales', () async {
    // Act
    final locales = translationsRepository.supportedLocales();

    // Assert
    expect(
      locales,
      contains(
        const Locale('en'),
      ),
    );
    expect(
      locales,
      contains(
        const Locale('es'),
      ),
    );
    expect(
      locales,
      contains(
        const Locale.fromSubtags(
          languageCode: 'en',
          countryCode: 'US',
        ),
      ),
    );
  });

  test('translate returns correct translation for given locale and key', () {
    // Act
    final translation = translationsRepository.translate(
      'es',
      'hello',
    );

    // Assert
    expect(translation, 'Hola');
  });

  test('getTranslations returns MessageLookupByLibrary for given locale', () {
    // Act
    final lookup = translationsRepository.getTranslations('es');

    // Assert
    expect(lookup, isNotNull);
    expect(lookup!.localeName, 'es');
    expect(
      (lookup as MessageLookup).messageList.first.value,
      'Hola',
    );
  });

  group('fetchTranslations', () {
    final parseClient = MockParseClient();
    setUp(() async {
      await initializeMockedParse(parseClient);
    });

    test('fetches and updates translations', () async {
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

      // Act
      final result = await translationsRepository.fetchTranslations();

      // Assert
      expect(result, isTrue);
      final updatedLocalization = localizationsBox.get(2);
      expect(updatedLocalization, isNotNull);
      expect(updatedLocalization!.data.first.value, 'Hi');
    });

    test('if the version does not changed do not update translations',
        () async {
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

      // Act
      final result = await translationsRepository.fetchTranslations();

      // Assert
      expect(result, isFalse);
      final updatedLocalization = localizationsBox.values.first;
      expect(updatedLocalization, isNotNull);
      expect(updatedLocalization.data.first.value, 'Hello');
    });

    test('if there is an error do not update translations', () async {
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

      // Act
      final result = await translationsRepository.fetchTranslations();

      // Assert
      expect(result, isFalse);
      final updatedLocalization = localizationsBox.values.first;
      expect(updatedLocalization, isNotNull);
      expect(updatedLocalization.data.first.value, 'Hello');
    });
  });
}
