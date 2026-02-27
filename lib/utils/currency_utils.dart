import 'package:intl/intl.dart';

class CurrencyUtils {
  // ينسق الرقم مع فواصل الآلاف، ويلغي الأصفار العشرية الزائدة
  static String format(double amount) {
    final formatter = NumberFormat('#,##0.##', 'en_US');
    return formatter.format(amount);
  }

  // يزيل الفواصل عند تحويل النص إلى رقم مجدداً للحسابات
  static double parse(String formattedAmount) {
    final cleanString = formattedAmount.replaceAll(',', '');
    return double.tryParse(cleanString) ?? 0.0;
  }
}