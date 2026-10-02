import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/orders_controller.dart';
import '../modal/vendor_order.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/order_card.dart';
import '../widgets/vendor_app_bar.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView>
    with SingleTickerProviderStateMixin {
  final OrdersController _c = Get.find<OrdersController>();
  late final TabController _tab;
  late final Worker _tabWorker;

  @override
  void initState() {
    super.initState();
    _tab = TabController(
      length: OrderTab.values.length,
      vsync: this,
      initialIndex: _c.activeTab.value.index,
    );
    _tab.addListener(() {
      if (!_tab.indexIsChanging) {
        _c.activeTab.value = OrderTab.values[_tab.index];
      }
    });
    _tabWorker = ever<OrderTab>(_c.activeTab, (t) {
      if (_tab.index != t.index) _tab.animateTo(t.index);
    });
  }

  @override
  void dispose() {
    _tabWorker.dispose();
    _tab.dispose();
    super.dispose();
  }

  static const _emptyCopy = {
    OrderTab.newOrders: ('No new orders', 'New orders from students will pop up here.'),
    OrderTab.preparing: ('Kitchen is clear', 'Accepted orders you’re preparing show here.'),
    OrderTab.ready: ('Nothing waiting for pickup', 'Orders marked ready will wait here until collected.'),
    OrderTab.completed: ('No completed orders yet', 'Picked-up orders for today will be listed here.'),
    OrderTab.cancelled: ('No cancellations', 'Rejected or cancelled orders show up here.'),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VendorAppBar(
        titleText: 'Orders',
        automaticallyImplyLeading: false,
        actions: const [NotificationBell()],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(52.h),
          child: Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Obx(() {
              // Touch the list so counts refresh on every status change.
              _c.orders.length;
              return TabBar(
                controller: _tab,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                labelPadding: EdgeInsets.symmetric(horizontal: 4.w),
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                ),
                labelColor: AppColors.accentDark,
                unselectedLabelColor: Colors.white,
                labelStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
                unselectedLabelStyle:
                    TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                splashBorderRadius: BorderRadius.circular(999),
                tabs: OrderTab.values.map((t) {
                  final count = _c.countFor(t);
                  return Tab(
                    height: 36.h,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(count > 0 ? '${t.label} ($count)' : t.label),
                    ),
                  );
                }).toList(),
              );
            }),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: OrderTab.values.map((t) {
          return Obx(() {
            final list = _c.byTab(t);
            if (list.isEmpty) {
              final (title, msg) = _emptyCopy[t]!;
              return EmptyState(icon: t.emptyIcon, title: title, message: msg);
            }
            return ListView.separated(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              itemCount: list.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (_, i) => OrderCard(order: list[i]),
            );
          });
        }).toList(),
      ),
    );
  }
}
