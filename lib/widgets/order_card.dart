import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../modal/pickup_point.dart';
import '../modal/vendor_order.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'common_widgets.dart';
import 'order_actions.dart';

class OrderCard extends StatelessWidget {
  final VendorOrder order;
  final bool showActions;

  const OrderCard({super.key, required this.order, this.showActions = true});

  @override
  Widget build(BuildContext context) {
    final status = order.status;
    final isNew = status == OrderStatus.newOrder;
    return SectionCard(
      padding: EdgeInsets.all(14.w),
      borderColor: isNew ? AppColors.accent.withValues(alpha: 0.45) : null,
      onTap: () => Get.toNamed(AppRoutes.orderDetail, arguments: order.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '#${order.id}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
              SizedBox(width: 8.w),
              StatusChip(
                label: status.label,
                color: status.color,
                icon: status.icon,
                dense: true,
              ),
              const Spacer(),
              Text(
                Fmt.timeAgo(order.placedAt),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: isNew ? FontWeight.w700 : FontWeight.w500,
                  color: isNew ? AppColors.accent : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              CircleAvatar(
                radius: 14.r,
                backgroundColor: AppColors.navy.withValues(alpha: 0.08),
                child: Text(
                  order.customerFirstName[0],
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                order.customerDisplayName,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              Text(
                '  ·  ${order.itemCount} item${order.itemCount == 1 ? '' : 's'}',
                style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
              ),
              const Spacer(),
              Text(
                Fmt.inr(order.total),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            order.itemSummary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.navyMuted,
              height: 1.35,
            ),
          ),
          if (status == OrderStatus.cancelled && order.cancelReason != null) ...[
            SizedBox(height: 8.h),
            _Hint(
              icon: Icons.info_outline_rounded,
              color: AppColors.error,
              text: order.cancelledByCustomer
                  ? order.cancelReason!
                  : 'Rejected · ${order.cancelReason}',
            ),
          ] else if (order.note != null && order.note!.isNotEmpty) ...[
            SizedBox(height: 8.h),
            _Hint(
              icon: Icons.sticky_note_2_outlined,
              color: AppColors.gold,
              text: order.note!,
            ),
          ],
          SizedBox(height: 10.h),
          const Divider(height: 1),
          SizedBox(height: 10.h),
          Row(
            children: [
              _Meta(icon: order.pickupPoint.icon, text: order.pickupPoint.label),
              SizedBox(width: 14.w),
              _Meta(
                icon: Icons.schedule_rounded,
                text: 'Placed ${Fmt.time(order.placedAt)}',
              ),
            ],
          ),
          if (showActions && status.actionLabel != null) ...[
            SizedBox(height: 12.h),
            OrderActions(order: order),
          ],
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Meta({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15.sp, color: AppColors.accent),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.navyMuted,
          ),
        ),
      ],
    );
  }
}

class _Hint extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _Hint({required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15.sp, color: color),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.navy,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
