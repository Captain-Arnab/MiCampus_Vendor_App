import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/shop_controller.dart';
import '../modal/pickup_point.dart';
import '../modal/vendor_shop.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/common_widgets.dart';
import '../widgets/shop_form_widgets.dart';
import '../widgets/vendor_app_bar.dart';

/// Post-approval shop settings — same fields as onboarding.
class EditShopView extends StatefulWidget {
  const EditShopView({super.key});

  @override
  State<EditShopView> createState() => _EditShopViewState();
}

class _EditShopViewState extends State<EditShopView> {
  final _shop = Get.find<ShopController>();

  late final TextEditingController _nameCtrl;
  late ShopCategory _category;
  late Set<PickupPoint> _pickup;
  late TimeOfDay _open;
  late TimeOfDay _close;
  String? _logoUrl;
  String? _logoPath;
  final Map<String, String> _errors = {};

  @override
  void initState() {
    super.initState();
    final s = _shop.shop.value;
    _nameCtrl = TextEditingController(text: s.shopName);
    _category = s.category;
    _pickup = {...s.pickupPoints};
    _open = s.openTime;
    _close = s.closeTime;
    _logoUrl = s.logoUrl;
    _logoPath = s.logoLocalPath;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _save() {
    FocusManager.instance.primaryFocus?.unfocus();
    final errors = <String, String>{};
    if (_nameCtrl.text.trim().isEmpty) errors['name'] = 'Enter your shop name';
    if (_pickup.isEmpty) errors['pickup'] = 'Select at least one pickup point';
    final openMins = _open.hour * 60 + _open.minute;
    final closeMins = _close.hour * 60 + _close.minute;
    if (openMins == closeMins) {
      errors['hours'] = 'Opening and closing time can’t be the same';
    }
    setState(() => _errors
      ..clear()
      ..addAll(errors));
    if (errors.isNotEmpty) return;

    final current = _shop.shop.value;
    _shop.updateShop(VendorShop(
      id: current.id,
      shopName: _nameCtrl.text.trim(),
      ownerName: current.ownerName,
      phone: current.phone,
      email: current.email,
      category: _category,
      logoUrl: _logoUrl,
      logoLocalPath: _logoPath,
      pickupPoints: _pickup,
      openTime: _open,
      closeTime: _close,
      approvalStatus: current.approvalStatus,
      rating: current.rating,
      ratingCount: current.ratingCount,
    ));
    Get.back();
    AppSnack.show('Shop info updated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VendorAppBar(titleText: 'Edit Shop Info'),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        children: [
          PhotoPickerTile(
            url: _logoUrl,
            localPath: _logoPath,
            onResult: (r) => setState(() {
              if (r.removed) {
                _logoPath = null;
                _logoUrl = null;
              } else {
                _logoPath = r.path;
              }
            }),
          ),
          SizedBox(height: 20.h),
          AuthTextField(
            controller: _nameCtrl,
            label: 'Shop name',
            prefixIcon: Icons.storefront_rounded,
            textCapitalization: TextCapitalization.words,
            errorText: _errors['name'],
            onChanged: (_) {
              if (_errors.containsKey('name')) {
                setState(() => _errors.remove('name'));
              }
            },
          ),
          SizedBox(height: 22.h),
          const FormLabel('Shop category'),
          ShopCategorySelector(
            selected: _category,
            onChanged: (v) => setState(() => _category = v),
          ),
          SizedBox(height: 22.h),
          const FormLabel('Pickup points',
              helper: 'Where students can collect their orders.'),
          PickupPointsSelector(
            selected: _pickup,
            errorText: _errors['pickup'],
            onToggle: (p) => setState(() {
              _pickup.contains(p) ? _pickup.remove(p) : _pickup.add(p);
              _errors.remove('pickup');
            }),
          ),
          SizedBox(height: 10.h),
          const FormLabel('Operating hours'),
          OperatingHoursField(
            open: _open,
            close: _close,
            errorText: _errors['hours'],
            onOpenChanged: (t) => setState(() {
              _open = t;
              _errors.remove('hours');
            }),
            onCloseChanged: (t) => setState(() {
              _close = t;
              _errors.remove('hours');
            }),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
          child: AuthPrimaryButton(label: 'Save changes', onPressed: _save),
        ),
      ),
    );
  }
}
