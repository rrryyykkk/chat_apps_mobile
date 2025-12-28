import 'package:intl/intl.dart';

class DateUtilsHelper {
  /// Format jam:menit (e.g. 14:30)
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  /// Format tanggal (e.g. 12 Oct)
  static String formatDate(DateTime date) {
    return DateFormat('d MMM').format(date);
  }

  /// Format lengkap (e.g. 12 Oct 2023, 14:30)
  static String formatDateTime(DateTime date) {
    return DateFormat('d MMM y, HH:mm').format(date);
  }
}
