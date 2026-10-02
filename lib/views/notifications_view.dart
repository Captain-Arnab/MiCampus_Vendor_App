import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/notifications_controller.dart';
import '../controllers/orders_controller.dart';
import '../modal/vendor_notification.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/common_widgets.dart';
import '../widgets/vendor_app_bar.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<NotificationsController>();
    return Scaffold(
      appBar: VendorAppBar(
        titleText: 'Notifications',
        actions: [
          Obx(() => c.unreadCount > 0
              ? TextButton(
                  onPressed: c.markAllRead,
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: const Text('Mark all read'),
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        final items = c.items;
        if (items.isEmpty) {
          return const EmptyState(
            icon: Icons.notifications_off_outlined,
            title: 'You’re all caught up',
            message: 'Order alerts and account updates will appear here.',
          );
        }
        return ListView.separated(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          itemCount: items.length,
          separatorBuilder: (_, __) => SizedBox(height: 10.h),
          itemBuilder: (_, i) => _NotificationTile(item: items[i]),
        );
      }),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final VendorNotification item;

  const _NotificationTile({required this.item});

  void _open() {
    Get.find<NotificationsController>().markRead(item.id);
    final orderId = item.orderId;
    if (orderId != null &&
        Get.find<OrdersController>().findById(orderId) != null) {
      Get.toNamed(AppRoutes.orderDetail, arguments: orderId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = item.type;
    final unread = !item.isRead;
    return SectionCard(
      padding: EdgeInsets.all(14.w),
      onTap: _open,
      borderColor: unread ? AppColors.accent.withValues(alpha: 0.35) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: t.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(t.icon, color: t.color, size: 21.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: unread ? FontWeight.w800 : FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                    if (unread)
                      Container(
                        margin: EdgeInsets.only(left: 8.w, top: 5.h),
                        width: 8.w,
                        height: 8.w,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  item.body,
                  style: TextStyle(
                    fontSize: 13.sp,
                    height: 1.35,
                    color: AppColors.navyMuted,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  Fmt.timeAgo(item.time),
                  style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
