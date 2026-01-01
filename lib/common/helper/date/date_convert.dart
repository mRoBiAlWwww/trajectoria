import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  // Format 1 Jan 2026
  String toShortDate() {
    return DateFormat('d MMM y', 'id_ID').format(this);
  }

  // Format 1 Januari 2026
  String toFullDate() {
    return DateFormat('d MMMM y', 'id_ID').format(this);
  }

  String toTimeAgo() {
    final Duration difference = DateTime.now().difference(this);

    if (difference.isNegative) return 'baru saja';

    if (difference.inSeconds < 60) {
      return 'baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      final int hours = difference.inHours;
      final int minutes = difference.inMinutes % 60;

      // Jika menit 0, tampilkan jam saja
      if (minutes == 0) return '$hours jam yang lalu';

      return '$hours jam $minutes menit yang lalu';
    } else {
      final int days = difference.inDays;
      final int hours = difference.inHours % 24;

      // Jika jam 0, tampilkan hari saja
      if (hours == 0) return '$days hari yang lalu';

      return '$days hari $hours jam yang lalu';
    }
  }
}

// Extension khusus untuk Firestore Timestamp (otomatis convert .toDate())
extension TimestampExtension on Timestamp {
  String toShortDate() => toDate().toShortDate();
  String toFullDate() => toDate().toFullDate();
  String toTimeAgo() => toDate().toTimeAgo();
}
