import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:libreta_domino/core/database/database.dart';
import 'package:libreta_domino/core/di/di.dart';
import 'package:libreta_domino/features/settings/data/adapters/settings.dart';

import '../../../../core/di/di.dart';
import '../../../../mocks/method_channels.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Database database;

  setUpAll(setupMethodChannels);

  setUp(() async {
    await setUpTestHive();

    await setUpTestDependencyInjection();

    database = locator.get<Database>();
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  test('when saving settings object is store in the hive box', () async {
    // Arrange
    expect(database.settingsBox.isOpen, isTrue);
    final settings = Settings();

    // Act
    database.settingsBox.putAt(0, settings);

    // Assert
    expect(database.settingsBox.values.length, 1);
    expect(database.settingsBox.values.first, settings);
  });

  test('when update settings object is updated in the hive box', () async {
    // Arrange
    expect(database.settingsBox.isOpen, isTrue);
    final settings = Settings();
    final updated = settings.copyWith(
      locale: 'en',
      brightness: 0,
      textScale: 24,
    );

    // Act
    database.settingsBox.putAt(0, updated);

    // Assert
    expect(database.settingsBox.values.length, 1);
    expect(database.settingsBox.values.first, updated);
  });
}
