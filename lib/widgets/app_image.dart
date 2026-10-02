import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Shows a locally picked file, else a cached network image, else a branded
/// placeholder.
class AppImage extends StatelessWidget {
  final String? url;
  final String? localPath;
  final double width;
  final double height;
  final double radius;
  final IconData placeholderIcon;
  final bool greyscale;

  const AppImage({
    super.key,
    this.url,
    this.localPath,
    required this.width,
    required this.height,
    this.radius = 12,
    this.placeholderIcon = Icons.fastfood_outlined,
    this.greyscale = false,
  });

  Widget _placeholder() => Container(
        width: width,
        height: height,
        color: AppColors.surfaceMuted,
        alignment: Alignment.center,
        child: Icon(
          placeholderIcon,
          color: AppColors.textSecondary,
          size: (width < height ? width : height) * 0.38,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final cacheW = (width * dpr).round();

    Widget child;
    if (localPath != null && localPath!.isNotEmpty) {
      child = Image.file(
        File(localPath!),
        width: width,
        height: height,
        fit: BoxFit.cover,
        cacheWidth: cacheW,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    } else if (url != null && url!.isNotEmpty) {
      child = CachedNetworkImage(
        imageUrl: url!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        memCacheWidth: cacheW,
        fadeInDuration: const Duration(milliseconds: 150),
        placeholder: (_, __) => _placeholder(),
        errorWidget: (_, __, ___) => _placeholder(),
      );
    } else {
      child = _placeholder();
    }

    if (greyscale) {
      child = ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126, 0.7152, 0.0722, 0, 0, //
          0.2126, 0.7152, 0.0722, 0, 0, //
          0.2126, 0.7152, 0.0722, 0, 0, //
          0, 0, 0, 1, 0,
        ]),
        child: child,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(width: width, height: height, child: child),
    );
  }
}
