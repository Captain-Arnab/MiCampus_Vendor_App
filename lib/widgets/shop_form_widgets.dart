import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../modal/pickup_point.dart';
import '../modal/vendor_shop.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'app_image.dart';
import 'common_widgets.dart';

class FormLabel extends StatelessWidget {
  final String text;
  final String? helper;

  const FormLabel(this.text, {super.key, this.helper});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          if (helper != null) ...[
            SizedBox(height: 2.h),
            Text(
              helper!,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}

class FieldError extends StatelessWidget {
  final String? text;

  const FieldError(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    if (text == null || text!.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(top: 8.h, left: 4.w),
      child: Text(
        text!,
        style: TextStyle(fontSize: 12.sp, color: Colors.red.shade400),
      ),
    );
  }
}

class ShopCategorySelector extends StatelessWidget {
  final ShopCategory? selected;
  final ValueChanged<ShopCategory> onChanged;
  final String? errorText;

  const ShopCategorySelector({
    super.key,
    required this.selected,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: ShopCategory.values.map((c) {
            final active = c == selected;
            return Material(
              color: active ? AppColors.accent : AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.chip),
              child: InkWell(
                onTap: () => onChanged(c),
                borderRadius: BorderRadius.circular(AppRadius.chip),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                    border: Border.all(
                      color: active ? AppColors.accent : AppColors.border,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        c.icon,
                        size: 17.sp,
                        color: active ? Colors.white : AppColors.accent,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        c.label,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: active ? Colors.white : AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        FieldError(errorText),
      ],
    );
  }
}

/// Multi-select pickup points using the student app's pickup card style.
class PickupPointsSelector extends StatelessWidget {
  final Set<PickupPoint> selected;
  final ValueChanged<PickupPoint> onToggle;
  final String? errorText;

  const PickupPointsSelector({
    super.key,
    required this.selected,
    required this.onToggle,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...PickupPoint.values.map((p) {
          final isOn = selected.contains(p);
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.card),
                onTap: () => onToggle(p),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    border: Border.all(
                      color: isOn ? AppColors.accent : AppColors.border,
                      width: isOn ? 1.8 : 1,
                    ),
                    boxShadow: isOn ? AppShadows.card : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44.w,
                        height: 44.w,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(p.icon, color: AppColors.accent),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.label,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15.sp,
                                color: AppColors.navy,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              p.subtitle,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        isOn
                            ? Icons.check_box_rounded
                            : Icons.check_box_outline_blank_rounded,
                        color: isOn ? AppColors.accent : AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        if (errorText != null) FieldError(errorText),
      ],
    );
  }
}

class OperatingHoursField extends StatelessWidget {
  final TimeOfDay open;
  final TimeOfDay close;
  final ValueChanged<TimeOfDay> onOpenChanged;
  final ValueChanged<TimeOfDay> onCloseChanged;
  final String? errorText;

  const OperatingHoursField({
    super.key,
    required this.open,
    required this.close,
    required this.onOpenChanged,
    required this.onCloseChanged,
    this.errorText,
  });

  Future<void> _pick(
    BuildContext context,
    TimeOfDay initial,
    ValueChanged<TimeOfDay> onPicked,
    String help,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      helpText: help,
    );
    if (picked != null) onPicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    final openMins = open.hour * 60 + open.minute;
    final closeMins = close.hour * 60 + close.minute;
    final overnight = closeMins < openMins;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _TimeTile(
                label: 'Opens at',
                icon: Icons.wb_sunny_outlined,
                value: Fmt.timeOfDay(open),
                onTap: () => _pick(context, open, onOpenChanged, 'Opening time'),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _TimeTile(
                label: 'Closes at',
                icon: Icons.nightlight_outlined,
                value: Fmt.timeOfDay(close),
                onTap: () =>
                    _pick(context, close, onCloseChanged, 'Closing time'),
              ),
            ),
          ],
        ),
        if (overnight && errorText == null)
          Padding(
            padding: EdgeInsets.only(top: 8.h, left: 4.w),
            child: Text(
              'Closes after midnight (next day).',
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ),
        FieldError(errorText),
      ],
    );
  }
}

class _TimeTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final VoidCallback onTap;

  const _TimeTile({
    required this.label,
    required this.icon,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.button),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.accent, size: 20.sp),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                          fontSize: 11.sp, color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.edit_outlined,
                  size: 16.sp, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

/// Result of [pickPhoto]: a new local path, or [removed] when cleared.
typedef PhotoPickResult = ({String? path, bool removed});

/// Camera / gallery chooser. Images stay local — no upload in Phase 1.
Future<PhotoPickResult?> pickPhoto({bool canRemove = false}) async {
  final choice = await Get.bottomSheet<String>(
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                canRemove ? 'Change photo' : 'Add a photo',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            _SheetOption(
              icon: Icons.photo_camera_outlined,
              label: 'Take a photo',
              onTap: () => Get.back(result: 'camera'),
            ),
            _SheetOption(
              icon: Icons.photo_library_outlined,
              label: 'Choose from gallery',
              onTap: () => Get.back(result: 'gallery'),
            ),
            if (canRemove)
              _SheetOption(
                icon: Icons.delete_outline_rounded,
                label: 'Remove photo',
                color: AppColors.error,
                onTap: () => Get.back(result: 'remove'),
              ),
          ],
        ),
      ),
    ),
  );
  if (choice == null) return null;
  if (choice == 'remove') return (path: null, removed: true);

  try {
    final file = await ImagePicker().pickImage(
      source: choice == 'camera' ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 85,
    );
    if (file == null) return null;
    return (path: file.path, removed: false);
  } catch (_) {
    AppSnack.show(
      'Couldn’t open the ${choice == 'camera' ? 'camera' : 'gallery'}',
      icon: Icons.error_outline_rounded,
      iconColor: AppColors.error,
    );
    return null;
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.navy,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      leading: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: (color == AppColors.navy ? AppColors.accent : color)
              .withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: color == AppColors.navy ? AppColors.accent : color,
        ),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

/// Tappable photo slot with camera badge.
class PhotoPickerTile extends StatelessWidget {
  final String? localPath;
  final String? url;
  final double size;
  final String title;
  final String subtitle;
  final IconData placeholderIcon;
  final ValueChanged<PhotoPickResult> onResult;

  const PhotoPickerTile({
    super.key,
    required this.onResult,
    this.localPath,
    this.url,
    this.size = 84,
    this.title = 'Shop photo / logo',
    this.subtitle = 'Square image works best. JPG or PNG.',
    this.placeholderIcon = Icons.storefront_rounded,
  });

  bool get _hasPhoto =>
      (localPath != null && localPath!.isNotEmpty) ||
      (url != null && url!.isNotEmpty);

  Future<void> _pick() async {
    final r = await pickPhoto(canRemove: _hasPhoto);
    if (r != null) onResult(r);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pick,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AppImage(
                  localPath: localPath,
                  url: url,
                  width: size.w,
                  height: size.w,
                  radius: 16,
                  placeholderIcon: placeholderIcon,
                ),
                Positioned(
                  right: -6,
                  bottom: -6,
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(Icons.photo_camera_rounded,
                        size: 14.sp, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                        fontSize: 12.sp, color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    _hasPhoto ? 'Change photo' : 'Upload photo',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
