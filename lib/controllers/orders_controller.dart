import 'package:get/get.dart';

import '../data/dummy_orders.dart';
import '../modal/vendor_order.dart';

class OrdersController extends GetxController {
  final orders = DummyOrders.today().obs;

  /// Orders screen tab; set from elsewhere (e.g. dashboard cards) to deep-link.
  final activeTab = OrderTab.newOrders.obs;

  List<VendorOrder> byTab(OrderTab tab) {
    final list = orders.where((o) => tab.statuses.contains(o.status)).toList();
    switch (tab) {
      case OrderTab.newOrders:
      case OrderTab.preparing:
      case OrderTab.ready:
        // Oldest first: the queue order the kitchen should work in.
        list.sort((a, b) => a.placedAt.compareTo(b.placedAt));
        break;
      case OrderTab.completed:
      case OrderTab.cancelled:
        list.sort((a, b) => b.placedAt.compareTo(a.placedAt));
        break;
    }
    return list;
  }

  int countFor(OrderTab tab) =>
      orders.where((o) => tab.statuses.contains(o.status)).length;

  int get newCount => countFor(OrderTab.newOrders);

  int get inProgressCount => orders.where((o) => o.status.isInProgress).length;

  /// Dummy order book only holds today's orders.
  int get completedTodayCount => countFor(OrderTab.completed);

  double get todayEarnings => orders
      .where((o) => o.status == OrderStatus.completed)
      .fold(0.0, (sum, o) => sum + o.total);

  /// Latest active orders (new + in progress) for the dashboard preview.
  List<VendorOrder> recentIncoming({int limit = 4}) {
    final list = orders
        .where((o) => o.status == OrderStatus.newOrder || o.status.isInProgress)
        .toList()
      ..sort((a, b) => b.placedAt.compareTo(a.placedAt));
    return list.take(limit).toList();
  }

  VendorOrder? findById(String id) =>
      orders.firstWhereOrNull((o) => o.id == id);

  void _replace(VendorOrder updated) {
    final i = orders.indexWhere((o) => o.id == updated.id);
    if (i != -1) orders[i] = updated;
  }

  /// Moves an order to its next status, stamping the timeline.
  void advance(String id) {
    final order = findById(id);
    final next = order?.status.next;
    if (order == null || next == null) return;
    final now = DateTime.now();
    switch (next) {
      case OrderStatus.accepted:
        _replace(order.copyWith(status: next, acceptedAt: now));
        break;
      case OrderStatus.preparing:
        _replace(order.copyWith(status: next, preparingAt: now));
        break;
      case OrderStatus.ready:
        _replace(order.copyWith(status: next, readyAt: now));
        break;
      case OrderStatus.completed:
        _replace(order.copyWith(status: next, completedAt: now));
        break;
      case OrderStatus.newOrder:
      case OrderStatus.cancelled:
        break;
    }
  }

  void reject(String id, String reason) {
    final order = findById(id);
    if (order == null || order.status != OrderStatus.newOrder) return;
    _replace(order.copyWith(
      status: OrderStatus.cancelled,
      cancelledAt: DateTime.now(),
      cancelReason: reason,
    ));
  }
}
