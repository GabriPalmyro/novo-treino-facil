import 'package:flutter/material.dart';

void mostrarSnackBar(
    {@required String message,
    @required Color color,
    @required BuildContext context}) {
  SnackBar snackBar = SnackBar(
    content: Padding(
      padding: const EdgeInsets.only(bottom: 60.0),
      child: Text(message),
    ),
    backgroundColor: color,
  );

  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
