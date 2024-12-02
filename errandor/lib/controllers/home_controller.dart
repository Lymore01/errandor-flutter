import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxBool isCreator = true.obs;

  void toggleUserType(bool value) {
    isCreator.value = value;
  }
} 