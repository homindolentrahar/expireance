import 'package:expireance/common/constants/box_constants.dart';
import 'package:expireance/common/constants/notification_constants.dart';
import 'package:expireance/di/app_module.dart';
import 'package:expireance/features/expire_items/data/local/expire_item_entity.dart';
import 'package:expireance/features/expire_items/data/repositories/expire_repository.dart';
import 'package:expireance/features/expire_items/domain/models/expire_item_model.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_expire_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<bool> scheduleNotification() async {
    await Hive.initFlutter();
    await AppModule.registerAdapters();
    await AppModule.openBoxes();

    final box = Hive.box<ExpireItemEntity>(BoxConstants.expireItemBox);
    final lostDataBox = Hive.box<String>(BoxConstants.lostDataBox);

    injector.registerLazySingleton<IExpireRepository>(
      () => ExpireRepository(
        box: box,
        lostDataBox: lostDataBox,
      ),
    );

    await NotificationService().init();
    await NotificationService().showNotification();

    return Future.value(true);
  }

  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> showNotification() async {
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
  }

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notif_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {},
    );
  }
}
