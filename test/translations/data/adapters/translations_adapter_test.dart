import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:libreta_domino/translations/data/model/translation.dart';

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

  test('when saving Translation object is stored in the hive box', () async {
    // Arrange
    final box = await Hive.openBox<Translation>('translationsBox');
    expect(box.isOpen, isTrue);
    final translation = translationWithData;

    // Act
    box.put(translation.id, translation);

    // Assert
    expect(box.values.length, 1);
    expect(box.values.first, translation);
  });

  test('when reading Translation object is read from the hive box', () async {
    // Arrange
    final box = await Hive.openBox<Translation>('translationsBox');
    final translation = translationWithData;

    await box.put(translation.id, translation);

    // Act
    final retrievedTranslation = box.get(translation.id);

    // Assert
    expect(retrievedTranslation, translation);
  });

  test('when updating Translation object is updated in the hive box', () async {
    // Arrange
    final box = await Hive.openBox<Translation>('translationsBox');
    final translation = translationWithData;

    final updatedTranslation = translation.copyWith(
      value: 'Updated value',
    );
    await box.put(translation.id, translation);

    // Act
    box.put(translation.id, updatedTranslation);

    // Assert
    expect(box.values.length, 1);
    expect(box.values.first, updatedTranslation);
  });
}
