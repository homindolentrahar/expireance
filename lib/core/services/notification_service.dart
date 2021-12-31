import 'package:expireance/common/constants/notification_constant.dart';
import 'package:expireance/di/app_module.dart';
import 'package:expireance/features/expire_items/domain/models/expire_item_model.dart';
import 'package:expireance/features/expire_items/domain/repositories/i_expire_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> scheduleDailyNotification() async {
    const channel = AndroidNotificationDetails(
      NotificationConstant.priorityItemNotificationID,
      NotificationConstant.priorityItemNotificationName,
      channelDescription: NotificationConstant.priorityItemNotificationDesc,
      importance: Importance.high,
      priority: Priority.high,
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
        : "${priorityExpireItems.length} items need your concern";
    final message = priorityExpireItems.isEmpty
        ? "You don't have any items that will expire in a meantime"
        : "Please take necessary action before it goes waste";

    const id = 001;
    await flutterLocalNotificationsPlugin.periodicallyShow(
      id,
      title,
      message,
      RepeatInterval.daily,
      notification,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notif_icon');

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: null,
    );

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        //  Handle the callback of notification
      },
    );
  }
}
