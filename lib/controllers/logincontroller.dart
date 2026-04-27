import 'package:get/get.dart';

class Logincontroller extends GetxController {
  // ── Stored at login, used across the whole app ──────────────
  var studentId = 0.obs;
  var studentName = ''.obs; // ✅ holds the logged-in user's name

  var isPasswordVisible = false.obs;

  void togglePassword() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}
