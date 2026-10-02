import 'package:get/get.dart';

import 'earnings_controller.dart';
import 'home_shell_controller.dart';
import 'login_controller.dart';
import 'notifications_controller.dart';
import 'onboarding_controller.dart';
import 'orders_controller.dart';
import 'shop_controller.dart';
import 'vendor_menu_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(() => LoginController());
}

class OnboardingBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(() => OnboardingController());
}

/// Session state lives on the home route: logging out (offAllNamed → login)
/// disposes it, so the next login starts with fresh dummy data.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShopController());
    Get.put(OrdersController());
    Get.put(VendorMenuController());
    Get.put(NotificationsController());
    Get.put(EarningsController());
    Get.put(HomeShellController());
  }
}
