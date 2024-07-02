// ignore_for_file: implementation_imports

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'package:intl/src/intl_helpers.dart';

/// This is a message lookup mechanism that delegates to one of a collection
/// of individual [MessageLookupByLibrary] instances.
class RestartableMessageLookup implements MessageLookup {
  /// A map from locale names to the corresponding lookups.
  Map<String, MessageLookupByLibrary> availableMessages = {};

  /// The last locale in which we looked up messages.
  ///
  ///  If this locale matches the new one then we can skip looking up the
  ///  messages and assume they will be the same as last time.
  String? _lastLocale;

  /// Caches the last messages that we found
  MessageLookupByLibrary? _lastLookup;

  /// Look up the message with the given [name] and [locale] and return the
  /// translated version with the values in [args] interpolated.  If nothing is
  /// found, return the result of [ifAbsent] or [messageText].
  @override
  String? lookupMessage(
    String? messageText,
    String? locale,
    String? name,
    List<Object>? args,
    String? meaning, {
    MessageIfAbsent? ifAbsent,
  }) {
    // If passed null, use the default.
    var knownLocale = locale ?? Intl.getCurrentLocale();
    var messages = (knownLocale == _lastLocale)
        ? _lastLookup
        : _lookupMessageCatalog(knownLocale);
    // If we didn't find any messages for this locale, use the original string,
    // faking interpolations if necessary.
    if (messages == null) {
      return ifAbsent == null ? messageText : ifAbsent(messageText, args);
    }
    return messages.lookupMessage(
      messageText,
      locale,
      name,
      args,
      meaning,
      ifAbsent: ifAbsent,
    );
  }

  /// Find the right message lookup for [locale].
  MessageLookupByLibrary? _lookupMessageCatalog(String locale) {
    var verifiedLocale = Intl.verifiedLocale(
      locale,
      (_) => false,
      onFailure: (locale) => locale,
    );
    _lastLocale = locale;
    _lastLookup = availableMessages[verifiedLocale];
    return _lastLookup;
  }

  @override
  void addLocale(String localeName, Function findLocale) {
    var canonical = Intl.canonicalizedLocale(localeName);
    var newLocale = findLocale.call(canonical);
    if (newLocale != null) {
      availableMessages[localeName] = newLocale;
      availableMessages[canonical] = newLocale;
      // If there was already a failed lookup for [newLocale], null the cache.
      if (_lastLocale == newLocale) {
        _lastLocale = null;
        _lastLookup = null;
      }
    }
  }
}
