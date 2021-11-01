import 'package:intl/intl.dart';

String currencyFormat(double amount) {
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  return oCcy.format(amount);
}
