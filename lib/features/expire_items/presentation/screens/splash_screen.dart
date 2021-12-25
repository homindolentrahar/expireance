import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
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
        Get.offAllNamed("/");
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
            "Exp",
            style: Get.textTheme.headline1,
          ),
        ),
      ),
    );
  }
}
