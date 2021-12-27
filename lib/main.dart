import 'package:expireance/common/theme/app_theme.dart';
import 'package:expireance/di/app_module.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_category_repository.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_expire_repository.dart';
import 'package:expireance/features/expire_items/presentation/application/category_watcher.dart';
import 'package:expireance/features/expire_items/presentation/application/expire_actor.dart';
import 'package:expireance/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

final _appRouter = AppRouter();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: CategoryWatcher(injector.get<ICategoryRepository>()),
        ),
        BlocProvider.value(
          value: ExpireActor(injector.get<IExpireRepository>()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: true,
        title: 'Expireance',
        theme: AppTheme.lightTheme,
        routerDelegate: _appRouter.delegate(),
        routeInformationParser: _appRouter.defaultRouteParser(),
        localizationsDelegates: const [
          FormBuilderLocalizations.delegate,
          RefreshLocalizations.delegate,
        ],
      ),
    );
  }
}
