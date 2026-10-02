import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'pickup_point.dart';

enum ShopCategory {
  canteen,
  cafe,
  snacks,
  beverages,
  bakery,
}

extension ShopCategoryX on ShopCategory {
  String get label {
    switch (this) {
      case ShopCategory.canteen:
        return 'Canteen';
      case ShopCategory.cafe:
        return 'Café';
      case ShopCategory.snacks:
        return 'Snacks';
      case ShopCategory.beverages:
        return 'Juice & Beverages';
      case ShopCategory.bakery:
        return 'Bakery';
    }
  }

  IconData get icon {
    switch (this) {
      case ShopCategory.canteen:
        return Icons.restaurant_rounded;
      case ShopCategory.cafe:
        return Icons.local_cafe_rounded;
      case ShopCategory.snacks:
        return Icons.fastfood_rounded;
      case ShopCategory.beverages:
        return Icons.local_drink_rounded;
      case ShopCategory.bakery:
        return Icons.bakery_dining_rounded;
    }
  }
}

enum ApprovalStatus { pending, approved, rejected }

extension ApprovalStatusX on ApprovalStatus {
  String get label {
    switch (this) {
      case ApprovalStatus.pending:
        return 'Pending approval';
      case ApprovalStatus.approved:
        return 'Approved';
      case ApprovalStatus.rejected:
        return 'Rejected';
    }
  }

  Color get color {
    switch (this) {
      case ApprovalStatus.pending:
        return AppColors.warning;
      case ApprovalStatus.approved:
        return AppColors.success;
      case ApprovalStatus.rejected:
        return AppColors.error;
    }
  }
}

class VendorShop {
  final String id;
  final String shopName;
  final String ownerName;
  final String phone;
  final String email;
  final ShopCategory category;

  /// Remote logo (dummy URL in Phase 1).
  final String? logoUrl;

  /// Locally picked logo; takes precedence over [logoUrl] until upload exists.
  final String? logoLocalPath;
  final Set<PickupPoint> pickupPoints;
  final TimeOfDay openTime;
  final TimeOfDay closeTime;
  final ApprovalStatus approvalStatus;
  final double rating;
  final int ratingCount;

  const VendorShop({
    required this.id,
    required this.shopName,
    required this.ownerName,
    required this.phone,
    required this.email,
    required this.category,
    required this.pickupPoints,
    required this.openTime,
    required this.closeTime,
    required this.approvalStatus,
    this.logoUrl,
    this.logoLocalPath,
    this.rating = 0,
    this.ratingCount = 0,
  });

  VendorShop copyWith({
    String? shopName,
    String? ownerName,
    String? phone,
    String? email,
    ShopCategory? category,
    String? logoUrl,
    String? logoLocalPath,
    Set<PickupPoint>? pickupPoints,
    TimeOfDay? openTime,
    TimeOfDay? closeTime,
    ApprovalStatus? approvalStatus,
  }) {
    return VendorShop(
      id: id,
      shopName: shopName ?? this.shopName,
      ownerName: ownerName ?? this.ownerName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      category: category ?? this.category,
      logoUrl: logoUrl ?? this.logoUrl,
      logoLocalPath: logoLocalPath ?? this.logoLocalPath,
      pickupPoints: pickupPoints ?? this.pickupPoints,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      rating: rating,
      ratingCount: ratingCount,
    );
  }

  String get pickupPointsLabel {
    final sorted = pickupPoints.toList()..sort((a, b) => a.index - b.index);
    return sorted.map((p) => p.label).join(' · ');
  }
}
