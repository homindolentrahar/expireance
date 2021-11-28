import 'package:expireance/constants/box_constants.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await openBoxes();

  runApp(const MyApp());
}

Future<void> openBoxes() async {
  Hive.openBox(BoxConstants.EXPIRE_ITEMS_BOX);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Expireance',
      home: Root(),
    );
  }
}

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Text("Hello there 👋🏼"),
        ),
      ),
    );
  }
}
