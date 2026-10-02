import 'package:flutter_test/flutter_test.dart';
import 'package:micampus_vendor/modal/pickup_point.dart';
import 'package:micampus_vendor/modal/vendor_order.dart';

void main() {
  VendorOrder order(OrderStatus status) => VendorOrder(
        id: 'MC-1',
        customerFirstName: 'Aarav',
        customerLastName: 'Sharma',
        pickupPoint: PickupPoint.mainGate,
        status: status,
        placedAt: DateTime(2026, 1, 1, 12),
        items: const [
          OrderItem(name: 'Dosa', quantity: 2, unitPrice: 80, isVeg: true),
          OrderItem(name: 'Coffee', quantity: 1, unitPrice: 30, isVeg: true),
        ],
      );

  test('customer name is first name + last initial', () {
    expect(order(OrderStatus.newOrder).customerDisplayName, 'Aarav S.');
  });

  test('totals and counts', () {
    final o = order(OrderStatus.newOrder);
    expect(o.itemCount, 3);
    expect(o.total, 190);
  });

  test('status flow advances to completed then stops', () {
    expect(OrderStatus.newOrder.next, OrderStatus.accepted);
    expect(OrderStatus.accepted.next, OrderStatus.preparing);
    expect(OrderStatus.preparing.next, OrderStatus.ready);
    expect(OrderStatus.ready.next, OrderStatus.completed);
    expect(OrderStatus.completed.next, isNull);
    expect(OrderStatus.cancelled.next, isNull);
  });

  test('accepted orders live in the Preparing tab', () {
    expect(OrderTab.preparing.statuses, contains(OrderStatus.accepted));
  });
}
