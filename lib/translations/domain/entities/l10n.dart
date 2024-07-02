// ignore_for_file: implementation_imports

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'package:intl/src/intl_helpers.dart';
import 'package:libreta_domino/translations/data/repository/translations_repository.dart';
import 'package:libreta_domino/translations/domain/entities/app_localization_delegate.dart';
import 'package:libreta_domino/translations/domain/entities/restartable_message_lookup.dart';

class L10n {
  final TranslationsRepository repository;
  L10n({
    this.repository = const TranslationsRepository(),
  });

  static L10n? _current;

  static L10n get current {
    assert(
      _current != null,
      'No instance of L10n was loaded. Try to initialize the L10n delegate before accessing L10n.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<L10n> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = L10n();
      L10n._current = instance;

      return instance;
    });
  }

  static L10n of(BuildContext context) {
    final instance = L10n.maybeOf(context);
    assert(
      instance != null,
      'No instance of L10n present in the widget tree. Did you add L10n.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static L10n? maybeOf(BuildContext context) {
    return Localizations.of<L10n>(context, L10n);
  }

  /// User programs should call this before using [localeName] for messages.
  static Future<bool> initializeMessages(String localeName) {
    final split = localeName.split('_');
    if (!delegate.isSupported(
      Locale.fromSubtags(
        languageCode: split[0].toLowerCase(),
        countryCode: split.length > 1 ? split[1] : null,
      ),
    )) {
      return SynchronousFuture(false);
    }
    initializeInternalMessageLookup(() => RestartableMessageLookup());
    messageLookup.addLocale(localeName, _findGeneratedMessagesFor);
    return SynchronousFuture(true);
  }

  static MessageLookupByLibrary? _findGeneratedMessagesFor(String locale) {
    return const TranslationsRepository().getTranslations(locale);
  }

  String translate(String key, [String? defaultMessage]) {
    return Intl.message(
      defaultMessage ?? key,
      name: key,
      desc: '',
      args: [],
    );
  }

  Future<bool> fetchTranslations() async {
    final response = await repository.fetchTranslations();
    if (response) {
      await load(
        Locale(Intl.defaultLocale!),
      );
    }
    return response;
  }

  void changeLocale(String code) {
    final split = code.split('_');
    if (delegate.isSupported(
      Locale.fromSubtags(
        languageCode: split[0].toLowerCase(),
        countryCode: split.length > 1 ? split[1] : null,
      ),
    )) {
      load(Locale(code));
    }
  }
}
