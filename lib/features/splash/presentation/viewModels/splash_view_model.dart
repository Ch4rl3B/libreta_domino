import 'package:intl/intl.dart';
import 'package:libreta_domino/core/interfaces/view_model_controller.dart';
import 'package:libreta_domino/features/splash/data/repository/splash_repository.dart';
import 'package:libreta_domino/translations/domain/entities/l10n.dart';

class SplashViewModel extends ViewModelController {
  static const String loading = 'loading';

  final SplashRepository splashRepository;

  SplashViewModel({
    this.splashRepository = const SplashRepository(),
  });

  bool get isLoading => busy(loading);

  @override
  void initialise() {
    runBusyFuture(fetchTranslations(), busyObject: loading);
    setInitialised(true);
  }

  Future<void> fetchTranslations() async {
    final context = appRouter.navigatorKey.currentContext!;
    if (await L10n.of(context).fetchTranslations()) {
      splashRepository.updateLocale(Intl.defaultLocale ?? Intl.systemLocale);
    }
  }
}
