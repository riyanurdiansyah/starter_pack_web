import 'package:get/get.dart';
import 'package:starter_pack_web/module/profile/controller/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());
  }
}
