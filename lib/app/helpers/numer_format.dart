import 'package:brasil_fields/util/util_brasil_fields.dart';

String showNumber(String numberOld) {
  String number = UtilBrasilFields.removeCaracteres(numberOld);

  var ddd = number.substring(2, 4);
  var numberPhone1 = number.substring(4, 9);
  var numberPhone2 = number.substring(9, 13);
  return "(" + ddd + ")" + " " + numberPhone1 + "-" + numberPhone2;
}
