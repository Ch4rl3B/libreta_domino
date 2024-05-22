import 'package:libreta_domino/core/interfaces/view_model_controller.dart';
import 'package:libreta_domino/features/settings/data/adapters/settings.dart';
import 'package:libreta_domino/features/settings/data/repository/settings_repository.dart';

class SettingsViewModel extends ViewModelController {
  final SettingsRepository repository;

  SettingsViewModel({
    this.repository = const SettingsRepository(),
  });

  Settings get settings => repository.fetch();

  bool get isLoading => busy(settings);

  @override
  void initialise() {
    // TODO: implement initialise
  }

  void changeLanguage(String code) async {
    runBusyFuture(
      Future.microtask(() async {
        await repository.save(
          settings.copyWith(
            locale: code,
          ),
        );
      }),
      busyObject: settings,
    );
  }

  void changeBrightness(int brightness) async {
    runBusyFuture(
      Future.microtask(() async {
        await repository.save(
          settings.copyWith(
            brightness: brightness,
          ),
        );
      }),
      busyObject: settings,
    );
  }

  void increaseText() async {
    if (settings.textScale >= 3.0) return;
    runBusyFuture(
      Future.microtask(() async {
        await repository.save(
          settings.copyWith(
            textScale: settings.textScale + 0.25,
          ),
        );
      }),
      busyObject: settings,
    );
  }

  void decreaseText() async {
    if (settings.textScale <= 0.75) return;
    runBusyFuture(
      Future.microtask(() async {
        await repository.save(
          settings.copyWith(
            textScale: settings.textScale - 0.25,
          ),
        );
      }),
      busyObject: settings,
    );
  }

  void restoreText() async {
    runBusyFuture(
      Future.microtask(() async {
        await repository.save(
          settings.copyWith(
            textScale: 1.0,
          ),
        );
      }),
      busyObject: settings,
    );
  }
}
