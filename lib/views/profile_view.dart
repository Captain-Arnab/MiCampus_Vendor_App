import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/notifications_controller.dart';
import '../controllers/shop_controller.dart';
import '../modal/vendor_shop.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/app_image.dart';
import '../widgets/common_widgets.dart';
import '../widgets/vendor_app_bar.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  Future<void> _logout() async {
    final ok = await showConfirmDialog(
      title: 'Log out?',
      message: 'You’ll stop receiving order alerts on this device.',
      confirmLabel: 'Log out',
      destructive: true,
    );
    if (ok) Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final shop = Get.find<ShopController>();
    final notifications = Get.find<NotificationsController>();

    return Scaffold(
      appBar: const VendorAppBar(
        titleText: 'Profile',
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        final s = shop.shop.value;
        return ListView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          children: [
            SectionCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      AppImage(
                        url: s.logoUrl,
                        localPath: s.logoLocalPath,
                        width: 72.w,
                        height: 72.w,
                        radius: 18,
                        placeholderIcon: Icons.storefront_rounded,
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.shopName,
                              style: GoogleFonts.sora(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Icon(s.category.icon,
                                    size: 14.sp, color: AppColors.accent),
                                SizedBox(width: 4.w),
                                Text(
                                  s.category.label,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppColors.navyMuted,
                                  ),
                                ),
                                if (s.ratingCount > 0) ...[
                                  SizedBox(width: 10.w),
                                  Icon(Icons.star_rounded,
                                      size: 15.sp, color: AppColors.gold),
                                  SizedBox(width: 2.w),
                                  Text(
                                    '${s.rating} (${s.ratingCount})',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.navyMuted,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: 8.h),
                            StatusChip(
                              label: s.approvalStatus.label,
                              color: s.approvalStatus.color,
                              icon: Icons.verified_rounded,
                              dense: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Get.toNamed(AppRoutes.editShop),
                      icon: Icon(Icons.edit_outlined, size: 18.sp),
                      label: const Text('Edit shop info'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.accent,
                        side: BorderSide(
                            color: AppColors.accent.withValues(alpha: 0.5)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            SectionCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                children: [
                  InfoRow(
                    icon: Icons.person_outline_rounded,
                    label: 'Owner',
                    value: s.ownerName,
                  ),
                  InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: s.phone,
                  ),
                  InfoRow(
                    icon: Icons.mail_outline_rounded,
                    label: 'Email',
                    value: s.email,
                  ),
                  InfoRow(
                    icon: Icons.place_outlined,
                    label: 'Pickup points',
                    value: s.pickupPointsLabel,
                  ),
                  InfoRow(
                    icon: Icons.schedule_rounded,
                    label: 'Operating hours',
                    value:
                        '${Fmt.timeOfDay(s.openTime)} – ${Fmt.timeOfDay(s.closeTime)}',
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            SectionCard(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Column(
                children: [
                  _ActionTile(
                    icon: Icons.notifications_none_rounded,
                    label: 'Notifications',
                    trailing: notifications.unreadCount > 0
                        ? StatusChip(
                            label: '${notifications.unreadCount} new',
                            color: AppColors.accent,
                            dense: true,
                          )
                        : null,
                    onTap: () => Get.toNamed(AppRoutes.notifications),
                  ),
                  Divider(height: 1, indent: 16.w, endIndent: 16.w),
                  _ActionTile(
                    icon: Icons.logout_rounded,
                    label: 'Log out',
                    color: AppColors.error,
                    onTap: _logout,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: Text(
                'MiCampus Vendor · v1.0.0 (Phase 1 preview)',
                style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color color;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.color = AppColors.navy,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color == AppColors.navy ? AppColors.accent : color;
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
      leading: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18.sp, color: iconColor),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) ...[trailing!, SizedBox(width: 6.w)],
          Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
