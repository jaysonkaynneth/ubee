import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controllers/tab_controller.dart';
import 'home_view.dart';
import 'settings_view.dart';

class TabView extends GetView<TabViewController> {
  const TabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TabViewController>(
      init: TabViewController(),
      builder: (controller) {
        return Obx(
          () => CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              currentIndex: controller.selectedIndex.value,
              onTap: controller.changeTab,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.settings),
                  label: 'Settings',
                ),
              ],
            ),
            tabBuilder: (context, index) {
              switch (index) {
                case 0:
                  return CupertinoTabView(
                    builder: (context) => const HomeView(),
                  );
                case 1:
                  return CupertinoTabView(
                    builder: (context) => const SettingsView(),
                  );
                default:
                  return CupertinoTabView(
                    builder: (context) => const HomeView(),
                  );
              }
            },
          ),
        );
      },
    );
  }
}
