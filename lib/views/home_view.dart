import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show ReorderableListView;
import 'package:get/get.dart';
import '../controllers/form_controller.dart';
import '../widgets/download_item_card.dart';
import '../theme/app_colors.dart';
import 'add_modal_view.dart';

class HomeView extends GetView<FormController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CupertinoPageScaffold(
        backgroundColor: AppColors.background,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: AppColors.background,
          middle: Text('Home', style: TextStyle(color: AppColors.textPrimary)),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.add, color: AppColors.primary),
            onPressed: () => _showAddModal(),
          ),
          border: null,
        ),
        child: SafeArea(
          child: Obx(
            () =>
                controller.items.isEmpty
                    ? Center(
                      child: Text(
                        'No items yet',
                        style: TextStyle(
                          fontSize: 24,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                    : ReorderableListView.builder(
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: controller.items.length,
                      onReorder: controller.reorderItems,
                      itemBuilder: (context, index) {
                        return KeyedSubtree(
                          key: ValueKey(controller.items[index].name),
                          child: DownloadItemCard(
                            item: controller.items[index],
                            index: index,
                          ),
                        );
                      },
                    ),
          ),
        ),
      ),
    );
  }

  void _showAddModal() {
    Get.to(
      () => AddModalView(),
      transition: Transition.downToUp,
      fullscreenDialog: true,
    );
  }
}
