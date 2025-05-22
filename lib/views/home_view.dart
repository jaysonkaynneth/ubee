import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show ReorderableListView;
import 'package:get/get.dart';
import '../controllers/form_controller.dart';
import '../widgets/download_item_card.dart';
import 'add_modal_view.dart';

class HomeView extends GetView<FormController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Home'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add),
          onPressed: () => _showAddModal(),
        ),
      ),
      child: SafeArea(
        child: Obx(
          () =>
              controller.items.isEmpty
                  ? const Center(
                    child: Text('No items yet', style: TextStyle(fontSize: 24)),
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
