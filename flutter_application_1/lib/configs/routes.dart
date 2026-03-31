import 'package:get/get.dart';
import '../views/login.dart';
import '../views/signup.dart';
import '../views/homescreen.dart';

var routes = [
  GetPage(name: "/", page: () => const LoginScreen()),
  GetPage(name: "/signup", page: () => const SignUpScreen()),
  GetPage(name: "/HomeScreen", page: () => const HomeScreen()),
  GetPage(name: "/home", page: () => const HomeScreen()),
];
