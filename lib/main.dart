import 'package:expireance/common/theme/app_theme.dart';
import 'package:expireance/core/services/notification_service.dart';
import 'package:expireance/di/app_module.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_category_repository.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_expire_repository.dart';
import 'package:expireance/features/expire_items/presentation/application/category_actor.dart';
import 'package:expireance/features/expire_items/presentation/application/category_watcher.dart';
import 'package:expireance/features/expire_items/presentation/application/expire_actor.dart';
import 'package:expireance/features/settings/domain/models/settings_model.dart';
import 'package:expireance/features/settings/domain/repositories/i_settings_repository.dart';
import 'package:expireance/features/settings/presentation/application/settings_controller.dart';
import 'package:expireance/routes/app_routes.dart';
import 'package:expireance/worker/notification_worker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workmanager/workmanager.dart';

final _appRouter = AppRouter();

void callbackDispatcher() {
  Workmanager().executeTask(
    (taskName, inputData) {
      debugPrint("Running work: $taskName");

      return NotificationService.scheduleNotification();
    },
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await AppModule.registerAdapters();
  await AppModule.openBoxes();

  AppModule.inject();

  //  Initialize & Register background task
  final settingsRepository = injector.get<ISettingsRepository>();
  final settings = settingsRepository.fetchSettings().fold(
        (_) => SettingsModel(enableNotification: false),
        (model) => model,
      );

  if (settings.enableNotification) {
    NotificationWorker().registerPeriodicTask();
  }

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
          value: CategoryActor(injector.get<ICategoryRepository>()),
        ),
        BlocProvider.value(
          value: ExpireActor(injector.get<IExpireRepository>()),
        ),
        BlocProvider.value(
          value: SettingsController(injector.get<ISettingsRepository>()),
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
