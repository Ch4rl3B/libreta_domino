import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:libreta_domino/core/constants/strings.dart';
import 'package:libreta_domino/features/settings/presentation/pages/settings_page.dart';
import 'package:libreta_domino/features/splash/presentation/widgets/border_paper_fold.dart';
import 'package:libreta_domino/translations/domain/entities/l10n.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../core/di/di.dart';
import '../../../../mocks/method_channels.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, String>{});

  late SettingsViewModel viewModel;

  setUpAll(() async {
    setupMethodChannels();

    var tempDir = Directory.systemTemp.createTempSync();
    Hive.init(tempDir.path);

    await Future.wait([
      initialize(),
    ]);
    await setUpTestDependencyInjection();
  });

  setUp(() {
    viewModel = SettingsViewModel();
  });

  Future<void> pumpSettingsPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [L10n.delegate],
        home: SettingsPage(
          overrideViewModel: viewModel,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SettingsPage displays correctly', (WidgetTester tester) async {
    await pumpSettingsPage(tester);

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.byType(BorderPaperFold), findsOneWidget);
    expect(find.text('Change Brightness'), findsOneWidget);
    expect(find.text('Change Language'), findsOneWidget);
    expect(find.text('Text Scale'), findsOneWidget);
    expect(find.text('Restore Text Size'), findsOneWidget);
  });

  testWidgets('Change brightness buttons work correctly',
      (WidgetTester tester) async {
    await pumpSettingsPage(tester);

    // Initially light is enabled and dark is disabled
    final lightButton = find.byKey(
      const Key(Strings.settingsLightButtonKey),
    );
    final darkButton = find.byKey(
      const Key(Strings.settingsDarkButtonKey),
    );

    expect(lightButton.evaluate().first.widget is TextButton, isTrue);
    expect(
      (lightButton.evaluate().first.widget as TextButton).enabled,
      isFalse,
    );
    expect(darkButton.evaluate().first.widget is TextButton, isTrue);
    expect((darkButton.evaluate().first.widget as TextButton).enabled, isTrue);

    // Tap the Dark button
    await tester.tap(darkButton);
    await tester.pumpAndSettle();

    // Now light should be enabled and dark should be disabled
    expect((lightButton.evaluate().first.widget as TextButton).enabled, isTrue);
    expect((darkButton.evaluate().first.widget as TextButton).enabled, isFalse);
  });

  testWidgets('Change language buttons work correctly',
      (WidgetTester tester) async {
    await pumpSettingsPage(tester);

    final esButton = find.byKey(
      const Key(Strings.settingsEsButtonKey),
    );
    final enButton = find.byKey(
      const Key(Strings.settingsEnButtonKey),
    );
    final deButton = find.byKey(
      const Key(Strings.settingsDeButtonKey),
    );

    // Initially English is disabled
    expect(
      (enButton.evaluate().first.widget as TextButton).enabled,
      isFalse,
    );

    // Tap the Spanish button
    await tester.tap(esButton);
    await tester.pumpAndSettle();

    // Now Spanish should be disabled and English and German should be enabled
    expect(
      (enButton.evaluate().first.widget as TextButton).enabled,
      isTrue,
    );
    expect(
      (deButton.evaluate().first.widget as TextButton).enabled,
      isTrue,
    );
    expect(
      (esButton.evaluate().first.widget as TextButton).enabled,
      isFalse,
    );

    // Tap the German button
    await tester.tap(deButton);
    await tester.pumpAndSettle();

    // Now German should should be disabled and English and Spanish should be enabled
    expect(
      (esButton.evaluate().first.widget as TextButton).enabled,
      isTrue,
    );
    expect(
      (enButton.evaluate().first.widget as TextButton).enabled,
      isTrue,
    );
    expect(
      (deButton.evaluate().first.widget as TextButton).enabled,
      isFalse,
    );

    // Tap the German button
    await tester.tap(enButton);
    await tester.pumpAndSettle();

    // Now English should be disabled and German and Spanish should be enabled
    expect(
      (esButton.evaluate().first.widget as TextButton).enabled,
      isTrue,
    );
    expect(
      (deButton.evaluate().first.widget as TextButton).enabled,
      isTrue,
    );
    expect(
      (enButton.evaluate().first.widget as TextButton).enabled,
      isFalse,
    );
  });

  testWidgets('Text scale buttons work correctly', (WidgetTester tester) async {
    await pumpSettingsPage(tester);

    final incrementButton = find.byKey(
      const Key(Strings.settingsIncrementButtonKey),
    );
    final decrementButton = find.byKey(
      const Key(Strings.settingsDecrementButtonKey),
    );

    // Initially text scale is at default value
    expect(
      (decrementButton.evaluate().first.widget as TextButton).enabled,
      isTrue,
    );
    expect(
      (incrementButton.evaluate().first.widget as TextButton).enabled,
      isTrue,
    );

    // Tap the increase text button
    await tester.tap(incrementButton);
    await tester.pumpAndSettle();

    // Text scale should be increased
    expect(viewModel.settings.textScale, greaterThan(1.0));

    // Tap the decrease text button
    await tester.tap(decrementButton);
    await tester.pumpAndSettle();

    // Text scale should be back to default
    expect(viewModel.settings.textScale, equals(1.0));
  });

  testWidgets('Restore text scale button works correctly',
      (WidgetTester tester) async {
    await pumpSettingsPage(tester);

    final incrementButton = find.byKey(
      const Key(Strings.settingsIncrementButtonKey),
    );

    final restoreButton = find.byKey(
      const Key(Strings.settingsResetButtonKey),
    );

    // Change text scale
    await tester.tap(incrementButton);
    await tester.pumpAndSettle();
    expect(viewModel.settings.textScale, greaterThan(1.0));

    // Tap the restore text scale button
    await tester.tap(restoreButton);
    await tester.pumpAndSettle();

    // Text scale should be restored to default
    expect(viewModel.settings.textScale, equals(1.0));
  });
}
