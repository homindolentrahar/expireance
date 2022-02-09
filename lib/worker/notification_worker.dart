import 'package:expireance/common/constants/work_manager_constants.dart';
import 'package:expireance/main.dart';
import 'package:workmanager/workmanager.dart';

class NotificationWorker {
  NotificationWorker() {
    Workmanager().initialize(callbackDispatcher);
  }

  final Constraints constraints = Constraints(
    networkType: NetworkType.not_required,
    requiresBatteryNotLow: true,
    requiresCharging: false,
    requiresDeviceIdle: false,
    requiresStorageNotLow: false,
  );

  void registerPeriodicTask() {
    Workmanager().registerPeriodicTask(
      WorkMangerConstants.notificationUniqueName,
      WorkMangerConstants.notificationTaskName,
      // frequency: const Duration(days: 1),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: constraints,
    );
  }

  void cancelPeriodicTask() {
    Workmanager().cancelByUniqueName(
      WorkMangerConstants.notificationUniqueName,
    );
  }
}
