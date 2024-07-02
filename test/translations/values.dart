import 'package:libreta_domino/translations/data/model/app_localization.dart';
import 'package:libreta_domino/translations/data/model/translation.dart';

Translation get translationWithData => const Translation(
      id: 'testKey_en',
      locale: 'en',
      key: 'testKey',
      value: 'testValue',
    );

AppLocalization get appLocalizationWithValue => AppLocalization(
      version: 1,
      data: [translationWithData],
    );
