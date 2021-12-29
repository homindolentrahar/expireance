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
    ];

    return Container(
      width: 264,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Expirance",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
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
                    context.router.replaceNamed("/${menus[index].slug}");

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
