import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Fmt {
  Fmt._();

  static final NumberFormat _inr = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final NumberFormat _compact = NumberFormat.compactCurrency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 1,
  );

  static String inr(num value) => _inr.format(value);

  /// ₹1.2K-style labels for chart axes.
  static String inrCompact(num value) =>
      value < 1000 ? _inr.format(value) : _compact.format(value);

  static String time(DateTime dt) => DateFormat('h:mm a').format(dt);

  static String date(DateTime dt) => DateFormat('d MMM yyyy').format(dt);

  static String dateShort(DateTime dt) => DateFormat('d MMM').format(dt);

  static String weekday(DateTime dt) => DateFormat('EEE').format(dt);

  static String timeOfDay(TimeOfDay t) {
    final dt = DateTime(2000, 1, 1, t.hour, t.minute);
    return DateFormat('h:mm a').format(dt);
  }

  static String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) {
      return '${diff.inHours} hr${diff.inHours == 1 ? '' : 's'} ago';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
    }
    return dateShort(dt);
  }
}
