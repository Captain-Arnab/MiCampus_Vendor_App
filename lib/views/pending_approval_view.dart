import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../modal/vendor_shop.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/common_widgets.dart';

/// Mock post-registration state: vendor waits for admin approval.
class PendingApprovalView extends StatelessWidget {
  const PendingApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = (Get.arguments as Map?)?.cast<String, String>() ?? const {};
    final shopName = args['shopName']?.isNotEmpty == true
        ? args['shopName']!
        : 'Your shop';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Get.offAllNamed(AppRoutes.login);
      },
      child: AuthGradientScaffold(
        title: 'Registration submitted',
        subtitle: 'Pending admin approval',
        child: AuthCard(
          child: Column(
            children: [
              Container(
                width: 84.w,
                height: 84.w,
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.hourglass_top_rounded,
                    size: 42.sp, color: AppColors.warning),
              ),
              SizedBox(height: 16.h),
              Text(
                shopName,
                textAlign: TextAlign.center,
                style: GoogleFonts.sora(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              SizedBox(height: 8.h),
              StatusChip(
                label: ApprovalStatus.pending.label,
                color: ApprovalStatus.pending.color,
                icon: Icons.schedule_rounded,
              ),
              SizedBox(height: 14.h),
              Text(
                'Thanks for registering! The campus admin will review your '
                'details. You’ll be able to log in and start accepting orders '
                'once your shop is approved.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 22.h),
              const _ApprovalSteps(),
              SizedBox(height: 22.h),
              if (args['email']?.isNotEmpty == true)
                Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Text(
                    'We’ll send updates to ${args['email']}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              AuthPrimaryButton(
                label: 'Back to Login',
                onPressed: () => Get.offAllNamed(AppRoutes.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApprovalSteps extends StatelessWidget {
  const _ApprovalSteps();

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('Registration submitted', 'Just now', true, false),
      ('Admin review', 'Usually within 24–48 hours', false, true),
      ('Shop goes live', 'Start receiving orders', false, false),
    ];
    return Column(
      children: List.generate(steps.length, (i) {
        final (title, sub, done, current) = steps[i];
        final color = done
            ? AppColors.success
            : current
                ? AppColors.warning
                : AppColors.border;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 26.w,
                  height: 26.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: done ? color : color.withValues(alpha: 0.15),
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Icon(
                    done
                        ? Icons.check_rounded
                        : current
                            ? Icons.more_horiz_rounded
                            : Icons.circle,
                    size: done || current ? 15.sp : 7.sp,
                    color: done ? Colors.white : color,
                  ),
                ),
                if (i < steps.length - 1)
                  Container(width: 2, height: 22.h, color: AppColors.border),
              ],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: current ? FontWeight.w800 : FontWeight.w600,
                        color: done || current
                            ? AppColors.navy
                            : AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      sub,
                      style: TextStyle(
                          fontSize: 12.sp, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
