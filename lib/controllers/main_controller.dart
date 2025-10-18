import 'package:get/get.dart';

class MainController extends GetxController {
  // index untuk bottom nav
  var index = 0.obs;

  // helper to reset index (misal saat role change)
  void setIndex(int i) => index.value = i;
}
