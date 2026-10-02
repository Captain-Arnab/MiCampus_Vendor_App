import 'package:get/get.dart';

import '../controllers/bindings.dart';
import '../views/edit_shop_view.dart';
import '../views/home_shell_view.dart';
import '../views/login_view.dart';
import '../views/menu_item_form_view.dart';
import '../views/notifications_view.dart';
import '../views/onboarding_view.dart';
import '../views/order_detail_view.dart';
import '../views/pending_approval_view.dart';
import '../views/splash_view.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const login = '/login';
  static const onboarding = '/onboarding';
  static const pendingApproval = '/pending-approval';
  static const home = '/home';

  /// Argument: order id (String).
  static const orderDetail = '/order-detail';

  /// Argument: menu item id (String) to edit, or null to add.
  static const menuItemForm = '/menu-item';
  static const editShop = '/edit-shop';
  static const notifications = '/notifications';

  static final pages = <GetPage>[
    GetPage(name: splash, page: () => const SplashView()),
    GetPage(name: login, page: () => const LoginView(), binding: LoginBinding()),
    GetPage(
      name: onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(name: pendingApproval, page: () => const PendingApprovalView()),
    GetPage(name: home, page: () => const HomeShellView(), binding: HomeBinding()),
    GetPage(name: orderDetail, page: () => const OrderDetailView()),
    GetPage(name: menuItemForm, page: () => const MenuItemFormView()),
    GetPage(name: editShop, page: () => const EditShopView()),
    GetPage(name: notifications, page: () => const NotificationsView()),
  ];
}
