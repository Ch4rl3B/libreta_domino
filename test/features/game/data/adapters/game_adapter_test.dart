import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:libreta_domino/core/database/database.dart';
import 'package:libreta_domino/features/game/data/adapters/game.dart';

import '../../../../core/di/di.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Database database;

  setUp(() async {
    await setUpTestHive();
    await setUpTestDependencyInjection();

    database = locator.get<Database>();
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  test('when saving game object is store in the hive box', () async {
    // Arrange
    expect(database.gameBox.isOpen, isTrue);
    final game = Game.placeholder();

    // Act
    database.gameBox.put(game.id, game);

    // Assert
    expect(database.gameBox.values.length, 1);
    expect(database.gameBox.values.first, game);
  });

  test('when update game object is updated in the hive box', () async {
    // Arrange
    expect(database.gameBox.isOpen, isTrue);
    final game = Game.placeholder();
    final updated = game.copyWith(
      finish: true,
      finishDate: DateTime.now(),
    );

    // Act
    database.gameBox.put(game.id, game);
    database.gameBox.put(game.id, updated);

    // Assert
    expect(database.gameBox.values.length, 1);
    expect(database.gameBox.values.first.finish, true);
  });
}
