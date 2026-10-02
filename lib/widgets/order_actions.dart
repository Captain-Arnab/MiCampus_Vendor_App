import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/orders_controller.dart';
import '../modal/vendor_order.dart';
import '../theme/app_theme.dart';
import 'auth_widgets.dart';
import 'common_widgets.dart';

/// Status-appropriate buttons for an order (card + detail screen).
class OrderActions extends StatelessWidget {
  final VendorOrder order;
  final bool large;

  const OrderActions({super.key, required this.order, this.large = false});

  static IconData _iconFor(OrderStatus s) {
    switch (s) {
      case OrderStatus.accepted:
        return Icons.soup_kitchen_rounded;
      case OrderStatus.preparing:
        return Icons.shopping_bag_rounded;
      case OrderStatus.ready:
        return Icons.task_alt_rounded;
      default:
        return Icons.check_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = order.status;
    final vPad = large ? 15.h : 11.h;
    final textStyle = TextStyle(
      fontSize: large ? 15.sp : 13.sp,
      fontWeight: FontWeight.w700,
    );

    if (status == OrderStatus.newOrder) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => OrderActionHandler.reject(order),
              icon: Icon(Icons.close_rounded, size: 18.sp),
              label: Text('Reject', style: textStyle),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
                padding: EdgeInsets.symmetric(vertical: vPad),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () => OrderActionHandler.advance(order),
              icon: Icon(Icons.check_rounded, size: 18.sp),
              label: Text('Accept', style: textStyle),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: EdgeInsets.symmetric(vertical: vPad),
              ),
            ),
          ),
        ],
      );
    }

    final label = status.actionLabel;
    if (label == null) return const SizedBox.shrink();
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => OrderActionHandler.advance(order),
        icon: Icon(_iconFor(status), size: 18.sp),
        label: Text(label, style: textStyle),
        style: ElevatedButton.styleFrom(
          backgroundColor: status.next!.color,
          padding: EdgeInsets.symmetric(vertical: vPad),
        ),
      ),
    );
  }
}

class OrderActionHandler {
  OrderActionHandler._();

  static OrdersController get _c => Get.find<OrdersController>();

  static void advance(VendorOrder order) {
    final next = order.status.next;
    if (next == null) return;
    _c.advance(order.id);
    final msg = switch (next) {
      OrderStatus.accepted => 'Order #${order.id} accepted',
      OrderStatus.preparing => 'Order #${order.id} is being prepared',
      OrderStatus.ready => 'Order #${order.id} ready — customer notified',
      OrderStatus.completed => 'Order #${order.id} marked as picked up',
      _ => 'Order updated',
    };
    AppSnack.show(msg, icon: next.icon, iconColor: next.color);
  }

  static Future<void> reject(VendorOrder order) async {
    final reason = await Get.bottomSheet<String>(
      RejectOrderSheet(order: order),
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );
    if (reason == null) return;
    _c.reject(order.id, reason);
    AppSnack.show(
      'Order #${order.id} rejected',
      icon: Icons.cancel_rounded,
      iconColor: AppColors.error,
    );
  }
}

/// Reject flow: reason dropdown (+ free text for "Other"). Pops with the
/// reason string, or null when dismissed.
class RejectOrderSheet extends StatefulWidget {
  final VendorOrder order;

  const RejectOrderSheet({super.key, required this.order});

  @override
  State<RejectOrderSheet> createState() => _RejectOrderSheetState();
}

class _RejectOrderSheetState extends State<RejectOrderSheet> {
  RejectReason? _reason;
  final _otherCtrl = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _otherCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_reason == null) {
      setState(() => _error = 'Select a reason');
      return;
    }
    if (_reason == RejectReason.other) {
      final text = _otherCtrl.text.trim();
      if (text.isEmpty) {
        setState(() => _error = 'Tell the customer why');
        return;
      }
      Get.back(result: text);
      return;
    }
    Get.back(result: _reason!.label);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
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
              SizedBox(height: 16.h),
              Text(
                'Reject order #${widget.order.id}?',
                style: GoogleFonts.sora(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                '${widget.order.customerDisplayName} will be notified with the reason you choose.',
                style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
              ),
              SizedBox(height: 18.h),
              AppDropdownField<RejectReason>(
                value: _reason,
                label: 'Reason',
                prefixIcon: Icons.report_gmailerrorred_rounded,
                errorText: _reason == null ? _error : null,
                sheetTitle: 'Why are you rejecting?',
                itemIcon: (r) => r.icon,
                items: RejectReason.values
                    .map((r) => (value: r, label: r.label))
                    .toList(),
                onChanged: (r) => setState(() {
                  _reason = r;
                  _error = null;
                }),
              ),
              if (_reason == RejectReason.other) ...[
                SizedBox(height: 12.h),
                AuthTextField(
                  controller: _otherCtrl,
                  label: 'Describe the reason',
                  prefixIcon: Icons.edit_note_rounded,
                  maxLines: 2,
                  maxLength: 120,
                  textCapitalization: TextCapitalization.sentences,
                  errorText: _error,
                  onChanged: (_) {
                    if (_error != null) setState(() => _error = null);
                  },
                ),
              ],
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: const Text('Keep order'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                      ),
                      child: const Text('Reject order'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
