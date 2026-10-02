import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modal/pickup_point.dart';
import '../modal/vendor_shop.dart';
import '../routes/app_routes.dart';

class OnboardingController extends GetxController {
  static const stepLabels = [
    'Shop & owner details',
    'Category & shop photo',
    'Pickup points',
    'Operating hours',
  ];

  final step = 0.obs;
  final submitting = false.obs;

  final shopNameCtrl = TextEditingController();
  final ownerNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  final category = Rxn<ShopCategory>();
  final logoPath = RxnString();
  final pickupPoints = <PickupPoint>{}.obs;
  final openTime = const TimeOfDay(hour: 8, minute: 0).obs;
  final closeTime = const TimeOfDay(hour: 22, minute: 0).obs;

  /// Field key → error message for the current step.
  final errors = <String, String>{}.obs;

  bool get isLastStep => step.value == stepLabels.length - 1;

  void togglePickup(PickupPoint p) {
    if (pickupPoints.contains(p)) {
      pickupPoints.remove(p);
    } else {
      pickupPoints.add(p);
    }
    errors.remove('pickup');
  }

  void clearError(String key) => errors.remove(key);

  bool _validateStep() {
    final e = <String, String>{};
    switch (step.value) {
      case 0:
        if (shopNameCtrl.text.trim().isEmpty) e['shopName'] = 'Enter your shop name';
        if (ownerNameCtrl.text.trim().isEmpty) e['ownerName'] = 'Enter the owner name';
        final digits = phoneCtrl.text.replaceAll(RegExp(r'\D'), '');
        if (digits.length != 10) e['phone'] = 'Enter a valid 10-digit mobile number';
        final email = emailCtrl.text.trim();
        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
          e['email'] = 'Enter a valid email address';
        }
        break;
      case 1:
        if (category.value == null) e['category'] = 'Pick a shop category';
        break;
      case 2:
        if (pickupPoints.isEmpty) e['pickup'] = 'Select at least one pickup point';
        break;
      case 3:
        final open = openTime.value.hour * 60 + openTime.value.minute;
        final close = closeTime.value.hour * 60 + closeTime.value.minute;
        if (open == close) e['hours'] = 'Opening and closing time can’t be the same';
        break;
    }
    errors.assignAll(e);
    return e.isEmpty;
  }

  void next() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_validateStep()) return;
    if (isLastStep) {
      submit();
    } else {
      step.value++;
    }
  }

  void back() {
    errors.clear();
    if (step.value == 0) {
      Get.back();
    } else {
      step.value--;
    }
  }

  Future<void> submit() async {
    submitting.value = true;
    await Future.delayed(const Duration(milliseconds: 1200));
    submitting.value = false;
    Get.offNamed(
      AppRoutes.pendingApproval,
      arguments: {
        'shopName': shopNameCtrl.text.trim(),
        'ownerName': ownerNameCtrl.text.trim(),
        'category': category.value?.label ?? '',
        'phone': phoneCtrl.text.trim(),
        'email': emailCtrl.text.trim(),
      },
    );
  }

  @override
  void onClose() {
    shopNameCtrl.dispose();
    ownerNameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    super.onClose();
  }
}
