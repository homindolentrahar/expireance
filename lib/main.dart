import 'package:expireance/common/theme/app_theme.dart';
import 'package:expireance/di/app_module.dart';
import 'package:expireance/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await AppModule.registerAdapters();
  await AppModule.openBoxes();

  AppModule.inject();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Expireance',
      theme: AppTheme.lightTheme,
      getPages: appRoutes,
      initialRoute: "/splash",
    );
  }
}
