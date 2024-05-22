import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:libreta_domino/core/interfaces/view_model_page_builder.dart';
import 'package:libreta_domino/features/settings/presentation/viewModels/settings_view_model.dart';

export 'package:libreta_domino/features/settings/presentation/viewModels/settings_view_model.dart';

@RoutePage()
class SettingsPage extends ViewModelPageBuilder<SettingsViewModel> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      body: Center(
        child: Text(
          'Settings Page',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }

  @override
  Widget builder(
    BuildContext context,
    SettingsViewModel viewModel,
    Widget? child,
  ) {
    return build(context);
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
