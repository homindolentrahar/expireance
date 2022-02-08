import 'package:auto_route/auto_route.dart';
import 'package:expireance/features/expire_items/presentation/screens/category_screen.dart';
import 'package:expireance/features/expire_items/presentation/screens/filtered_expire_screen.dart';
import 'package:expireance/features/expire_items/presentation/screens/search_expire_screen.dart';
import 'package:expireance/features/expire_items/presentation/screens/priority_expire_screen.dart';
import 'package:expireance/features/expire_items/presentation/screens/expire_screen.dart';
import 'package:expireance/features/expire_items/presentation/screens/splash_screen.dart';
import 'package:expireance/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/widgets.dart';

part 'app_routes.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: "Screen,Route",
  routes: <AutoRoute>[
    AutoRoute(page: SplashScreen, initial: true, path: SplashScreen.route),
    AutoRoute(page: ExpireScreen, path: ExpireScreen.route),
    AutoRoute(page: PriorityExpireScreen, path: PriorityExpireScreen.route),
    AutoRoute(page: FilteredExpireScreen, path: FilteredExpireScreen.route),
    AutoRoute(page: SearchExpireScreen, path: SearchExpireScreen.route),
    AutoRoute(page: CategoryScreen, path: CategoryScreen.route),
    AutoRoute(page: SettingsScreen, path: SettingsScreen.route),
  ],
)
class AppRouter extends _$AppRouter {}
