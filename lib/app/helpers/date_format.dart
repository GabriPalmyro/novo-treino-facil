DateTime dateFormat(String dateFull) {
  if (dateFull == null || dateFull.isEmpty) {
    return null;
  } else {
    return DateTime.tryParse(dateFull);
  }
}

String dateFormater(DateTime date) {
  if (date == null) {
    return 'Nenhuma data cadastrada';
  } else {
    String day = date.day.toString();
    String month = date.month.toString();
    String year = date.year.toString();
    return day + '/' + month + '/' + year;
  }
}
