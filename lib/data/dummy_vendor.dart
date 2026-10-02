import 'package:flutter/material.dart';

import '../modal/pickup_point.dart';
import '../modal/vendor_shop.dart';

/// Phase 1 mock vendor — loaded on any login.
class DummyVendor {
  DummyVendor._();

  static const VendorShop shop = VendorShop(
    id: 'v_1001',
    shopName: 'Annapurna Canteen',
    ownerName: 'Ramesh Kumar',
    phone: '+91 98765 43210',
    email: 'annapurna.canteen@micampus.in',
    category: ShopCategory.canteen,
    logoUrl:
        'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=400&q=80',
    pickupPoints: {PickupPoint.mainGate, PickupPoint.hostelGate},
    openTime: TimeOfDay(hour: 8, minute: 0),
    closeTime: TimeOfDay(hour: 22, minute: 30),
    approvalStatus: ApprovalStatus.approved,
    rating: 4.3,
    ratingCount: 862,
  );
}
