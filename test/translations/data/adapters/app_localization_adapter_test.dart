import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:libreta_domino/translations/data/model/app_localization.dart';

import '../../../core/di/di.dart';
import '../../values.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await setUpTestHive();
    await setUpTestDependencyInjection();
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  test('when saving AppLocalization object is stored in the hive box',
      () async {
    // Arrange
    final box = await Hive.openBox<AppLocalization>('appLocalizationsBox');
    expect(box.isOpen, isTrue);
    final appLocalization = appLocalizationWithValue;

    // Act
    await box.put(appLocalization.version, appLocalization);

    // Assert
    expect(box.values.length, 1);
    expect(box.values.first, appLocalization);
  });

  test('when reading AppLocalization object is read from the hive box',
      () async {
    // Arrange
    final box = await Hive.openBox<AppLocalization>('appLocalizationsBox');
    final appLocalization = appLocalizationWithValue;
    await box.put(appLocalization.version, appLocalization);
    // Act
    final retrievedLocalization = box.get(appLocalization.version);

    // Assert
    expect(retrievedLocalization, appLocalization);
  });

  test('when updating AppLocalization object is updated in the hive box',
      () async {
    // Arrange
    final box = await Hive.openBox<AppLocalization>('appLocalizationsBox');
    final appLocalization = appLocalizationWithValue;
    final updatedLocalization = appLocalization.copyWith(
      version: 2,
    );

    // Act
    box.put(appLocalization.version, updatedLocalization);

    // Assert
    expect(box.values.length, 1);
    expect(box.values.first, updatedLocalization);
  });
}
