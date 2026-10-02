import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum VendorNotificationType { newOrder, orderCancelled, approval, payout, menu }

extension VendorNotificationTypeX on VendorNotificationType {
  IconData get icon {
    switch (this) {
      case VendorNotificationType.newOrder:
        return Icons.receipt_long_rounded;
      case VendorNotificationType.orderCancelled:
        return Icons.cancel_outlined;
      case VendorNotificationType.approval:
        return Icons.verified_rounded;
      case VendorNotificationType.payout:
        return Icons.account_balance_wallet_rounded;
      case VendorNotificationType.menu:
        return Icons.restaurant_menu_rounded;
    }
  }

  Color get color {
    switch (this) {
      case VendorNotificationType.newOrder:
        return AppColors.accent;
      case VendorNotificationType.orderCancelled:
        return AppColors.error;
      case VendorNotificationType.approval:
        return AppColors.success;
      case VendorNotificationType.payout:
        return AppColors.teal;
      case VendorNotificationType.menu:
        return AppColors.indigo;
    }
  }
}

class VendorNotification {
  final String id;
  final VendorNotificationType type;
  final String title;
  final String body;
  final DateTime time;
  final bool isRead;
  final String? orderId;

  const VendorNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
    this.orderId,
  });

  VendorNotification copyWith({bool? isRead}) {
    return VendorNotification(
      id: id,
      type: type,
      title: title,
      body: body,
      time: time,
      isRead: isRead ?? this.isRead,
      orderId: orderId,
    );
  }
}
