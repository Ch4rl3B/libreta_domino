import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'package:libreta_domino/translations/domain/entities/restartable_message_lookup.dart';
import 'package:mockito/mockito.dart';

class MockMessageLookupByLibrary extends Mock
    implements MessageLookupByLibrary {}

void main() {
  late RestartableMessageLookup restartableMessageLookup;
  late MockMessageLookupByLibrary mockMessageLookupByLibrary;

  setUp(() {
    restartableMessageLookup = RestartableMessageLookup();
    mockMessageLookupByLibrary = MockMessageLookupByLibrary();
  });

  test('lookupMessage returns the correct message for a given locale', () {
    // Arrange
    const locale = 'en';
    const messageText = 'hello';
    const translatedText = 'Hello';
    restartableMessageLookup.availableMessages[locale] =
        mockMessageLookupByLibrary;
    when(mockMessageLookupByLibrary.lookupMessage(
            messageText, locale, any, any, any,
            ifAbsent: anyNamed('ifAbsent'),),)
        .thenReturn(translatedText);

    // Act
    final result = restartableMessageLookup.lookupMessage(
        messageText, locale, null, null, null,);

    // Assert
    expect(result, translatedText);
  });

  test('lookupMessage returns ifAbsent message when locale not found', () {
    // Arrange
    const locale = 'en';
    const messageText = 'hello';
    const ifAbsentMessage = 'Hello, default';
    String ifAbsent(String? messageText, List<Object>? args) => ifAbsentMessage;

    // Act
    final result = restartableMessageLookup.lookupMessage(
      messageText,
      locale,
      null,
      null,
      null,
      ifAbsent: ifAbsent,
    );

    // Assert
    expect(result, ifAbsentMessage);
  });

  test(
      'lookupMessage returns original message when locale not found and ifAbsent is null',
      () {
    // Arrange
    const locale = 'en';
    const messageText = 'hello';

    // Act
    final result = restartableMessageLookup.lookupMessage(
        messageText, locale, null, null, null,);

    // Assert
    expect(result, messageText);
  });

  test('addLocale adds a new locale and updates availableMessages', () {
    // Arrange
    const locale = 'en';
    when(mockMessageLookupByLibrary.lookupMessage(any, any, any, any, any))
        .thenReturn('Hello');
    MockMessageLookupByLibrary findLocale(String locale) =>
        mockMessageLookupByLibrary;

    // Act
    restartableMessageLookup.addLocale(locale, findLocale);

    // Assert
    expect(restartableMessageLookup.availableMessages[locale],
        mockMessageLookupByLibrary,);
    expect(
        restartableMessageLookup
            .availableMessages[Intl.canonicalizedLocale(locale)],
        mockMessageLookupByLibrary,);
  });
}
