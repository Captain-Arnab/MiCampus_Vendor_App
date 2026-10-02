import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

/// Mock login: any input succeeds and opens the dashboard with dummy data.
class LoginController extends GetxController {
  final identifierCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final obscurePassword = true.obs;
  final loading = false.obs;

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;

  Future<void> login() async {
    if (loading.value) return;
    FocusManager.instance.primaryFocus?.unfocus();
    loading.value = true;
    await Future.delayed(const Duration(milliseconds: 900));
    loading.value = false;
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  void onClose() {
    identifierCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}
