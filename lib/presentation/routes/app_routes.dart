import 'package:expireance/domain/repositories/i_expire_repository.dart';
import 'package:expireance/presentation/controller/expire/expire_search_controller.dart';
import 'package:expireance/presentation/screens/expired_list.dart';
import 'package:expireance/presentation/screens/root.dart';
import 'package:expireance/presentation/screens/search.dart';
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
    name: "/expired-list",
    title: "Expire List",
    page: () => const ExpiredList(),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: "/search",
    title: "Search",
    page: () => const Search(),
    binding: BindingsBuilder(() => {
          Get.put<ExpireSearchController>(
            ExpireSearchController(
              expireRepository: Get.find<IExpireRepository>(),
            ),
          )
        }),
    transition: Transition.cupertino,
  ),
];
