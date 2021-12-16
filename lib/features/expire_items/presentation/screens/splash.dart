import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
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
