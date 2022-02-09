import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/core/presentation/widgets/buttons.dart';
import 'package:expireance/features/settings/presentation/application/settings_controller.dart';
import 'package:expireance/worker/notification_worker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsScreen extends StatelessWidget {
  static const route = "/settings";

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menus = [
      {
        'title': "Notification",
        'subtitle': "Will notify expired products in 7 upcoming days",
        'icon': "assets/icons/notification.svg",
        'activeIcon': "assets/icons/notification-ring.svg",
      },
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: const IconBackButton(),
          title: const Text("Settings"),
          centerTitle: false,
          titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        body: BlocBuilder<SettingsController, SettingsState>(
          bloc: context.read<SettingsController>()..fetchSettings(),
          builder: (ctx, state) => ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: menus.length,
            itemBuilder: (ctx, index) {
              final menu = menus[index];

              return InkWell(
                splashColor: AppColor.light,
                onTap: () {
                  if (state.enableNotification) {
                    NotificationWorker().cancelPeriodicTask();
                  } else {
                    NotificationWorker().registerPeriodicTask();
                  }

                  context
                      .read<SettingsController>()
                      .enableNotificationChanged(!state.enableNotification);
                  context.read<SettingsController>().updateSettings();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        state.enableNotification
                            ? menu['activeIcon']
                            : menu['icon'],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              menu['title'],
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              menu['subtitle'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(color: AppColor.gray),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Switch.adaptive(
                        value: state.enableNotification,
                        activeColor: Theme.of(context).primaryColor,
                        inactiveThumbColor: AppColor.gray,
                        inactiveTrackColor: AppColor.light,
                        onChanged: (value) {
                          if (state.enableNotification) {
                            NotificationWorker().cancelPeriodicTask();
                          } else {
                            NotificationWorker().registerPeriodicTask();
                          }

                          context
                              .read<SettingsController>()
                              .enableNotificationChanged(value);
                          context.read<SettingsController>().updateSettings();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
