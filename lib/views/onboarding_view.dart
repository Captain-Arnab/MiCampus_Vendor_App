import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';
import '../modal/pickup_point.dart';
import '../modal/vendor_shop.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/shop_form_widgets.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) controller.back();
      },
      child: AuthGradientScaffold(
        title: 'Register your shop',
        subtitle: 'Get listed on MiCampus Food Ordering',
        scrollable: false,
        onBack: controller.back,
        child: Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: AuthCard(
            expand: true,
            padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 16.w),
            child: Obx(() {
              final step = controller.step.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthStepProgress(
                    currentStep: step,
                    totalSteps: OnboardingController.stepLabels.length,
                    labels: OnboardingController.stepLabels,
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: SingleChildScrollView(
                        key: ValueKey(step),
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: _stepBody(context, step),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      if (step > 0) ...[
                        Expanded(
                          child: OutlinedButton(
                            onPressed: controller.back,
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                            ),
                            child: const Text('Back'),
                          ),
                        ),
                        SizedBox(width: 12.w),
                      ],
                      Expanded(
                        flex: 2,
                        child: AuthPrimaryButton(
                          label: controller.isLastStep
                              ? 'Submit for approval'
                              : 'Continue',
                          icon: controller.isLastStep
                              ? null
                              : Icons.arrow_forward_rounded,
                          loading: controller.submitting.value,
                          onPressed: controller.next,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _stepBody(BuildContext context, int step) {
    switch (step) {
      case 0:
        return _detailsStep();
      case 1:
        return _categoryStep();
      case 2:
        return _pickupStep();
      default:
        return _hoursStep(context);
    }
  }

  Widget _detailsStep() {
    final c = controller;
    final e = c.errors;
    return Column(
      children: [
        AuthTextField(
          controller: c.shopNameCtrl,
          label: 'Shop name',
          hint: 'e.g. Annapurna Canteen',
          prefixIcon: Icons.storefront_rounded,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          errorText: e['shopName'],
          onChanged: (_) => c.clearError('shopName'),
        ),
        SizedBox(height: 14.h),
        AuthTextField(
          controller: c.ownerNameCtrl,
          label: 'Owner name',
          prefixIcon: Icons.person_outline_rounded,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          errorText: e['ownerName'],
          onChanged: (_) => c.clearError('ownerName'),
        ),
        SizedBox(height: 14.h),
        AuthTextField(
          controller: c.phoneCtrl,
          label: 'Mobile number',
          hint: '10-digit mobile',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 10,
          textInputAction: TextInputAction.next,
          errorText: e['phone'],
          onChanged: (_) => c.clearError('phone'),
        ),
        SizedBox(height: 14.h),
        AuthTextField(
          controller: c.emailCtrl,
          label: 'Email',
          prefixIcon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          errorText: e['email'],
          onChanged: (_) => c.clearError('email'),
        ),
      ],
    );
  }

  Widget _categoryStep() {
    final c = controller;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormLabel('Shop category',
            helper: 'Helps students find you in the right section.'),
        ShopCategorySelector(
          selected: c.category.value,
          errorText: c.errors['category'],
          onChanged: (v) {
            c.category.value = v;
            c.clearError('category');
          },
        ),
        SizedBox(height: 22.h),
        const FormLabel('Shop photo / logo', helper: 'Optional — you can add it later.'),
        PhotoPickerTile(
          localPath: c.logoPath.value,
          onResult: (r) => c.logoPath.value = r.removed ? null : r.path,
        ),
      ],
    );
  }

  Widget _pickupStep() {
    final c = controller;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormLabel(
          'Where will students collect orders?',
          helper: 'Select every campus pickup point you can hand over at.',
        ),
        PickupPointsSelector(
          selected: c.pickupPoints.toSet(),
          onToggle: c.togglePickup,
          errorText: c.errors['pickup'],
        ),
      ],
    );
  }

  Widget _hoursStep(BuildContext context) {
    final c = controller;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormLabel('Operating hours',
            helper: 'Students can only order while your shop is open.'),
        OperatingHoursField(
          open: c.openTime.value,
          close: c.closeTime.value,
          errorText: c.errors['hours'],
          onOpenChanged: (t) {
            c.openTime.value = t;
            c.clearError('hours');
          },
          onCloseChanged: (t) {
            c.closeTime.value = t;
            c.clearError('hours');
          },
        ),
        SizedBox(height: 22.h),
        const FormLabel('Review'),
        Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          child: Column(
            children: [
              _ReviewRow('Shop', c.shopNameCtrl.text.trim()),
              _ReviewRow('Owner', c.ownerNameCtrl.text.trim()),
              _ReviewRow('Phone', c.phoneCtrl.text.trim()),
              _ReviewRow('Email', c.emailCtrl.text.trim()),
              _ReviewRow('Category', c.category.value?.label ?? '—'),
              _ReviewRow(
                'Pickup',
                (c.pickupPoints.toList()..sort((a, b) => a.index - b.index))
                    .map((p) => p.label)
                    .join(', '),
              ),
              _ReviewRow(
                'Hours',
                '${Fmt.timeOfDay(c.openTime.value)} – ${Fmt.timeOfDay(c.closeTime.value)}',
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.verified_user_outlined,
                size: 16.sp, color: AppColors.textSecondary),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                'Your shop goes live once the campus admin approves it.',
                style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReviewRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 76.w,
            child: Text(
              label,
              style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
