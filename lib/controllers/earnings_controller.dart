import 'package:get/get.dart';

import '../data/dummy_earnings.dart';
import '../modal/earnings.dart';
import 'orders_controller.dart';

class EarningsController extends GetxController {
  final OrdersController _orders = Get.find<OrdersController>();

  final _previousDays = DummyEarnings.previousSixDays();
  final payouts = DummyEarnings.payouts();

  /// Index into [lastSevenDays] highlighted on the chart; defaults to today.
  final selectedDay = 6.obs;

  double get today => _orders.todayEarnings;

  int get todayOrders => _orders.completedTodayCount;

  List<DailyEarning> get lastSevenDays {
    final now = DateTime.now();
    return [
      ..._previousDays,
      DailyEarning(
        date: DateTime(now.year, now.month, now.day),
        amount: today,
        orders: todayOrders,
      ),
    ];
  }

  double get thisWeek => lastSevenDays.fold(0.0, (s, d) => s + d.amount);

  double get thisMonth => DummyEarnings.monthBeforeThisWeek + thisWeek;

  double get pendingPayout => payouts
      .where((p) => p.status == PayoutStatus.pending)
      .fold(0.0, (s, p) => s + p.amount);
}
