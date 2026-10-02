import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controllers/earnings_controller.dart';
import '../modal/earnings.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/common_widgets.dart';
import '../widgets/earnings_bar_chart.dart';
import '../widgets/vendor_app_bar.dart';

class EarningsView extends StatelessWidget {
  const EarningsView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<EarningsController>();
    return Scaffold(
      appBar: const VendorAppBar(
        titleText: 'Earnings',
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        children: [
          Obx(() => _HeroCard(
                today: c.today,
                todayOrders: c.todayOrders,
                week: c.thisWeek,
                month: c.thisMonth,
              )),
          SizedBox(height: 16.h),
          SectionCard(
            child: Obx(() {
              final days = c.lastSevenDays;
              final sel = days[c.selectedDay.value.clamp(0, days.length - 1)];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Last 7 days',
                          style: GoogleFonts.sora(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                      Text(
                        Fmt.inr(c.thisWeek),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.insights_rounded,
                            size: 16.sp, color: AppColors.accent),
                        SizedBox(width: 8.w),
                        Text(
                          DateFormat('EEE, d MMM').format(sel.date),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navyMuted,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${Fmt.inr(sel.amount)}  ·  ${sel.orders} orders',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  EarningsBarChart(
                    days: days,
                    selectedIndex: c.selectedDay.value,
                    onSelect: (i) => c.selectedDay.value = i,
                  ),
                ],
              );
            }),
          ),
          SizedBox(height: 22.h),
          const SectionHeader(title: 'Payout history'),
          SizedBox(height: 10.h),
          SectionCard(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Column(
              children: [
                for (var i = 0; i < c.payouts.length; i++) ...[
                  _PayoutTile(payout: c.payouts[i]),
                  if (i < c.payouts.length - 1)
                    Divider(height: 1, indent: 16.w, endIndent: 16.w),
                ],
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 14.sp, color: AppColors.textSecondary),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  'Payouts are settled weekly to your registered bank account.',
                  style:
                      TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final double today;
  final int todayOrders;
  final double week;
  final double month;

  const _HeroCard({
    required this.today,
    required this.todayOrders,
    required this.week,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.brandGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.6, 1.0],
        ),
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: AppShadows.cardLifted,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Fmt.inr(today),
                style: GoogleFonts.sora(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10.w),
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Text(
                  'from $todayOrders orders',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(child: _MiniStat(label: 'This Week', value: Fmt.inr(week))),
              SizedBox(width: 10.w),
              Expanded(
                  child: _MiniStat(label: 'This Month', value: Fmt.inr(month))),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          SizedBox(height: 2.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: GoogleFonts.sora(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PayoutTile extends StatelessWidget {
  final Payout payout;

  const _PayoutTile({required this.payout});

  @override
  Widget build(BuildContext context) {
    final s = payout.status;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: s.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              s == PayoutStatus.paid
                  ? Icons.account_balance_rounded
                  : Icons.hourglass_bottom_rounded,
              color: s.color,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Fmt.date(payout.date),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  payout.reference ??
                      '${payout.periodLabel} · ${payout.ordersCount} orders',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Fmt.inr(payout.amount),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
              SizedBox(height: 4.h),
              StatusChip(label: s.label, color: s.color, dense: true),
            ],
          ),
        ],
      ),
    );
  }
}
