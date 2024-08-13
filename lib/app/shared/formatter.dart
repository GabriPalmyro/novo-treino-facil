import 'package:intl/intl.dart';

class MoneyFormatter {
  static String format(double amount, {String locale = 'pt_BR', String currencySymbol = 'R\$'}) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: locale,
      symbol: currencySymbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  static String formatWithoutSymbol(double amount, {String locale = 'pt_BR'}) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: locale,
      symbol: '',
      decimalDigits: 2,
    );
    return formatter.format(amount).trim();
  }

  static String formatWithCustomPattern(double amount, {String pattern = '#,##0.00'}) {
    final NumberFormat formatter = NumberFormat(pattern);
    return formatter.format(amount);
  }
}