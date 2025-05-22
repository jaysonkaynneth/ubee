import 'package:get/get.dart';
import '../controllers/tab_controller.dart';
import '../controllers/form_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TabViewController());
    Get.put(FormController());
  }
}
