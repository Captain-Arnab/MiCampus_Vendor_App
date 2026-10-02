import 'package:get/get.dart';

import '../modal/vendor_order.dart';
import 'orders_controller.dart';

enum HomeTab { dashboard, orders, menu, earnings, profile }

class HomeShellController extends GetxController {
  final tab = HomeTab.dashboard.obs;

  void select(HomeTab t) => tab.value = t;

  void openOrders([OrderTab? orderTab]) {
    if (orderTab != null) {
      Get.find<OrdersController>().activeTab.value = orderTab;
    }
    tab.value = HomeTab.orders;
  }
}
