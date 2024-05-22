import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:libreta_domino/core/interfaces/view_model_page_builder.dart';
import 'package:libreta_domino/features/history/presentation/viewModels/history_view_model.dart';

export 'package:libreta_domino/features/history/presentation/viewModels/history_view_model.dart';

@RoutePage()
class HistoryPage extends ViewModelPageBuilder<HistoryViewModel> {
  const HistoryPage({super.key});

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
          'History Page',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }

  @override
  Widget builder(
    BuildContext context,
    HistoryViewModel viewModel,
    Widget? child,
  ) {
    return build(context);
  }

  @override
  HistoryViewModel viewModelBuilder(BuildContext context) {
    return overrideViewModel ?? HistoryViewModel();
  }

  @override
  bool get reactive => true;

  @override
  void onViewModelReady(HistoryViewModel viewModel) {
    return viewModel.initialise();
  }

  @override
  bool get disposeViewModel => true;
}
