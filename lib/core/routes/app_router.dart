import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:libreta_domino/core/di/di.dart';
import 'package:libreta_domino/features/game/presentation/pages/game_config_page.dart';
import 'package:libreta_domino/features/game/presentation/pages/game_page.dart';
import 'package:libreta_domino/features/history/presentation/pages/history_page.dart';
import 'package:libreta_domino/features/settings/presentation/pages/settings_page.dart';
import 'package:libreta_domino/features/splash/presentation/pages/splash_page.dart';

part 'app_router.gr.dart';

AppRouter get router => locator.get<AppRouter>();

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  AppRouter([
    GlobalKey<NavigatorState>? navigatorKey,
  ]) : super(navigatorKey: navigatorKey);

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true, path: '/'),
        AutoRoute(page: GameRoute.page, path: '/game/:id'),
        AutoRoute(page: GameConfigRoute.page, path: '/game'),
        AutoRoute(page: SettingsRoute.page, path: '/settings'),
        AutoRoute(page: HistoryRoute.page, path: '/history'),
      ];
}
