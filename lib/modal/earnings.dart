import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class DailyEarning {
  final DateTime date;
  final double amount;
  final int orders;

  const DailyEarning({
    required this.date,
    required this.amount,
    required this.orders,
  });
}

enum PayoutStatus { paid, pending }

extension PayoutStatusX on PayoutStatus {
  String get label => this == PayoutStatus.paid ? 'Paid' : 'Pending';

  Color get color =>
      this == PayoutStatus.paid ? AppColors.success : AppColors.warning;
}

class Payout {
  final String id;
  final DateTime date;
  final double amount;
  final PayoutStatus status;
  final String periodLabel;
  final int ordersCount;
  final String? reference;

  const Payout({
    required this.id,
    required this.date,
    required this.amount,
    required this.status,
    required this.periodLabel,
    required this.ordersCount,
    this.reference,
  });
}
