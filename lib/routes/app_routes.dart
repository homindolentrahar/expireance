import 'package:expireance/features/expire_items/domain/repositories/i_category_repository.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_expire_repository.dart';
import 'package:expireance/features/expire_items/presentation/controllers/expire_search_controller.dart';
import 'package:expireance/features/expire_items/presentation/screens/category_screen.dart';
import 'package:expireance/features/expire_items/presentation/controllers/expire_controller.dart';
import 'package:expireance/features/expire_items/presentation/screens/search.dart';
import 'package:expireance/features/expire_items/presentation/screens/expired_list.dart';
import 'package:expireance/features/expire_items/presentation/screens/root.dart';
import 'package:expireance/features/expire_items/presentation/screens/splash.dart';
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
    binding: BindingsBuilder(() {
      Get.put<ExpireController>(
        ExpireController(
          expireRepository: Get.find<IExpireRepository>(),
          categoryRepository: Get.find<ICategoryRepository>(),
        ),
      );
    }),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: "/expired-list",
    title: "Expire List",
    page: () => const ExpiredList(),
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
    page: () => const Search(),
    binding: BindingsBuilder(() {
      Get.lazyPut<ExpireSearchController>(
        () => ExpireSearchController(
          expireRepository: Get.find<IExpireRepository>(),
        ),
      );
    }),
    transition: Transition.cupertino,
  ),
];
