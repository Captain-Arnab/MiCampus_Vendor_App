import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/notifications_controller.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import 'vendor_brand.dart';

class VendorAppBarTokens {
  VendorAppBarTokens._();

  static const double bottomRadius = 22;
  static const double scrolledUnderElevation = 6;

  static Color get shadowColor => AppColors.navy.withValues(alpha: 0.2);

  static ShapeBorder get shape => const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(bottom: Radius.circular(bottomRadius)),
      );

  static Decoration gradientDecoration({bool roundedBottom = true}) {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: AppColors.brandGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.55, 1.0],
      ),
      borderRadius: roundedBottom
          ? const BorderRadius.vertical(bottom: Radius.circular(bottomRadius))
          : null,
    );
  }

  static String greeting(String displayName) {
    final hour = DateTime.now().hour;
    final period = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';
    final first = displayName.trim().split(RegExp(r'\s+')).first;
    return first.isEmpty ? period : '$period, $first';
  }
}

/// Accent gradient app bar with rounded bottom — matches the student app's
/// CampusAppBar.
class VendorAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final String? titleText;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;
  final double toolbarHeight;
  final bool centerTitle;

  /// Prefixes [titleText] with the MiCampus logo, like the student app.
  final bool showBrandLockup;

  const VendorAppBar({
    super.key,
    this.title,
    this.titleText,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.bottom,
    this.toolbarHeight = kToolbarHeight,
    this.centerTitle = false,
    this.showBrandLockup = true,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    Widget? titleWidget = title;
    if (titleWidget == null && titleText != null) {
      final label = Text(
        titleText!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.white,
          fontSize: 17.sp,
        ),
      );
      titleWidget = showBrandLockup
          ? BrandTitle(child: label)
          : label;
    }

    return AppBar(
      title: titleWidget,
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      toolbarHeight: toolbarHeight,
      elevation: 0,
      scrolledUnderElevation: VendorAppBarTokens.scrolledUnderElevation,
      shadowColor: VendorAppBarTokens.shadowColor,
      surfaceTintColor: Colors.transparent,
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.white),
      shape: VendorAppBarTokens.shape,
      flexibleSpace:
          Container(decoration: VendorAppBarTokens.gradientDecoration()),
      bottom: bottom,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }
}

/// App bar title row: MiCampus logo · divider · [child].
class BrandTitle extends StatelessWidget {
  final Widget child;
  final double logoHeight;

  const BrandTitle({super.key, required this.child, this.logoHeight = 30});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BrandLogoTile(height: logoHeight),
        SizedBox(width: 10.w),
        Container(
          width: 1,
          height: logoHeight * 0.7,
          color: Colors.white.withValues(alpha: 0.4),
        ),
        SizedBox(width: 10.w),
        Expanded(child: child),
      ],
    );
  }
}

/// Bell with unread badge; opens the notifications list.
class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<NotificationsController>();
    return Padding(
      padding: EdgeInsets.only(right: 6.w),
      child: IconButton(
        tooltip: 'Notifications',
        onPressed: () => Get.toNamed(AppRoutes.notifications),
        icon: Obx(() {
          final unread = c.unreadCount;
          return Badge(
            isLabelVisible: unread > 0,
            backgroundColor: Colors.white,
            textColor: AppColors.accentDark,
            label: Text(
              unread > 9 ? '9+' : '$unread',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            child: const Icon(Icons.notifications_none_rounded, color: Colors.white),
          );
        }),
      ),
    );
  }
}
