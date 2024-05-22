import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:libreta_domino/core/database/database.dart';
import 'package:libreta_domino/core/di/di.dart';
import 'package:libreta_domino/core/routes/app_router.dart';
import 'package:libreta_domino/core/styles/app_color_schemes.dart';
import 'package:libreta_domino/features/settings/data/adapters/settings.dart';
import 'package:libreta_domino/generated/l10n.dart';
import 'package:nb_utils/nb_utils.dart';

class LibretaDomino extends StatefulWidget {
  final bool enableDevicePreview;

  const LibretaDomino({super.key, this.enableDevicePreview = false});

  @override
  State<LibretaDomino> createState() => _LibretaDominoState();
}

class _LibretaDominoState extends State<LibretaDomino> with RestorationMixin {
  Key appKey = UniqueKey();
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(navigatorKey);
    locator.registerSingleton(_appRouter);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Settings>>(
      valueListenable: locator.get<Database>().settingsBox.listenable(),
      builder: (context, box, _) {
        final settings = box.values.firstOrNull;
        return MaterialApp.router(
          key: appKey,
          title: 'LibretaDomino',
          theme: ThemeData.from(
            colorScheme: ColorSchemes.light,
            useMaterial3: true,
          ),
          darkTheme: ThemeData.from(
            colorScheme: ColorSchemes.dark,
            useMaterial3: true,
          ),
          themeMode: ThemeMode.values[settings?.brightness ?? 0],
          localizationsDelegates: const [
            L10n.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: L10n.delegate.supportedLocales,
          locale: Locale(box.values.firstOrNull?.locale ?? 'en'),
          routerDelegate: _appRouter.delegate(),
          routeInformationParser: _appRouter.defaultRouteParser(),
          debugShowCheckedModeBanner: false,
          restorationScopeId: restorationId,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(settings?.textScale ?? 1.0),
              ),
              child: finalWidget(child),
            );
          },
        );
      },
    );
  }

  Widget finalWidget(Widget? child) {
    return child ?? Container();
  }

  @override
  String? get restorationId => 'lido';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {}
}
