import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/vendor_menu_controller.dart';
import '../modal/menu_item.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/common_widgets.dart';
import '../widgets/shop_form_widgets.dart';
import '../widgets/vendor_app_bar.dart';

/// Add (no argument) or edit (argument: item id) a menu item.
class MenuItemFormView extends StatefulWidget {
  const MenuItemFormView({super.key});

  @override
  State<MenuItemFormView> createState() => _MenuItemFormViewState();
}

class _MenuItemFormViewState extends State<MenuItemFormView> {
  final _c = Get.find<VendorMenuController>();
  VendorMenuItem? _editing;

  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  String? _category;
  bool _isVeg = true;
  bool _available = true;
  String? _imageUrl;
  String? _localPath;
  final Map<String, String> _errors = {};

  bool get _isEdit => _editing != null;

  @override
  void initState() {
    super.initState();
    final id = Get.arguments as String?;
    if (id != null) _editing = _c.findById(id);
    final e = _editing;
    if (e != null) {
      _nameCtrl.text = e.name;
      _descCtrl.text = e.description;
      _priceCtrl.text = e.price % 1 == 0
          ? e.price.toStringAsFixed(0)
          : e.price.toStringAsFixed(2);
      _category = e.category;
      _isVeg = e.isVeg;
      _available = e.isAvailable;
      _imageUrl = e.imageUrl;
      _localPath = e.localImagePath;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  void _clearError(String key) {
    if (_errors.containsKey(key)) setState(() => _errors.remove(key));
  }

  void _save() {
    FocusManager.instance.primaryFocus?.unfocus();
    final errors = <String, String>{};
    final name = _nameCtrl.text.trim();
    final price = double.tryParse(_priceCtrl.text.trim());
    if (name.isEmpty) errors['name'] = 'Enter the item name';
    if (price == null || price <= 0) errors['price'] = 'Enter a valid price';
    if (_category == null) errors['category'] = 'Choose a category';
    setState(() => _errors
      ..clear()
      ..addAll(errors));
    if (errors.isNotEmpty) return;

    final item = VendorMenuItem(
      id: _editing?.id ?? _c.newId(),
      name: name,
      description: _descCtrl.text.trim(),
      price: price!,
      category: _category!,
      isVeg: _isVeg,
      isAvailable: _available,
      imageUrl: _imageUrl,
      localImagePath: _localPath,
    );
    if (_isEdit) {
      _c.updateItem(item);
    } else {
      _c.add(item);
    }
    Get.back();
    AppSnack.show(_isEdit ? '$name updated' : '$name added to menu');
  }

  Future<void> _delete() async {
    final e = _editing!;
    final ok = await showConfirmDialog(
      title: 'Delete item?',
      message: '“${e.name}” will be removed from your menu.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!ok) return;
    final index = _c.remove(e.id);
    Get.back();
    AppSnack.show(
      '${e.name} deleted',
      icon: Icons.delete_outline_rounded,
      actionLabel: 'UNDO',
      onAction: () => _c.restore(index, e),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VendorAppBar(
        titleText: _isEdit ? 'Edit Item' : 'Add Item',
        actions: [
          if (_isEdit)
            IconButton(
              tooltip: 'Delete',
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline_rounded),
            ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        children: [
          PhotoPickerTile(
            title: 'Item photo',
            subtitle: 'A clear, well-lit photo helps students choose.',
            placeholderIcon: Icons.fastfood_outlined,
            url: _imageUrl,
            localPath: _localPath,
            onResult: (r) => setState(() {
              if (r.removed) {
                _localPath = null;
                _imageUrl = null;
              } else {
                _localPath = r.path;
              }
            }),
          ),
          SizedBox(height: 20.h),
          AuthTextField(
            controller: _nameCtrl,
            label: 'Item name',
            hint: 'e.g. Paneer Butter Masala',
            prefixIcon: Icons.restaurant_rounded,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            errorText: _errors['name'],
            onChanged: (_) => _clearError('name'),
          ),
          SizedBox(height: 14.h),
          AuthTextField(
            controller: _descCtrl,
            label: 'Description',
            hint: 'Ingredients, portion size, spice level…',
            prefixIcon: Icons.notes_rounded,
            maxLines: 3,
            maxLength: 160,
            textCapitalization: TextCapitalization.sentences,
          ),
          SizedBox(height: 14.h),
          AuthTextField(
            controller: _priceCtrl,
            label: 'Price (₹)',
            prefixIcon: Icons.currency_rupee_rounded,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d{0,5}(\.\d{0,2})?')),
            ],
            errorText: _errors['price'],
            onChanged: (_) => _clearError('price'),
          ),
          SizedBox(height: 14.h),
          AppDropdownField<String>(
            value: _category,
            label: 'Category',
            prefixIcon: Icons.category_outlined,
            errorText: _errors['category'],
            sheetTitle: 'Choose a category',
            itemIcon: _c.iconFor,
            itemSubtitle: (c) {
              final n = _c.countIn(c);
              return n == 0 ? 'No items yet' : '$n item${n == 1 ? '' : 's'}';
            },
            items: _c.categories.map((c) => (value: c, label: c)).toList(),
            onChanged: (v) => setState(() {
              _category = v;
              _errors.remove('category');
            }),
          ),
          SizedBox(height: 20.h),
          const FormLabel('Food type'),
          AuthSegmentedControl<bool>(
            selected: _isVeg,
            onChanged: (v) => setState(() => _isVeg = v),
            activeColor: (v) => v ? AppColors.success : AppColors.error,
            options: const [
              (value: true, label: 'Veg', icon: Icons.eco_outlined),
              (value: false, label: 'Non-veg', icon: Icons.set_meal_outlined),
            ],
          ),
          SizedBox(height: 20.h),
          SectionCard(
            padding: EdgeInsets.fromLTRB(16.w, 6.h, 8.w, 6.h),
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _available,
              onChanged: (v) => setState(() => _available = v),
              title: Text(
                'Available to order',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              subtitle: Text(
                _available
                    ? 'Students can add this item to their cart'
                    : 'Shown as sold out to students',
                style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
          child: AuthPrimaryButton(
            label: _isEdit ? 'Save changes' : 'Add to menu',
            onPressed: _save,
          ),
        ),
      ),
    );
  }
}
