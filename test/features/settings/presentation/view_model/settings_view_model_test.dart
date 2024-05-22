import 'package:flutter_test/flutter_test.dart';
import 'package:libreta_domino/features/settings/data/adapters/settings.dart';
import 'package:libreta_domino/features/settings/presentation/viewModels/settings_view_model.dart';
import 'package:mockito/mockito.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SettingsViewModel viewModel;
  late MockSettingsRepository mockSettingsRepository;

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    viewModel = SettingsViewModel(repository: mockSettingsRepository);

    // Setting up default values
    when(mockSettingsRepository.fetch()).thenReturn(Settings());
  });

  group('SettingsViewModel Tests', () {
    test('Initial settings are fetched correctly', () {
      // Assert
      expect(viewModel.settings.locale, 'en');
      expect(viewModel.settings.brightness, 1);
      expect(viewModel.settings.textScale, 1.0);
    });

    test('Change language updates settings', () async {
      // Act
      viewModel.changeLanguage('es');
      await Future.delayed(10.milliseconds);

      // Assert
      verify(mockSettingsRepository.save(any)).called(1);
    });

    test('Change brightness updates settings', () async {
      // Act
      viewModel.changeBrightness(2);
      await Future.delayed(10.milliseconds);

      // Assert
      verify(mockSettingsRepository.save(any)).called(1);
    });

    test('Increase text scale', () async {
      // Act
      viewModel.increaseText();
      await Future.delayed(10.milliseconds);

      // Assert
      verify(mockSettingsRepository.save(any)).called(1);
    });

    test('Do not increase text scale above limit', () async {
      // Arrange
      when(mockSettingsRepository.fetch()).thenReturn(
        Settings().copyWith(textScale: 3.0),
      );

      // Act
      viewModel.increaseText();
      await Future.delayed(10.milliseconds);

      // Assert
      verifyNever(mockSettingsRepository.save(any));
    });

    test('Decrease text scale', () async {
      // Act
      viewModel.decreaseText();
      await Future.delayed(10.milliseconds);

      // Assert
      verify(mockSettingsRepository.save(any)).called(1);
    });

    test('Do not decrease text scale below limit', () async {
      // Arrange
      when(mockSettingsRepository.fetch()).thenReturn(
        Settings().copyWith(textScale: 0.75),
      );

      // Act
      viewModel.decreaseText();
      await Future.delayed(10.milliseconds);

      // Assert
      verifyNever(mockSettingsRepository.save(any));
    });

    test('Restore text scale', () async {
      // Arrange
      when(mockSettingsRepository.fetch()).thenReturn(
        Settings().copyWith(textScale: 2.0),
      );

      // Act
      viewModel.restoreText();
      await Future.delayed(10.milliseconds);

      // Assert
      verify(mockSettingsRepository.save(any)).called(1);
    });
  });
}
