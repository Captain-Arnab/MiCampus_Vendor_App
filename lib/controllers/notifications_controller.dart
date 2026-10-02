import 'package:get/get.dart';

import '../data/dummy_notifications.dart';

class NotificationsController extends GetxController {
  final items = DummyNotifications.all().obs;

  int get unreadCount => items.where((n) => !n.isRead).length;

  void markRead(String id) {
    final i = items.indexWhere((n) => n.id == id);
    if (i != -1 && !items[i].isRead) items[i] = items[i].copyWith(isRead: true);
  }

  void markAllRead() {
    items.assignAll(items.map((n) => n.copyWith(isRead: true)));
  }
}
