import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:audio_service/audio_service.dart';
import 'views/tab_view.dart';
import 'bindings/app_binding.dart';
import 'services/audio_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final audioHandler = await AudioService.init(
    builder: () => UbeeAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.ubee.app.channel.audio',
      androidNotificationChannelName: 'Ubee Audio',
    ),
  );

  Get.put(audioHandler);

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
