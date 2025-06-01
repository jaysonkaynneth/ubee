import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tab_controller.dart';
import '../theme/app_colors.dart';
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
          () => Scaffold(
            backgroundColor: AppColors.background,
            body: Obx(
              () => IndexedStack(
                index: controller.selectedIndex.value,
                children: const [HomeView(), SettingsView()],
              ),
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textSecondary.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTabItem(
                          icon: CupertinoIcons.home,
                          label: 'Home',
                          isSelected: controller.selectedIndex.value == 0,
                          onTap: () => controller.changeTab(0),
                        ),
                        _buildTabItem(
                          icon: CupertinoIcons.settings,
                          label: 'Settings',
                          isSelected: controller.selectedIndex.value == 1,
                          onTap: () => controller.changeTab(1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
