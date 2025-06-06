import 'package:get/get.dart';
import '../controllers/tab_controller.dart';
import '../controllers/form_controller.dart';
import '../controllers/player_controller.dart';
import '../theme/app_colors.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController());
    Get.put(TabViewController());
    Get.put(FormController());
    Get.put(PlayerController());
  }
}
