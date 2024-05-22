import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:libreta_domino/core/interfaces/view_model_page_builder.dart';
import 'package:libreta_domino/core/routes/app_router.dart';
import 'package:libreta_domino/features/splash/presentation/viewModels/splash_view_model.dart';
import 'package:nb_utils/nb_utils.dart';

export 'package:libreta_domino/features/splash/presentation/viewModels/splash_view_model.dart';

@RoutePage()
class SplashPage extends ViewModelPageBuilder<SplashViewModel> {
  const SplashPage({super.key});

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
              'Splash Page',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            8.height,
            TextButton(
              onPressed: () {
                router.replace(const GameConfigRoute());
              },
              child: const Text('To Game Config >'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget builder(
    BuildContext context,
    SplashViewModel viewModel,
    Widget? child,
  ) {
    return build(context);
  }

  @override
  SplashViewModel viewModelBuilder(BuildContext context) {
    return overrideViewModel ?? SplashViewModel();
  }

  @override
  bool get reactive => true;

  @override
  void onViewModelReady(SplashViewModel viewModel) {
    return viewModel.initialise();
  }

  @override
  bool get disposeViewModel => true;
}
