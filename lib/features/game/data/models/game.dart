import 'package:faker/faker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game.freezed.dart';
part 'game.g.dart';

@freezed
class Game with _$Game {
  const factory Game({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'teams') required List<String> teams,
    @JsonKey(name: 'startDate') required DateTime startDate,
    @JsonKey(name: 'limit') @Default(100) int limit,
    @JsonKey(name: 'scoreA') @Default([]) List<int> scoreA,
    @JsonKey(name: 'scoreB') @Default([]) List<int> scoreB,
    @JsonKey(name: 'finish') @Default(false) bool finish,
    @JsonKey(name: 'discarded') @Default(false) bool? discarded,
    @JsonKey(name: 'finishDate') DateTime? finishDate,
  }) = _Game;

  const Game._();

  factory Game.fromJson(Map<String, Object?> json) => _$GameFromJson(json);

  factory Game.placeholder() => Game(
        id: Faker().guid.guid(),
        teams: ["Team A", "Team B"],
        startDate: DateTime.now(),
      );
}
