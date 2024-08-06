DateTime? dateFormat(String dateFull) {
  if (dateFull.isEmpty) {
    return null;
  } else {
    return DateTime.tryParse(dateFull);
  }
}

String dateFormater(DateTime date) {
  String day = date.day.toString();
  String month = date.month.toString();
  String year = date.year.toString();
  return day + '/' + month + '/' + year;
}
