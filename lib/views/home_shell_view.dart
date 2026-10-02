import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/home_shell_controller.dart';
import '../controllers/orders_controller.dart';
import '../theme/app_theme.dart';
import 'dashboard_view.dart';
import 'earnings_view.dart';
import 'menu_view.dart';
import 'orders_view.dart';
import 'profile_view.dart';

class HomeShellView extends GetView<HomeShellController> {
  const HomeShellView({super.key});

  static const _pages = <Widget>[
    DashboardView(),
    OrdersView(),
    MenuView(),
    EarningsView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final orders = Get.find<OrdersController>();
    return Obx(() {
      final current = controller.tab.value;
      return PopScope(
        canPop: current == HomeTab.dashboard,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) controller.select(HomeTab.dashboard);
        },
        child: Scaffold(
          body: IndexedStack(index: current.index, children: _pages),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.navy.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: current.index,
              onTap: (i) => controller.select(HomeTab.values[i]),
              elevation: 0,
              selectedFontSize: 12.sp,
              unselectedFontSize: 11.sp,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.space_dashboard_outlined),
                  activeIcon: Icon(Icons.space_dashboard_rounded),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: _badged(orders.newCount,
                      const Icon(Icons.receipt_long_outlined)),
                  activeIcon: _badged(orders.newCount,
                      const Icon(Icons.receipt_long_rounded)),
                  label: 'Orders',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.restaurant_menu_outlined),
                  activeIcon: Icon(Icons.restaurant_menu_rounded),
                  label: 'Menu',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet_outlined),
                  activeIcon: Icon(Icons.account_balance_wallet_rounded),
                  label: 'Earnings',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.storefront_outlined),
                  activeIcon: Icon(Icons.storefront_rounded),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  static Widget _badged(int count, Widget icon) {
    return Badge(
      isLabelVisible: count > 0,
      backgroundColor: AppColors.accent,
      label: Text('$count'),
      child: icon,
    );
  }
}
