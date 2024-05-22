import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:libreta_domino/features/game/data/models/game.dart';

class GameDataAdapter extends TypeAdapter<Game> {
  static const int adapterId = 0;

  @override
  final typeId = adapterId;

  @override
  Game read(BinaryReader reader) {
    return Game.fromJson(jsonDecode(reader.readString()));
  }

  @override
  void write(BinaryWriter writer, Game obj) {
    writer.write(jsonEncode(obj.toJson()));
  }
}
