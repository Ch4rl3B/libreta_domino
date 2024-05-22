import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:libreta_domino/core/constants/constants.dart';
import 'package:libreta_domino/features/game/data/adapters/game.dart';

class GameDataAdapter extends TypeAdapter<Game> {
  @override
  final typeId = Constants.gameTypeId;

  @override
  Game read(BinaryReader reader) {
    return Game.fromJson(jsonDecode(reader.readString()));
  }

  @override
  void write(BinaryWriter writer, Game obj) {
    writer.write(jsonEncode(obj.toJson()));
  }
}
