import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

/// MiCampus mark on a white tile, sized for gradient app bars.
class BrandLogoTile extends StatelessWidget {
  final double height;

  const BrandLogoTile({super.key, this.height = 30});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(
        horizontal: height * 0.22,
        vertical: height * 0.1,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(height * 0.28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Image.asset(
        'assets/images/logo.jpeg',
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
      ),
    );
  }
}

/// MiCampus mark on a white tile + "VENDOR" tag — related to, but distinct
/// from, the student app lockup.
class VendorWordmark extends StatelessWidget {
  final double logoHeight;
  final bool onDark;
  final Axis direction;

  const VendorWordmark({
    super.key,
    this.logoHeight = 48,
    this.onDark = true,
    this.direction = Axis.vertical,
  });

  /// Compact horizontal lockup for gradient app bars.
  const VendorWordmark.appBar({super.key})
      : logoHeight = 26,
        onDark = true,
        direction = Axis.horizontal;

  @override
  Widget build(BuildContext context) {
    final vertical = direction == Axis.vertical;
    final tile = Container(
      padding: EdgeInsets.symmetric(
        horizontal: logoHeight * 0.28,
        vertical: logoHeight * 0.14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(logoHeight * 0.3),
        boxShadow: onDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  blurRadius: logoHeight * 0.3,
                  offset: Offset(0, logoHeight * 0.1),
                ),
              ]
            : AppShadows.card,
      ),
      child: Image.asset(
        'assets/images/logo.jpeg',
        height: logoHeight,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
      ),
    );

    final tag = Container(
      padding: EdgeInsets.symmetric(
        horizontal: logoHeight * (vertical ? 0.26 : 0.32),
        vertical: logoHeight * (vertical ? 0.09 : 0.14),
      ),
      decoration: BoxDecoration(
        color: onDark
            ? Colors.white.withValues(alpha: 0.16)
            : AppColors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: onDark
              ? Colors.white.withValues(alpha: 0.55)
              : AppColors.accent.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.storefront_rounded,
            size: logoHeight * (vertical ? 0.3 : 0.5),
            color: onDark ? Colors.white : AppColors.accent,
          ),
          SizedBox(width: logoHeight * 0.12),
          Text(
            'VENDOR',
            style: GoogleFonts.sora(
              fontSize: logoHeight * (vertical ? 0.26 : 0.42),
              fontWeight: FontWeight.w700,
              letterSpacing: logoHeight * (vertical ? 0.07 : 0.06),
              color: onDark ? Colors.white : AppColors.accent,
            ),
          ),
        ],
      ),
    );

    return vertical
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [tile, SizedBox(height: logoHeight * 0.26), tag],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [tile, SizedBox(width: logoHeight * 0.36), tag],
          );
  }
}
