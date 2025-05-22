import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'views/tab_view.dart';
import 'bindings/app_binding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetCupertinoApp(
      title: 'Ubee',
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.activeBlue,
        brightness: Brightness.light,
      ),
      initialBinding: AppBinding(),
      home: const TabView(),
    );
  }
}
