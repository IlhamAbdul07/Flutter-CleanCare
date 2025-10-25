import 'package:intl/intl.dart';

class GeneralService {
  static String buildQueryParams(Map<String, String>? params) {
    if (params == null || params.isEmpty) return '';
    return '?${Uri(queryParameters: params).query}';
  }

  static String justBuildQuery(Map<String, String>? params) {
    if (params == null || params.isEmpty) return '';
    return Uri(queryParameters: params).query;
  }

  static String getDateFilter(String filter) {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd'); // Format YYYY-MM-DD
    String startDate = "";
    String endDate = "";

    if (filter == "Today") {
      startDate = formatter.format(now);
      endDate = formatter.format(now);
    } else if (filter == "This Week") {
      DateTime startOfWeek =
          now.subtract(Duration(days: now.weekday - 1)); // Senin awal minggu
      DateTime endOfWeek =
          startOfWeek.add(Duration(days: 6)); // Minggu akhir minggu

      startDate = formatter.format(startOfWeek);
      endDate = formatter.format(endOfWeek);
    } else if (filter == "This Month") {
      DateTime startOfMonth = DateTime(now.year, now.month, 1);
      DateTime endOfMonth =
          DateTime(now.year, now.month + 1, 0); // Hari terakhir bulan ini

      startDate = formatter.format(startOfMonth);
      endDate = formatter.format(endOfMonth);
    }

    return startDate.isNotEmpty && endDate.isNotEmpty
        ? '$startDate' '_' '$endDate'
        : "";
  }
}