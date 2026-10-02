import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/login_controller.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_widgets.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthGradientScaffold(
      title: 'Vendor Login',
      subtitle: 'Manage your shop, menu and orders',
      child: Column(
        children: [
          AuthCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome back 👋',
                  style: GoogleFonts.sora(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Sign in with your registered phone number or email.',
                  style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
                ),
                SizedBox(height: 20.h),
                AuthTextField(
                  controller: controller.identifierCtrl,
                  label: 'Phone or Email',
                  hint: '98765 43210 or you@shop.com',
                  prefixIcon: Icons.person_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 14.h),
                Obx(
                  () => AuthTextField(
                    controller: controller.passwordCtrl,
                    label: 'Password',
                    prefixIcon: Icons.lock_outline_rounded,
                    obscureText: controller.obscurePassword.value,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => controller.login(),
                    suffixIcon: IconButton(
                      onPressed: controller.togglePasswordVisibility,
                      icon: Icon(
                        controller.obscurePassword.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Obx(
                  () => AuthPrimaryButton(
                    label: 'Login',
                    loading: controller.loading.value,
                    onPressed: controller.login,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'New vendor on campus?',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.onboarding),
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: Text(
                  'Register your shop',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
