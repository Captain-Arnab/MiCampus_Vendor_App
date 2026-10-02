import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/orders_controller.dart';
import '../modal/pickup_point.dart';
import '../modal/vendor_order.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/common_widgets.dart';
import '../widgets/order_actions.dart';
import '../widgets/vendor_app_bar.dart';

class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final orderId = Get.arguments as String;
    final c = Get.find<OrdersController>();

    return Obx(() {
      final order = c.findById(orderId);
      if (order == null) {
        return Scaffold(
          appBar: const VendorAppBar(titleText: 'Order'),
          body: const EmptyState(
            icon: Icons.search_off_rounded,
            title: 'Order not found',
            message: 'This order may have been removed.',
          ),
        );
      }
      final status = order.status;
      final hasActions = status.actionLabel != null;

      return Scaffold(
        appBar: VendorAppBar(titleText: 'Order #${order.id}'),
        body: ListView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          children: [
            _HeaderCard(order: order),
            SizedBox(height: 14.h),
            _ItemsCard(order: order),
            if (order.note != null && order.note!.isNotEmpty) ...[
              SizedBox(height: 14.h),
              _NoteCard(note: order.note!),
            ],
            SizedBox(height: 14.h),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _cardTitle('Order status'),
                  SizedBox(height: 14.h),
                  _StatusTimeline(order: order),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: hasActions
            ? Container(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.navy.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: OrderActions(order: order, large: true),
                ),
              )
            : null,
      );
    });
  }
}

Widget _cardTitle(String text) => Text(
      text,
      style: GoogleFonts.sora(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.navy,
      ),
    );

class _HeaderCard extends StatelessWidget {
  final VendorOrder order;

  const _HeaderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final status = order.status;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusChip(label: status.label, color: status.color, icon: status.icon),
              const Spacer(),
              Text(
                Fmt.timeAgo(order.placedAt),
                style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundColor: AppColors.accent.withValues(alpha: 0.12),
                child: Text(
                  order.customerFirstName[0],
                  style: GoogleFonts.sora(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customerDisplayName,
                      style: GoogleFonts.sora(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    Text(
                      'Student · ${order.itemCount} item${order.itemCount == 1 ? '' : 's'}',
                      style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          const Divider(height: 1),
          SizedBox(height: 4.h),
          InfoRow(
            icon: order.pickupPoint.icon,
            label: 'Pickup location',
            value: order.pickupPoint.label,
          ),
          InfoRow(
            icon: Icons.schedule_rounded,
            label: 'Placed at',
            value: '${Fmt.time(order.placedAt)} · ${Fmt.date(order.placedAt)}',
          ),
          if (status == OrderStatus.cancelled && order.cancelReason != null)
            InfoRow(
              icon: Icons.info_outline_rounded,
              label: order.cancelledByCustomer ? 'Cancelled' : 'Rejection reason',
              value: order.cancelReason!,
            ),
        ],
      ),
    );
  }
}

class _ItemsCard extends StatelessWidget {
  final VendorOrder order;

  const _ItemsCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('Items'),
          SizedBox(height: 8.h),
          ...order.items.map(
            (i) => Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: VegBadge(isVeg: i.isVeg, size: 14),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${i.quantity}×',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          i.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy,
                          ),
                        ),
                        Text(
                          '${Fmt.inr(i.unitPrice)} each',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    Fmt.inr(i.lineTotal),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 6.h),
          const Divider(height: 1),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text(
                'Order total',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const Spacer(),
              Text(
                Fmt.inr(order.total),
                style: GoogleFonts.sora(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final String note;

  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.sticky_note_2_rounded, color: AppColors.gold, size: 22.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Special instructions',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  note,
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.4,
                    color: AppColors.navy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Placed → Accepted → Preparing → Ready → Completed, with timestamps for the
/// stages reached. Cancelled orders end the timeline at the cancel point.
class _StatusTimeline extends StatelessWidget {
  final VendorOrder order;

  const _StatusTimeline({required this.order});

  @override
  Widget build(BuildContext context) {
    final stages = <(String, DateTime?, Color)>[
      ('Placed', order.placedAt, AppColors.accent),
      ('Accepted', order.acceptedAt, OrderStatus.accepted.color),
      ('Preparing', order.preparingAt, OrderStatus.preparing.color),
      ('Ready for Pickup', order.readyAt, OrderStatus.ready.color),
      ('Completed', order.completedAt, OrderStatus.completed.color),
    ];

    final cancelled = order.status == OrderStatus.cancelled;
    final rows = <(String, DateTime?, Color, bool isCancel)>[];
    for (final s in stages) {
      if (cancelled && s.$2 == null) break;
      rows.add((s.$1, s.$2, s.$3, false));
    }
    if (cancelled) {
      rows.add((
        order.cancelledByCustomer ? 'Cancelled by customer' : 'Rejected',
        order.cancelledAt,
        AppColors.error,
        true,
      ));
    }

    final currentIndex = rows.lastIndexWhere((r) => r.$2 != null);

    return Column(
      children: List.generate(rows.length, (i) {
        final (label, at, color, isCancel) = rows[i];
        final done = at != null;
        final isCurrent = i == currentIndex;
        final nextDone = i + 1 < rows.length && rows[i + 1].$2 != null;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done ? color : AppColors.surfaceMuted,
                      border: Border.all(
                        color: done ? color : AppColors.border,
                        width: 2,
                      ),
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.35),
                                blurRadius: 10,
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      isCancel
                          ? Icons.close_rounded
                          : done
                              ? Icons.check_rounded
                              : Icons.circle,
                      size: done ? 16.sp : 8.sp,
                      color: done ? Colors.white : AppColors.border,
                    ),
                  ),
                  if (i < rows.length - 1)
                    Expanded(
                      child: Container(
                        width: 2,
                        constraints: BoxConstraints(minHeight: 22.h),
                        color: nextDone ? color : AppColors.border,
                      ),
                    ),
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 4.h, bottom: 18.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight:
                                isCurrent ? FontWeight.w800 : FontWeight.w600,
                            color: isCancel
                                ? AppColors.error
                                : done
                                    ? AppColors.navy
                                    : AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Text(
                        done ? Fmt.time(at) : 'Pending',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: done ? FontWeight.w600 : FontWeight.w400,
                          color: done
                              ? AppColors.navyMuted
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
