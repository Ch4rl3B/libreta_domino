import 'package:libreta_domino/core/di/di.dart';
import 'package:libreta_domino/core/routes/app_router.dart';
import 'package:stacked/stacked.dart';

abstract class ViewModelController extends BaseViewModel {
  AppRouter get appRouter => locator.get<AppRouter>();
  void initialise();
}
