import '../modal/earnings.dart';

class DummyEarnings {
  DummyEarnings._();

  /// Earnings for the 6 days before today (oldest first). Today's figure is
  /// derived live from completed orders.
  static List<DailyEarning> previousSixDays() {
    final today = DateTime.now();
    const amounts = [2840.0, 3215.0, 1980.0, 3560.0, 4120.0, 2675.0];
    const orders = [24, 27, 17, 31, 36, 22];
    return List.generate(6, (i) {
      final day = DateTime(today.year, today.month, today.day)
          .subtract(Duration(days: 6 - i));
      return DailyEarning(date: day, amount: amounts[i], orders: orders[i]);
    });
  }

  /// Month-to-date earnings excluding the last 7 days.
  static const double monthBeforeThisWeek = 38450;

  static List<Payout> payouts() {
    final today = DateTime.now();
    DateTime daysAgo(int d) => today.subtract(Duration(days: d));
    return [
      Payout(
        id: 'PO-2041',
        date: daysAgo(0),
        amount: 18390,
        status: PayoutStatus.pending,
        periodLabel: 'Settlement · this week',
        ordersCount: 157,
      ),
      Payout(
        id: 'PO-2034',
        date: daysAgo(7),
        amount: 21460,
        status: PayoutStatus.paid,
        periodLabel: 'Weekly settlement',
        ordersCount: 182,
        reference: 'UTR 4412 8890 1123',
      ),
      Payout(
        id: 'PO-2027',
        date: daysAgo(14),
        amount: 19875,
        status: PayoutStatus.paid,
        periodLabel: 'Weekly settlement',
        ordersCount: 169,
        reference: 'UTR 4409 1276 5530',
      ),
      Payout(
        id: 'PO-2019',
        date: daysAgo(21),
        amount: 17240,
        status: PayoutStatus.paid,
        periodLabel: 'Weekly settlement',
        ordersCount: 148,
        reference: 'UTR 4401 6623 0047',
      ),
      Payout(
        id: 'PO-2012',
        date: daysAgo(28),
        amount: 20110,
        status: PayoutStatus.paid,
        periodLabel: 'Weekly settlement',
        ordersCount: 175,
        reference: 'UTR 4396 3301 8812',
      ),
    ];
  }
}
