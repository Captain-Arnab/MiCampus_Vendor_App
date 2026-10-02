import '../modal/vendor_notification.dart';

class DummyNotifications {
  DummyNotifications._();

  static List<VendorNotification> all() {
    final now = DateTime.now();
    DateTime ago(Duration d) => now.subtract(d);
    return [
      VendorNotification(
        id: 'n1',
        type: VendorNotificationType.newOrder,
        title: 'New order #MC-10492',
        body: 'Aarav S. ordered 3 items · ₹260 · Pickup at Main Gate',
        time: ago(const Duration(minutes: 2)),
        orderId: 'MC-10492',
      ),
      VendorNotification(
        id: 'n2',
        type: VendorNotificationType.newOrder,
        title: 'New order #MC-10491',
        body: 'Diya M. ordered 4 items · ₹220 · Pickup at Hostel Gate',
        time: ago(const Duration(minutes: 4)),
        orderId: 'MC-10491',
      ),
      VendorNotification(
        id: 'n3',
        type: VendorNotificationType.newOrder,
        title: 'New order #MC-10490',
        body: 'Kabir V. ordered 3 items · ₹280 · Pickup at Main Gate',
        time: ago(const Duration(minutes: 7)),
        orderId: 'MC-10490',
      ),
      VendorNotification(
        id: 'n4',
        type: VendorNotificationType.orderCancelled,
        title: 'Order #MC-10477 cancelled',
        body: 'Riya S. cancelled the order before it was accepted.',
        time: ago(const Duration(hours: 2)),
        orderId: 'MC-10477',
        isRead: true,
      ),
      VendorNotification(
        id: 'n5',
        type: VendorNotificationType.payout,
        title: 'Payout of ₹21,460 processed',
        body: 'Your weekly settlement has been credited to your bank account.',
        time: ago(const Duration(days: 7)),
        isRead: true,
      ),
      VendorNotification(
        id: 'n6',
        type: VendorNotificationType.menu,
        title: '3 items marked unavailable',
        body: 'Remember to switch them back on once restocked.',
        time: ago(const Duration(days: 1, hours: 3)),
        isRead: true,
      ),
      VendorNotification(
        id: 'n7',
        type: VendorNotificationType.approval,
        title: 'Your shop is live on MiCampus 🎉',
        body: 'Admin approved Annapurna Canteen. Students can now order from you.',
        time: ago(const Duration(days: 30)),
        isRead: true,
      ),
      VendorNotification(
        id: 'n8',
        type: VendorNotificationType.approval,
        title: 'Registration received',
        body: 'Your shop registration is under review by the campus admin.',
        time: ago(const Duration(days: 32)),
        isRead: true,
      ),
    ];
  }
}
