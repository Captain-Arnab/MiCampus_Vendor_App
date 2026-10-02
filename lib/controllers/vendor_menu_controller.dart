import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/dummy_menu.dart';
import '../modal/menu_item.dart';

class VendorMenuController extends GetxController {
  final items = DummyMenu.items().obs;
  final categories = DummyMenu.categories;

  int get unavailableCount => items.where((i) => !i.isAvailable).length;

  IconData iconFor(String category) =>
      DummyMenu.categoryIcons[category] ?? Icons.restaurant_menu_rounded;

  int countIn(String category) =>
      items.where((i) => i.category == category).length;

  /// Items grouped in [categories] order; empty categories are omitted.
  Map<String, List<VendorMenuItem>> get grouped {
    final map = <String, List<VendorMenuItem>>{};
    for (final c in categories) {
      final list = items.where((i) => i.category == c).toList();
      if (list.isNotEmpty) map[c] = list;
    }
    return map;
  }

  VendorMenuItem? findById(String id) =>
      items.firstWhereOrNull((i) => i.id == id);

  void toggleAvailability(String id, bool available) {
    final i = items.indexWhere((e) => e.id == id);
    if (i != -1) items[i] = items[i].copyWith(isAvailable: available);
  }

  void add(VendorMenuItem item) => items.add(item);

  void updateItem(VendorMenuItem item) {
    final i = items.indexWhere((e) => e.id == item.id);
    if (i != -1) items[i] = item;
  }

  /// Returns the removed index so the caller can offer undo.
  int remove(String id) {
    final i = items.indexWhere((e) => e.id == id);
    if (i != -1) items.removeAt(i);
    return i;
  }

  void restore(int index, VendorMenuItem item) {
    items.insert(index.clamp(0, items.length), item);
  }

  String newId() => 'm${DateTime.now().microsecondsSinceEpoch}';
}
