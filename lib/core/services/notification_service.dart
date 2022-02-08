import 'package:expireance/common/constants/box_constants.dart';
import 'package:expireance/common/constants/notification_constants.dart';
import 'package:expireance/di/app_module.dart';
import 'package:expireance/features/expire_items/data/local/expire_item_entity.dart';
import 'package:expireance/features/expire_items/data/repositories/expire_repository.dart';
import 'package:expireance/features/expire_items/domain/models/expire_item_model.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_expire_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;

enum NotificationType { once, periodic }

Future<bool> scheduleNotification() async {
  await Hive.initFlutter();
  await AppModule.registerAdapters();
  await AppModule.openBoxes();

  final box = Hive.box<ExpireItemEntity>(BoxConstants.expireItemBox);

  injector.registerLazySingleton<IExpireRepository>(
    () => ExpireRepository(box: box),
  );

  await NotificationService().init();
  await NotificationService().showNotification();

  return Future.value(true);
}

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> showNotification({
    NotificationType type = NotificationType.once,
    Duration duration = const Duration(days: 1),
  }) async {
    //  Creating notification
    const channel = AndroidNotificationDetails(
      NotificationConstant.priorityItemNotificationID,
      NotificationConstant.priorityItemNotificationName,
      channelDescription: NotificationConstant.priorityItemNotificationDesc,
      tag: NotificationConstant.priorityItemNotificationTag,
      importance: Importance.high,
      priority: Priority.high,
      enableLights: true,
      playSound: true,
      icon: "notif_icon",
    );

    const notification = NotificationDetails(android: channel);

    // Getting data
    final result = injector.get<IExpireRepository>().fetchPriorityExpireItems();
    final priorityExpireItems = result.fold(
      (error) => <ExpireItemModel>[],
      (success) => success,
    );

    final title = priorityExpireItems.isEmpty
        ? "Just Relax!"
        : priorityExpireItems.length > 1
            ? "${priorityExpireItems.length} items need your concern"
            : "${priorityExpireItems[0].name} need your concern";
    final message = priorityExpireItems.isEmpty
        ? "You don't have any items that will expire in a meantime"
        : "Please take necessary action before it goes waste";

    const id = 001;

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      message,
      notification,
    );

    if (type == NotificationType.once) {
      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        message,
        notification,
      );
    } else if (type == NotificationType.periodic) {
      await flutterLocalNotificationsPlugin.periodicallyShow(
        id,
        title,
        message,
        RepeatInterval.daily,
        notification,
        androidAllowWhileIdle: true,
      );
    } else {
      debugPrint("Notification type unavailable!!!");
      return;
    }
  }

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notif_icon');

    //  IOS Usage
    //
    // const IOSInitializationSettings initializationSettingsIOS =
    //     IOSInitializationSettings(
    //   requestSoundPermission: false,
    //   requestBadgePermission: false,
    //   requestAlertPermission: false,
    // );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS,
    );

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        //  Handle the callback of notification
        //  Navigate to PriorityExpireScreen
      },
    );
  }
}
