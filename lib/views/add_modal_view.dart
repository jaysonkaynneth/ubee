import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controllers/form_controller.dart';

class AddModalView extends StatelessWidget {
  final FormController controller = Get.find<FormController>();

  AddModalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final linkController = TextEditingController();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Add New Item'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Save'),
          onPressed: () {
            if (nameController.text.isNotEmpty &&
                linkController.text.isNotEmpty) {
              controller.addItem(nameController.text, linkController.text);
              Navigator.pop(context);
            }
          },
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: nameController,
                  placeholder: 'Enter name',
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'YouTube Link',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: linkController,
                  placeholder: 'Enter YouTube URL',
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
