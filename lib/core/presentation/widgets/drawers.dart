import 'package:expireance/common/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_route/auto_route.dart';

class RootDrawer extends StatelessWidget {
  const RootDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menus = <DrawerMenuModel>[
      DrawerMenuModel(
        "assets/icons/expire-items.svg",
        "expire",
        "Expire",
      ),
      DrawerMenuModel(
        "assets/icons/category.svg",
        "category",
        "Category",
      ),
      DrawerMenuModel(
        "assets/icons/setting.svg",
        "settings",
        "Settings",
      ),
    ];

    return Container(
      width: 264,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColor.light,
                  width: 1.3,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "assets/logo-dark.png",
                    width: 32,
                    height: 32,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Expireance",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: menus.length,
              itemBuilder: (ctx, index) {
                final currentRoute = context.router.current.path;
                final activeRoute = "/${menus[index].slug}" == currentRoute;

                return DrawerTiles(
                  icon: menus[index].icon,
                  title: menus[index].title,
                  isActive: activeRoute,
                  onTap: () {
                    //  Navigate somewhere with slug
                    context.router.pushNamed("/${menus[index].slug}");

                    context.router.pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerMenuModel {
  final String icon;
  final String slug;
  final String title;

  DrawerMenuModel(this.icon, this.slug, this.title);
}

class DrawerTiles extends StatelessWidget {
  final String icon;
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const DrawerTiles({
    Key? key,
    required this.icon,
    required this.title,
    this.isActive = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColor.light,
        child: Container(
          padding: const EdgeInsets.all(16),
          color: isActive ? Theme.of(context).primaryColor : Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                color: isActive
                    ? Theme.of(context).canvasColor
                    : Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      color: isActive
                          ? Theme.of(context).canvasColor
                          : Theme.of(context).primaryColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
