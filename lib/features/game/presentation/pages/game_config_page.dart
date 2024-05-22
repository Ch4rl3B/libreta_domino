import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:libreta_domino/core/interfaces/view_model_page_builder.dart';
import 'package:libreta_domino/core/routes/app_router.dart';
import 'package:libreta_domino/features/game/presentation/viewModels/game_config_view_model.dart';
import 'package:nb_utils/nb_utils.dart';

export 'package:libreta_domino/features/game/presentation/viewModels/game_config_view_model.dart';

@RoutePage()
class GameConfigPage extends ViewModelPageBuilder<GameConfigViewModel> {
  const GameConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Game Config Page',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            8.height,
            TextButton(
              onPressed: () {
                router
                    .push(GameRoute(gameId: '123456789-1234-1234-12345678912'));
              },
              child: const Text('To Game >'),
            ),
            4.height,
            TextButton(
              onPressed: () {
                router.push(const HistoryRoute());
              },
              child: const Text('To History >'),
            ),
            4.height,
            TextButton(
              onPressed: () {
                router.push(const SettingsRoute());
              },
              child: const Text('To Settings >'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget builder(
      BuildContext context, GameConfigViewModel viewModel, Widget? child) {
    return build(context);
  }

  @override
  GameConfigViewModel viewModelBuilder(BuildContext context) {
    return overrideViewModel ?? GameConfigViewModel();
  }

  @override
  bool get reactive => true;

  @override
  void onViewModelReady(GameConfigViewModel viewModel) {
    return viewModel.initialise();
  }

  @override
  bool get disposeViewModel => true;
}
