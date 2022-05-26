import 'package:expireance/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

class SplashScreen extends StatefulWidget {
  static const route = "/splash";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    //  Delay the splash
    Future.delayed(
      const Duration(milliseconds: 2500),
      () {
        context.router.replace(const ExpireRoute());
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text(
            "Expireance",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
