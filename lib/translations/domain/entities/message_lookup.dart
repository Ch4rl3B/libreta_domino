import 'package:intl/message_lookup_by_library.dart';
import 'package:libreta_domino/translations/data/model/translation.dart';

class MessageLookup extends MessageLookupByLibrary {
  final String _locale;
  final List<Translation> messageList;

  MessageLookup(this._locale, this.messageList);

  @override
  String get localeName => _locale;

  @override
  Map<String, dynamic> get messages => _notInlinedMessages(_notInlinedMessages);

  Map<String, Function> _notInlinedMessages(_) =>
      Map<String, Function>.fromEntries(
        messageList.map(
          (msg) => MapEntry(
            msg.key,
            MessageLookupByLibrary.simpleMessage(msg.value),
          ),
        ),
      );
}
