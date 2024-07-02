import 'dart:async';

import 'package:flutter/material.dart';
import 'package:libreta_domino/translations/data/repository/translations_repository.dart';
import 'package:libreta_domino/translations/domain/entities/l10n.dart';

class AppLocalizationDelegate extends LocalizationsDelegate<L10n> {
  final TranslationsRepository repository;

  const AppLocalizationDelegate({
    this.repository = const TranslationsRepository(),
  });

  List<Locale> get supportedLocales => repository.supportedLocales();

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<L10n> load(Locale locale) => L10n.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
