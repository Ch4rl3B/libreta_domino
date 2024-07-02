import 'package:flutter_test/flutter_test.dart';
import 'package:libreta_domino/translations/domain/entities/message_lookup.dart';

import '../../values.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('get localeName returns correct', () {
    final messageLookup = MessageLookup('en', [translationWithData]);

    expect(messageLookup.localeName, 'en');
  });
  test('get message returns correct', () {
    final messageLookup = MessageLookup('en', [translationWithData]);

    expect(messageLookup.messages.keys.first, 'testKey');
  });

  group('MessageLookup', () {
    test('lookupMessage returns correct message', () {
      final messageLookup = MessageLookup('en', [translationWithData]);

      expect(
        messageLookup.lookupMessage(
          'testKey',
          'en',
          null,
          [],
          null,
        ),
        'testValue',
      );
    });
  });
}
