import 'package:get/get.dart';

class Logincontroller extends GetxController {
  // ── Stored at login, used across the whole app ──────────────
  var studentId = 0.obs;
  var studentName = ''.obs;
  var studentEmail = ''.obs;
  var studentCourse = ''.obs;
  var studentYear = ''.obs;
  var studentCampus = ''.obs;
  var studentUniversity = ''.obs;

  var isPasswordVisible = false.obs;

  void togglePassword() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void setProfile({
    required int id,
    required String name,
    required String email,
    required String course,
    required String year,
    required String campus,
    required String university,
  }) {
    studentId.value = id;
    studentName.value = name;
    studentEmail.value = email;
    studentCourse.value = course;
    studentYear.value = year;
    studentCampus.value = campus;
    studentUniversity.value = university;
  }

  void clearProfile() {
    studentId.value = 0;
    studentName.value = '';
    studentEmail.value = '';
    studentCourse.value = '';
    studentYear.value = '';
    studentCampus.value = '';
    studentUniversity.value = '';
  }
}
