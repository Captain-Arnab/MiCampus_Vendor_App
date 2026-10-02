import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import 'vendor_brand.dart';

/// Shared auth shell: orange→navy gradient + wordmark + title.
class AuthGradientScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  final String subtitle;

  /// When false, [child] fills remaining space (for multi-step flows).
  final bool scrollable;

  /// Shows a back chevron in the top-left when set.
  final VoidCallback? onBack;

  const AuthGradientScaffold({
    super.key,
    required this.child,
    required this.title,
    required this.subtitle,
    this.scrollable = true,
    this.onBack,
  });

  static const _gradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: AppColors.brandGradient,
      stops: [0.0, 0.55, 1.0],
    ),
  );

  Widget _header({required bool compact}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VendorWordmark(logoHeight: compact ? 34 : 46),
        SizedBox(height: compact ? 10.h : 16.h),
        Text(
          title,
          style: GoogleFonts.sora(
            fontSize: compact ? 24.sp : 30.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.4,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: compact ? 4.h : 6.h),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: compact ? 16.h : 24.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: _gradient,
          child: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: scrollable
                      ? Center(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.w, vertical: 20.h),
                            child: Column(
                              children: [
                                _header(compact: false),
                                child,
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 8.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _header(compact: true),
                              Expanded(child: child),
                            ],
                          ),
                        ),
                ),
                if (onBack != null)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: IconButton(
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  /// When true, expands to fill available height (multi-step auth).
  final bool expand;

  const AuthCard({
    super.key,
    required this.child,
    this.padding,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
    if (!expand) return card;
    return SizedBox.expand(child: card);
  }
}

/// Pill segmented control (Veg/Non-veg, etc.).
class AuthSegmentedControl<T> extends StatelessWidget {
  final List<({T value, String label, IconData? icon})> options;
  final T selected;
  final ValueChanged<T> onChanged;

  /// Optional per-option active colour; defaults to the accent.
  final Color Function(T value)? activeColor;

  const AuthSegmentedControl({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: options.map((opt) {
          final active = opt.value == selected;
          final color = activeColor?.call(opt.value) ?? AppColors.accent;
          return Expanded(
            child: Material(
              color: active ? color : Colors.transparent,
              borderRadius: BorderRadius.circular(11),
              child: InkWell(
                onTap: () => onChanged(opt.value),
                borderRadius: BorderRadius.circular(11),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (opt.icon != null) ...[
                        Icon(
                          opt.icon,
                          size: 16.sp,
                          color: active ? Colors.white : AppColors.navyMuted,
                        ),
                        SizedBox(width: 6.w),
                      ],
                      Flexible(
                        child: Text(
                          opt.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: active ? Colors.white : AppColors.navyMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Text field with focus border + soft shadow. Used on auth screens and
/// in-app forms alike.
class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLines = 1,
    this.inputFormatters,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.focusNode,
    this.onSubmitted,
    this.onChanged,
    this.errorText,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late final FocusNode _focus;
  bool _ownedFocus = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      _focus = widget.focusNode!;
    } else {
      _focus = FocusNode();
      _ownedFocus = true;
    }
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    if (_ownedFocus) _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;
    final hasError =
        widget.errorText != null && widget.errorText!.trim().isNotEmpty;
    final borderColor = hasError
        ? Colors.red.shade400
        : (focused ? AppColors.accent : AppColors.border);
    final borderWidth = (hasError || focused) ? 2.0 : 1.0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.button),
        boxShadow: focused && !hasError
            ? [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.22),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focus,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        inputFormatters: widget.inputFormatters,
        textCapitalization: widget.textCapitalization,
        textInputAction: widget.textInputAction,
        onSubmitted: widget.onSubmitted,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          counterText: '',
          errorText: hasError ? widget.errorText : null,
          alignLabelWithHint: widget.maxLines > 1,
          prefixIcon: Padding(
            padding: EdgeInsets.only(bottom: widget.maxLines > 1 ? 40.h : 0),
            child: Icon(
              widget.prefixIcon,
              color: hasError ? Colors.red.shade400 : AppColors.accent,
            ),
          ),
          suffixIcon: widget.suffixIcon,
          filled: true,
          fillColor: AppColors.surface,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
            borderSide: BorderSide(color: borderColor, width: borderWidth),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
            borderSide: BorderSide(color: borderColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
            borderSide: BorderSide(color: Colors.red.shade400, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
            borderSide: BorderSide(color: Colors.red.shade400, width: 2),
          ),
        ),
      ),
    );
  }
}

/// Select field with the same chrome as [AuthTextField]; opens a branded
/// bottom-sheet picker instead of Material's overlay menu.
class AppDropdownField<T> extends StatelessWidget {
  final T? value;
  final String label;
  final IconData prefixIcon;
  final List<({T value, String label})> items;
  final ValueChanged<T?> onChanged;
  final String? errorText;

  /// Picker sheet heading; defaults to "Select [label]".
  final String? sheetTitle;
  final IconData Function(T value)? itemIcon;
  final String? Function(T value)? itemSubtitle;

  const AppDropdownField({
    super.key,
    required this.value,
    required this.label,
    required this.prefixIcon,
    required this.items,
    required this.onChanged,
    this.errorText,
    this.sheetTitle,
    this.itemIcon,
    this.itemSubtitle,
  });

  Future<void> _open(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final picked = await showModalBottomSheet<({T value})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      builder: (_) => _PickerSheet<T>(
        title: sheetTitle ?? 'Select ${label.toLowerCase()}',
        items: items,
        selected: value,
        itemIcon: itemIcon,
        itemSubtitle: itemSubtitle,
        fallbackIcon: prefixIcon,
      ),
    );
    if (picked != null) onChanged(picked.value);
  }

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.trim().isNotEmpty;
    final selectedLabel =
        items.where((i) => i.value == value).map((i) => i.label).firstOrNull;
    final leadIcon =
        value != null && itemIcon != null ? itemIcon!(value as T) : prefixIcon;
    final accent = hasError ? Colors.red.shade400 : AppColors.accent;

    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: BorderSide(color: c, width: w),
        );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _open(context),
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: InputDecorator(
          isEmpty: selectedLabel == null,
          decoration: InputDecoration(
            labelText: label,
            errorText: hasError ? errorText : null,
            prefixIcon: Icon(leadIcon, color: accent),
            suffixIcon: Icon(Icons.unfold_more_rounded, color: accent),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            border: border(AppColors.border),
            enabledBorder: border(hasError ? Colors.red.shade400 : AppColors.border,
                hasError ? 2 : 1),
            errorBorder: border(Colors.red.shade400, 2),
          ),
          child: Text(
            selectedLabel ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _PickerSheet<T> extends StatelessWidget {
  final String title;
  final List<({T value, String label})> items;
  final T? selected;
  final IconData Function(T value)? itemIcon;
  final String? Function(T value)? itemSubtitle;
  final IconData fallbackIcon;

  const _PickerSheet({
    required this.title,
    required this.items,
    required this.selected,
    required this.itemIcon,
    required this.itemSubtitle,
    required this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
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
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  title,
                  style: GoogleFonts.sora(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8.h),
                  itemBuilder: (context, i) {
                    final item = items[i];
                    final active = item.value == selected;
                    final subtitle = itemSubtitle?.call(item.value);
                    return Material(
                      color: active
                          ? AppColors.accent.withValues(alpha: 0.06)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.button),
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop((value: item.value)),
                        borderRadius: BorderRadius.circular(AppRadius.button),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppRadius.button),
                            border: Border.all(
                              color: active ? AppColors.accent : AppColors.border,
                              width: active ? 1.6 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  color: active
                                      ? AppColors.accent
                                      : AppColors.accent.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  itemIcon?.call(item.value) ?? fallbackIcon,
                                  size: 20.sp,
                                  color:
                                      active ? Colors.white : AppColors.accent,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.label,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: active
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                        color: AppColors.navy,
                                      ),
                                    ),
                                    if (subtitle != null) ...[
                                      SizedBox(height: 2.h),
                                      Text(
                                        subtitle,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Icon(
                                active
                                    ? Icons.check_circle_rounded
                                    : Icons.radio_button_unchecked_rounded,
                                color: active
                                    ? AppColors.accent
                                    : AppColors.border,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthPrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
  });

  @override
  State<AuthPrimaryButton> createState() => _AuthPrimaryButtonState();
}

class _AuthPrimaryButtonState extends State<AuthPrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final canTap = widget.onPressed != null && !widget.loading;
    final showAccent = canTap || widget.loading;
    return GestureDetector(
      onTapDown: canTap ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: canTap
          ? (_) {
              setState(() => _pressed = false);
              widget.onPressed?.call();
            }
          : null,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 110),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 110),
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: showAccent ? AppColors.accent : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(AppRadius.button),
            boxShadow: showAccent
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Center(
            heightFactor: 1,
            child: widget.loading
                ? SizedBox(
                    width: 22.w,
                    height: 22.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.label,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color:
                              showAccent ? Colors.white : Colors.grey.shade600,
                        ),
                      ),
                      if (widget.icon != null) ...[
                        SizedBox(width: 8.w),
                        Icon(widget.icon, color: Colors.white, size: 18.sp),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class AuthStepProgress extends StatelessWidget {
  final int currentStep; // 0-based
  final int totalSteps;
  final List<String> labels;

  const AuthStepProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step ${currentStep + 1} of $totalSteps',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: List.generate(totalSteps, (i) {
            final done = i < currentStep;
            final active = i == currentStep;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: EdgeInsets.only(right: i == totalSteps - 1 ? 0 : 6.w),
                height: 5.h,
                decoration: BoxDecoration(
                  color: (done || active) ? AppColors.accent : AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 6.h),
        Text(
          labels[currentStep.clamp(0, labels.length - 1)],
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }
}
