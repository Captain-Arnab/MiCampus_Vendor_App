import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/vendor_menu_controller.dart';
import '../modal/menu_item.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/app_image.dart';
import '../widgets/common_widgets.dart';
import '../widgets/vendor_app_bar.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<VendorMenuController>();
    return Scaffold(
      appBar: const VendorAppBar(
        titleText: 'Menu',
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add item',
        onPressed: () => Get.toNamed(AppRoutes.menuItemForm),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: const Icon(Icons.add_rounded, size: 30),
      ),
      body: Obx(() {
        final grouped = c.grouped;
        if (grouped.isEmpty) {
          return const EmptyState(
            icon: Icons.restaurant_menu_rounded,
            title: 'Your menu is empty',
            message: 'Tap + to add your first dish.',
          );
        }
        return ListView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 96.h),
          children: [
            _MenuSummary(total: c.items.length, unavailable: c.unavailableCount),
            for (final entry in grouped.entries) ...[
              SizedBox(height: 20.h),
              Row(
                children: [
                  Icon(c.iconFor(entry.key), size: 18.sp, color: AppColors.accent),
                  SizedBox(width: 8.w),
                  Text(
                    entry.key,
                    style: GoogleFonts.sora(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${entry.value.length}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navyMuted,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              ...entry.value.map(
                (item) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _MenuItemTile(item: item),
                ),
              ),
            ],
          ],
        );
      }),
    );
  }
}

class _MenuSummary extends StatelessWidget {
  final int total;
  final int unavailable;

  const _MenuSummary({required this.total, required this.unavailable});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Icon(Icons.restaurant_menu_rounded, color: AppColors.accent, size: 20.sp),
          SizedBox(width: 10.w),
          Text(
            '$total items',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const Spacer(),
          if (unavailable > 0)
            StatusChip(
              label: '$unavailable sold out',
              color: AppColors.error,
              icon: Icons.remove_shopping_cart_outlined,
              dense: true,
            )
          else
            const StatusChip(
              label: 'All available',
              color: AppColors.success,
              icon: Icons.check_circle_outline_rounded,
              dense: true,
            ),
        ],
      ),
    );
  }
}

class _MenuItemTile extends StatelessWidget {
  final VendorMenuItem item;

  const _MenuItemTile({required this.item});

  VendorMenuController get _c => Get.find<VendorMenuController>();

  void _edit() => Get.toNamed(AppRoutes.menuItemForm, arguments: item.id);

  Future<bool> _confirmDelete() => showConfirmDialog(
        title: 'Delete item?',
        message: '“${item.name}” will be removed from your menu.',
        confirmLabel: 'Delete',
        destructive: true,
      );

  void _delete() {
    final index = _c.remove(item.id);
    AppSnack.show(
      '${item.name} deleted',
      icon: Icons.delete_outline_rounded,
      actionLabel: 'UNDO',
      onAction: () => _c.restore(index, item),
    );
  }

  @override
  Widget build(BuildContext context) {
    final available = item.isAvailable;
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(),
      onDismissed: (_) => _delete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 24.w),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.delete_outline_rounded, color: Colors.white),
            SizedBox(width: 6.w),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
      child: SectionCard(
        padding: EdgeInsets.fromLTRB(10.w, 10.w, 4.w, 10.w),
        onTap: _edit,
        child: Row(
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: available ? 1 : 0.55,
              child: AppImage(
                url: item.imageUrl,
                localPath: item.localImagePath,
                width: 72.w,
                height: 72.w,
                radius: 14,
                greyscale: !available,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      VegBadge(isVeg: item.isVeg, size: 14),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: available
                                ? AppColors.navy
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    Fmt.inr(item.price),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      SizedBox(
                        height: 26.h,
                        child: FittedBox(
                          child: Switch(
                            value: available,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onChanged: (v) {
                              _c.toggleAvailability(item.id, v);
                              AppSnack.show(
                                v
                                    ? '${item.name} is available again'
                                    : '${item.name} marked sold out',
                                icon: v
                                    ? Icons.check_circle_rounded
                                    : Icons.remove_shopping_cart_rounded,
                                iconColor:
                                    v ? AppColors.success : AppColors.warning,
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        available ? 'Available' : 'Sold out',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color:
                              available ? AppColors.success : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              tooltip: 'More',
              icon: const Icon(Icons.more_vert_rounded,
                  color: AppColors.textSecondary),
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
              onSelected: (v) async {
                if (v == 'edit') {
                  _edit();
                } else if (await _confirmDelete()) {
                  _delete();
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.edit_outlined, color: AppColors.navy),
                    title: Text('Edit'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading:
                        Icon(Icons.delete_outline_rounded, color: AppColors.error),
                    title: Text('Delete',
                        style: TextStyle(color: AppColors.error)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
