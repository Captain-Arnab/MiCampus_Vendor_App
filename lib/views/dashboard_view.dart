import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controllers/home_shell_controller.dart';
import '../controllers/orders_controller.dart';
import '../controllers/shop_controller.dart';
import '../modal/pickup_point.dart';
import '../modal/vendor_order.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/common_widgets.dart';
import '../widgets/vendor_app_bar.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = Get.find<ShopController>();
    final orders = Get.find<OrdersController>();
    final shell = Get.find<HomeShellController>();

    return Scaffold(
      appBar: VendorAppBar(
        toolbarHeight: 68,
        title: Obx(() {
          final s = shop.shop.value;
          return BrandTitle(
            logoHeight: 34,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  VendorAppBarTokens.greeting(s.ownerName),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                Text(
                  s.shopName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.sora(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }),
        actions: const [NotificationBell()],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        children: [
          const _ShopStatusCard(),
          SizedBox(height: 22.h),
          SectionHeader(
            title: 'Today’s summary',
            trailing: Text(
              DateFormat('EEE, d MMM').format(DateTime.now()),
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ),
          SizedBox(height: 12.h),
          Obx(() {
            final cards = [
              _SummaryCard(
                label: 'New Orders',
                value: '${orders.newCount}',
                icon: Icons.fiber_new_rounded,
                color: AppColors.accent,
                highlight: orders.newCount > 0,
                onTap: () => shell.openOrders(OrderTab.newOrders),
              ),
              _SummaryCard(
                label: 'In Progress',
                value: '${orders.inProgressCount}',
                icon: Icons.soup_kitchen_rounded,
                color: AppColors.warning,
                onTap: () => shell.openOrders(OrderTab.preparing),
              ),
              _SummaryCard(
                label: 'Completed Today',
                value: '${orders.completedTodayCount}',
                icon: Icons.task_alt_rounded,
                color: AppColors.success,
                onTap: () => shell.openOrders(OrderTab.completed),
              ),
              _SummaryCard(
                label: 'Today’s Earnings',
                value: Fmt.inr(orders.todayEarnings),
                icon: Icons.currency_rupee_rounded,
                color: AppColors.teal,
                onTap: () => shell.select(HomeTab.earnings),
              ),
            ];
            return GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 1.45,
              children: cards,
            );
          }),
          SizedBox(height: 24.h),
          SectionHeader(
            title: 'Recent orders',
            actionLabel: 'View All',
            onAction: () => shell.openOrders(),
          ),
          SizedBox(height: 8.h),
          Obx(() {
            final recent = orders.recentIncoming();
            if (recent.isEmpty) {
              return const SectionCard(
                child: EmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: 'No active orders',
                  message: 'New orders from students will show up here.',
                ),
              );
            }
            return SectionCard(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Column(
                children: [
                  for (var i = 0; i < recent.length; i++) ...[
                    _RecentOrderTile(order: recent[i]),
                    if (i < recent.length - 1)
                      Divider(height: 1, indent: 16.w, endIndent: 16.w),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ShopStatusCard extends StatelessWidget {
  const _ShopStatusCard();

  @override
  Widget build(BuildContext context) {
    final shop = Get.find<ShopController>();
    return Obx(() {
      final open = shop.isOpen.value;
      final color = open ? AppColors.success : AppColors.error;
      final s = shop.shop.value;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 10.w, 14.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: color.withValues(alpha: 0.45), width: 1.6),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.14),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                open ? Icons.storefront_rounded : Icons.store_mall_directory_outlined,
                color: color,
                size: 26.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration:
                            BoxDecoration(color: color, shape: BoxShape.circle),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        open ? 'Shop is Open' : 'Shop is Closed',
                        style: GoogleFonts.sora(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    open
                        ? 'Accepting orders · ${Fmt.timeOfDay(s.openTime)} – ${Fmt.timeOfDay(s.closeTime)}'
                        : 'Students can’t place new orders right now',
                    style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Transform.scale(
              scale: 1.1,
              child: Switch(
                value: open,
                activeTrackColor: AppColors.success,
                onChanged: (v) {
                  shop.setOpen(v);
                  AppSnack.show(
                    v
                        ? 'You’re online — students can order again'
                        : 'You’re offline — new orders are paused',
                    icon: v ? Icons.storefront_rounded : Icons.pause_circle_rounded,
                    iconColor: v ? AppColors.success : AppColors.warning,
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool highlight;
  final VoidCallback onTap;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: EdgeInsets.all(14.w),
      onTap: onTap,
      borderColor: highlight ? color.withValues(alpha: 0.45) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 19.sp),
              ),
              const Spacer(),
              Icon(Icons.arrow_outward_rounded,
                  size: 16.sp, color: AppColors.textSecondary),
            ],
          ),
          const Spacer(),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: GoogleFonts.sora(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentOrderTile extends StatelessWidget {
  final VendorOrder order;

  const _RecentOrderTile({required this.order});

  @override
  Widget build(BuildContext context) {
    final status = order.status;
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.orderDetail, arguments: order.id),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: status.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(status.icon, color: status.color, size: 21.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '#${order.id}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Flexible(
                        child: Text(
                          '· ${order.customerDisplayName}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.navyMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    order.itemSummary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    '${Fmt.timeAgo(order.placedAt)} · ${order.pickupPoint.label}',
                    style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Fmt.inr(order.total),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
                SizedBox(height: 6.h),
                StatusChip(label: status.label, color: status.color, dense: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
