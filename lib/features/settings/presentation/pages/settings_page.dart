import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:libreta_domino/core/constants/strings.dart';
import 'package:libreta_domino/core/interfaces/view_model_page_builder.dart';
import 'package:libreta_domino/features/settings/presentation/viewModels/settings_view_model.dart';
import 'package:libreta_domino/features/splash/presentation/widgets/border_paper_fold.dart';
import 'package:libreta_domino/generated/l10n.dart';
import 'package:nb_utils/nb_utils.dart';

export 'package:libreta_domino/features/settings/presentation/viewModels/settings_view_model.dart';

@RoutePage()
class SettingsPage extends ViewModelPageBuilder<SettingsViewModel> {
  const SettingsPage({super.key, super.overrideViewModel});

  @override
  Widget builder(
    BuildContext context,
    SettingsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        shadowColor: Colors.transparent,
        title: Text(
          L10n.of(context).settingsPageLabel,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      backgroundColor: Theme.of(context).cardColor,
      body: Stack(
        children: [
          const Align(
            alignment: Alignment.bottomRight,
            child: BorderPaperFold(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 12.0,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    12.height,
                    Text(L10n.of(context).changeBrightness),
                    8.height,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          key: const Key(Strings.settingsLightButtonKey),
                          onPressed: viewModel.settings.brightness == 1
                              ? null
                              : () => viewModel.changeBrightness(1),
                          child: Text(L10n.of(context).lightBrightness),
                        ),
                        8.width,
                        TextButton(
                          key: const Key(Strings.settingsDarkButtonKey),
                          onPressed: viewModel.settings.brightness == 2
                              ? null
                              : () => viewModel.changeBrightness(2),
                          child: Text(L10n.of(context).darkBrightness),
                        ),
                      ],
                    ),
                    12.height,
                    Text(L10n.of(context).changeLanguage),
                    8.height,
                    Wrap(
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        TextButton(
                          key: const Key(Strings.settingsEsButtonKey),
                          onPressed: viewModel.settings.locale == 'es'
                              ? null
                              : () => viewModel.changeLanguage('es'),
                          child: Text(L10n.of(context).esLocale),
                        ),
                        8.width,
                        TextButton(
                          key: const Key(Strings.settingsEnButtonKey),
                          onPressed: viewModel.settings.locale == 'en'
                              ? null
                              : () => viewModel.changeLanguage('en'),
                          child: Text(L10n.of(context).enLocale),
                        ),
                        8.width,
                        TextButton(
                          key: const Key(Strings.settingsDeButtonKey),
                          onPressed: viewModel.settings.locale == 'de'
                              ? null
                              : () => viewModel.changeLanguage('de'),
                          child: Text(L10n.of(context).deLocale),
                        ),
                      ],
                    ),
                    12.height,
                    Text(L10n.of(context).textScale),
                    8.height,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          key: const Key(Strings.settingsDecrementButtonKey),
                          onPressed: viewModel.settings.textScale == 0.75
                              ? null
                              : viewModel.decreaseText,
                          child: const Text(' - '),
                        ),
                        8.width,
                        TextButton(
                          key: const Key(Strings.settingsIncrementButtonKey),
                          onPressed: viewModel.settings.textScale == 2.5
                              ? null
                              : viewModel.increaseText,
                          child: const Text(' + '),
                        ),
                      ],
                    ),
                    12.height,
                    TextButton(
                      key: const Key(Strings.settingsResetButtonKey),
                      onPressed: viewModel.restoreText,
                      child: Text(
                        L10n.of(context).restoreTextSize,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    12.height,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  SettingsViewModel viewModelBuilder(BuildContext context) {
    return overrideViewModel ?? SettingsViewModel();
  }

  @override
  bool get reactive => true;

  @override
  void onViewModelReady(SettingsViewModel viewModel) {
    return viewModel.initialise();
  }

  @override
  bool get disposeViewModel => true;
}
