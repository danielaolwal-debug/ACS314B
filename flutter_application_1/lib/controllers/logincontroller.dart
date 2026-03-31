import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class Logincontroller extends GetxController {
  var username;
  var password;
  var isPasswordVisible = false.obs;
  login(user, pass) {
    username = user;
    password = pass;
    if (username == "admin" && password == "12345") {
      return true;
    } else {
      return false;
    }
  }

  togglePassword() {
    isPasswordVisible.value = isPasswordVisible.value;
  }
}
