import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:libreta_domino/core/di/di.dart';
import 'package:libreta_domino/core/routes/app_router.dart';
import 'package:libreta_domino/core/styles/app_colors.dart';
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
    return MaterialApp.router(
      key: appKey,
      title: 'LibretaDomino',
      theme: ThemeData(
        primarySwatch: AppColors.primarySwatch,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        primarySwatch: AppColors.primarySwatch,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      // ignore: deprecated_member_use
      useInheritedMediaQuery: widget.enableDevicePreview,
      localizationsDelegates: const [
        L10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.delegate.supportedLocales,
      locale: const Locale('es'),
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      debugShowCheckedModeBanner: false,
      restorationScopeId: restorationId,
      builder: (context, child) {
        return finalWidget(child);
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
