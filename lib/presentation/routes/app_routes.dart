import 'package:expireance/presentation/screens/root.dart';
import 'package:expireance/presentation/screens/splash.dart';
import 'package:get/get.dart';

final appRoutes = [
  GetPage(
    name: "/splash",
    title: "Splash",
    page: () => const Splash(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: "/",
    title: "Root",
    page: () => const Root(),
    transition: Transition.rightToLeftWithFade,
  ),
];
