import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:libreta_domino/core/interfaces/view_model_page_builder.dart';
import 'package:libreta_domino/features/game/presentation/viewModels/game_view_model.dart';

export 'package:libreta_domino/features/game/presentation/viewModels/game_view_model.dart';

@RoutePage()
class GamePage extends ViewModelPageBuilder<GameViewModel> {
  final String gameId;
  const GamePage({
    @PathParam('id') required this.gameId,
    super.key,
  });

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
          'Game Page',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }

  @override
  Widget builder(BuildContext context, GameViewModel viewModel, Widget? child) {
    return build(context);
  }

  @override
  GameViewModel viewModelBuilder(BuildContext context) {
    return overrideViewModel ?? GameViewModel();
  }

  @override
  bool get reactive => true;

  @override
  void onViewModelReady(GameViewModel viewModel) {
    return viewModel.initialise();
  }

  @override
  bool get disposeViewModel => true;
}
