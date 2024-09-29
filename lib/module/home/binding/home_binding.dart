import 'package:get/get.dart';
import 'package:starter_pack_web/module/home/controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
