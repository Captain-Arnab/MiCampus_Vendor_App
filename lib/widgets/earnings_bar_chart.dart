import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../modal/earnings.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

/// Dependency-free daily earnings bar chart with tap-to-select.
class EarningsBarChart extends StatelessWidget {
  final List<DailyEarning> days;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final double height;

  const EarningsBarChart({
    super.key,
    required this.days,
    required this.selectedIndex,
    required this.onSelect,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    final maxAmount = days.fold<double>(0, (m, d) => d.amount > m ? d.amount : m);
    final ceiling = _niceCeiling(maxAmount);
    final chartHeight = height.h;
    final labelStyle = TextStyle(fontSize: 10.sp, color: AppColors.textSecondary);

    return SizedBox(
      height: chartHeight + 28.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40.w,
            height: chartHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Fmt.inrCompact(ceiling), style: labelStyle),
                Text(Fmt.inrCompact(ceiling / 2), style: labelStyle),
                Text('₹0', style: labelStyle),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                SizedBox(
                  height: chartHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      3,
                      (_) => Container(
                        height: 1,
                        color: AppColors.border.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(days.length, (i) {
                    final d = days[i];
                    final selected = i == selectedIndex;
                    final isToday = i == days.length - 1;
                    final fraction = ceiling == 0 ? 0.0 : d.amount / ceiling;
                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onSelect(i),
                        child: Column(
                          children: [
                            SizedBox(
                              height: chartHeight,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0, end: fraction),
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, f, _) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: selected ? 24.w : 20.w,
                                    height: (chartHeight * f).clamp(4.0, chartHeight),
                                    decoration: BoxDecoration(
                                      gradient: selected
                                          ? const LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                AppColors.accentLight,
                                                AppColors.accentDark,
                                              ],
                                            )
                                          : null,
                                      color: selected
                                          ? null
                                          : AppColors.accent.withValues(alpha: 0.22),
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(8.r),
                                        bottom: Radius.circular(3.r),
                                      ),
                                      boxShadow: selected
                                          ? [
                                              BoxShadow(
                                                color: AppColors.accent
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              isToday ? 'Today' : Fmt.weekday(d.date),
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight:
                                    selected ? FontWeight.w800 : FontWeight.w500,
                                color: selected
                                    ? AppColors.accent
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static double _niceCeiling(double v) {
    if (v <= 0) return 1000;
    const step = 1000.0;
    return ((v / step).ceil() * step).toDouble();
  }
}
