import 'package:get/get.dart';

class HomeController extends GetxController {
  Rx<int> indexFilter = 0.obs;

  void onChangeFilter(int i) {
    indexFilter.value = i;
  }
}
