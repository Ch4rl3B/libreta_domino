import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:libreta_domino/core/constants/constants.dart';
import 'package:libreta_domino/translations/data/model/app_localization.dart';
import 'package:libreta_domino/translations/data/model/translation.dart';

class AppLocalizationAdapter extends TypeAdapter<AppLocalization> {
  @override
  final typeId = Constants.appLocalizationsTypeId;

  @override
  AppLocalization read(BinaryReader reader) {
    final mainClass = jsonDecode(reader.read());
    final translations = reader.read() as List;
    return AppLocalization.fromJson(mainClass).copyWith(
      data: translations.map((e) => e as Translation).toList(),
    );
  }

  @override
  void write(BinaryWriter writer, AppLocalization obj) {
    writer.write(jsonEncode(obj.toJson()));
    writer.write(obj.data);
  }
}
