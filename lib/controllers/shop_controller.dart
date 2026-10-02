import 'package:get/get.dart';

import '../data/dummy_vendor.dart';
import '../modal/vendor_shop.dart';

class ShopController extends GetxController {
  final shop = DummyVendor.shop.obs;
  final isOpen = true.obs;

  void setOpen(bool open) => isOpen.value = open;

  void updateShop(VendorShop updated) => shop.value = updated;
}
