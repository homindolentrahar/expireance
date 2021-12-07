import 'package:expireance/presentation/screens/expired_items_list.dart';
import 'package:expireance/presentation/screens/root.dart';
import 'package:expireance/presentation/screens/splash.dart';
import 'package:get/get.dart';

final appRoutes = [
  GetPage(
    name: "/splash",
    title: "Splash",
    page: () => const Splash(),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: "/",
    title: "Root",
    page: () => const Root(),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: "/expire-list",
    title: "Expire List",
    page: () => const ExpiredItemsList(),
    transition: Transition.cupertino,
  ),
];
