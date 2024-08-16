import 'package:flutter/material.dart';

void mostrarSnackBar({
  required String message,
  required Color color,
  required BuildContext context,
}) {
  SnackBar snackBar = SnackBar(
    content: Text(message),
    backgroundColor: color,
    dismissDirection: DismissDirection.up,
    // behavior: SnackBarBehavior.floating,
    // margin: EdgeInsets.only(
    //   bottom: MediaQuery.of(context).size.height - 150,
    //   left: 10,
    //   right: 10,
    // ),
  );

  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
