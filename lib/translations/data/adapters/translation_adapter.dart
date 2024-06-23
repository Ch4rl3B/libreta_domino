import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:libreta_domino/core/constants/constants.dart';
import 'package:libreta_domino/translations/data/model/translation.dart';

class TranslationDataAdapter extends TypeAdapter<Translation> {
  @override
  final typeId = Constants.translationsTypeId;

  @override
  Translation read(BinaryReader reader) {
    final mainCLass = jsonDecode(reader.read());
    return Translation.fromJson(mainCLass);
  }

  @override
  void write(BinaryWriter writer, Translation obj) {
    writer.write(jsonEncode(obj.toJson()));
  }
}
