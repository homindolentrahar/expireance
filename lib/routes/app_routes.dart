import 'package:auto_route/auto_route.dart';
import 'package:expireance/features/expire_items/presentation/screens/category_screen.dart';
import 'package:expireance/features/expire_items/presentation/screens/search_screen.dart';
import 'package:expireance/features/expire_items/presentation/screens/priority_expire_screen.dart';
import 'package:expireance/features/expire_items/presentation/screens/root_screen.dart';
import 'package:expireance/features/expire_items/presentation/screens/splash_screen.dart';
import 'package:flutter/widgets.dart';

part 'app_routes.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: "Screen,Route",
  routes: <AutoRoute>[
    AutoRoute(page: SplashScreen, initial: true, path: SplashScreen.route),
    AutoRoute(page: RootScreen, path: RootScreen.route),
    AutoRoute(page: PriorityExpireScreen, path: PriorityExpireScreen.route),
    AutoRoute(page: CategoryScreen, path: CategoryScreen.route),
    AutoRoute(page: SearchScreen, path: SearchScreen.route),
  ],
)
class AppRouter extends _$AppRouter {}