import 'package:expireance/features/expire_items/presentation/screens/category_screen.dart';
import 'package:expireance/features/expire_items/presentation/screens/search_screen.dart';
import 'package:expireance/features/expire_items/presentation/screens/priority_expire_screen.dart';
import 'package:expireance/features/expire_items/presentation/screens/root_screen.dart';
import 'package:expireance/features/expire_items/presentation/screens/splash_screen.dart';
import 'package:get/get.dart';

final appRoutes = [
  GetPage(
    name: "/splash",
    title: "Splash",
    page: () => const SplashScreen(),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: RootScreen.route,
    title: "Root",
    page: () => const RootScreen(),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: PriorityExpireScreen.route,
    title: "Expire List",
    page: () => const PriorityExpireScreen(),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: CategoryScreen.route,
    title: "Category",
    page: () => const CategoryScreen(),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: "/search",
    title: "Search",
    page: () => const SearchScreen(),
    transition: Transition.cupertino,
  ),
];
