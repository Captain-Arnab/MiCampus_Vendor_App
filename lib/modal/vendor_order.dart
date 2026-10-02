import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'pickup_point.dart';

enum OrderStatus {
  newOrder,
  accepted,
  preparing,
  ready,
  completed,
  cancelled,
}

extension OrderStatusX on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.newOrder:
        return 'New';
      case OrderStatus.accepted:
        return 'Accepted';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready for Pickup';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.newOrder:
        return AppColors.accent;
      case OrderStatus.accepted:
        return AppColors.indigo;
      case OrderStatus.preparing:
        return AppColors.warning;
      case OrderStatus.ready:
        return AppColors.teal;
      case OrderStatus.completed:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.error;
    }
  }

  IconData get icon {
    switch (this) {
      case OrderStatus.newOrder:
        return Icons.fiber_new_rounded;
      case OrderStatus.accepted:
        return Icons.thumb_up_alt_rounded;
      case OrderStatus.preparing:
        return Icons.soup_kitchen_rounded;
      case OrderStatus.ready:
        return Icons.shopping_bag_rounded;
      case OrderStatus.completed:
        return Icons.check_circle_rounded;
      case OrderStatus.cancelled:
        return Icons.cancel_rounded;
    }
  }

  /// Status reached by the primary forward action, or null when terminal.
  /// [OrderStatus.newOrder] advances via Accept and is handled separately.
  OrderStatus? get next {
    switch (this) {
      case OrderStatus.newOrder:
        return OrderStatus.accepted;
      case OrderStatus.accepted:
        return OrderStatus.preparing;
      case OrderStatus.preparing:
        return OrderStatus.ready;
      case OrderStatus.ready:
        return OrderStatus.completed;
      case OrderStatus.completed:
      case OrderStatus.cancelled:
        return null;
    }
  }

  String? get actionLabel {
    switch (this) {
      case OrderStatus.newOrder:
        return 'Accept';
      case OrderStatus.accepted:
        return 'Mark as Preparing';
      case OrderStatus.preparing:
        return 'Mark as Ready for Pickup';
      case OrderStatus.ready:
        return 'Mark as Completed';
      case OrderStatus.completed:
      case OrderStatus.cancelled:
        return null;
    }
  }

  bool get isInProgress =>
      this == OrderStatus.accepted ||
      this == OrderStatus.preparing ||
      this == OrderStatus.ready;
}

/// Orders screen tabs. Accepted orders sit in the Preparing tab as the
/// "in-kitchen" queue.
enum OrderTab { newOrders, preparing, ready, completed, cancelled }

extension OrderTabX on OrderTab {
  String get label {
    switch (this) {
      case OrderTab.newOrders:
        return 'New';
      case OrderTab.preparing:
        return 'Preparing';
      case OrderTab.ready:
        return 'Ready for Pickup';
      case OrderTab.completed:
        return 'Completed';
      case OrderTab.cancelled:
        return 'Cancelled';
    }
  }

  Set<OrderStatus> get statuses {
    switch (this) {
      case OrderTab.newOrders:
        return {OrderStatus.newOrder};
      case OrderTab.preparing:
        return {OrderStatus.accepted, OrderStatus.preparing};
      case OrderTab.ready:
        return {OrderStatus.ready};
      case OrderTab.completed:
        return {OrderStatus.completed};
      case OrderTab.cancelled:
        return {OrderStatus.cancelled};
    }
  }

  IconData get emptyIcon {
    switch (this) {
      case OrderTab.newOrders:
        return Icons.notifications_none_rounded;
      case OrderTab.preparing:
        return Icons.soup_kitchen_outlined;
      case OrderTab.ready:
        return Icons.shopping_bag_outlined;
      case OrderTab.completed:
        return Icons.task_alt_rounded;
      case OrderTab.cancelled:
        return Icons.block_rounded;
    }
  }
}

enum RejectReason { outOfStock, shopClosed, tooBusy, other }

extension RejectReasonX on RejectReason {
  String get label {
    switch (this) {
      case RejectReason.outOfStock:
        return 'Out of stock';
      case RejectReason.shopClosed:
        return 'Shop closed';
      case RejectReason.tooBusy:
        return 'Too busy';
      case RejectReason.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case RejectReason.outOfStock:
        return Icons.remove_shopping_cart_outlined;
      case RejectReason.shopClosed:
        return Icons.store_mall_directory_outlined;
      case RejectReason.tooBusy:
        return Icons.hourglass_top_rounded;
      case RejectReason.other:
        return Icons.edit_note_rounded;
    }
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final double unitPrice;
  final bool isVeg;

  const OrderItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.isVeg,
  });

  double get lineTotal => unitPrice * quantity;
}

class VendorOrder {
  final String id;
  final String customerFirstName;
  final String customerLastName;
  final List<OrderItem> items;
  final String? note;
  final PickupPoint pickupPoint;
  final OrderStatus status;
  final DateTime placedAt;
  final DateTime? acceptedAt;
  final DateTime? preparingAt;
  final DateTime? readyAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancelReason;
  final bool cancelledByCustomer;

  const VendorOrder({
    required this.id,
    required this.customerFirstName,
    required this.customerLastName,
    required this.items,
    required this.pickupPoint,
    required this.status,
    required this.placedAt,
    this.note,
    this.acceptedAt,
    this.preparingAt,
    this.readyAt,
    this.completedAt,
    this.cancelledAt,
    this.cancelReason,
    this.cancelledByCustomer = false,
  });

  /// Privacy-safe display name, e.g. "Aarav S."
  String get customerDisplayName {
    final initial =
        customerLastName.isEmpty ? '' : ' ${customerLastName[0].toUpperCase()}.';
    return '$customerFirstName$initial';
  }

  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);

  double get total => items.fold(0.0, (sum, i) => sum + i.lineTotal);

  String get itemSummary =>
      items.map((i) => '${i.quantity}× ${i.name}').join(', ');

  VendorOrder copyWith({
    OrderStatus? status,
    DateTime? acceptedAt,
    DateTime? preparingAt,
    DateTime? readyAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    String? cancelReason,
  }) {
    return VendorOrder(
      id: id,
      customerFirstName: customerFirstName,
      customerLastName: customerLastName,
      items: items,
      note: note,
      pickupPoint: pickupPoint,
      status: status ?? this.status,
      placedAt: placedAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      preparingAt: preparingAt ?? this.preparingAt,
      readyAt: readyAt ?? this.readyAt,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancelReason: cancelReason ?? this.cancelReason,
      cancelledByCustomer: cancelledByCustomer,
    );
  }
}
