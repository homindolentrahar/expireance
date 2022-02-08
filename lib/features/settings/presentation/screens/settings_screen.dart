import 'package:expireance/common/theme/app_color.dart';
import 'package:expireance/core/presentation/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsScreen extends StatefulWidget {
  static const route = "/settings";

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool active = false;

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
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          itemCount: menus.length,
          itemBuilder: (ctx, index) {
            final menu = menus[index];

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  active ? menu['activeIcon'] : menu['icon'],
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
                  value: active,
                  activeColor: Theme.of(context).primaryColor,
                  inactiveThumbColor: AppColor.gray,
                  inactiveTrackColor: AppColor.light,
                  onChanged: (value) {
                    setState(() {
                      active = !active;
                    });
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
