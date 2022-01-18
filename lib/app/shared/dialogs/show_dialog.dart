import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/shared/dialogs/show_custom_alert_dialog.dart';

Future<void> showCustomDialogOpt(
    {@required Function function,
    @required String message,
    @required BuildContext context}) async {
  await showCustomAlertDialog(
      title: Text(
        'Cancelar a adição desse(s) exercício(s)?',
        style: TextStyle(
            fontFamily: AppFonts.gothamBold, color: AppColors.mainColor),
      ),
      androidActions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancelar',
                style: TextStyle(
                    fontFamily: AppFonts.gotham, color: Colors.white))),
        TextButton(
            onPressed: function,
            child: Text('Ok',
                style: TextStyle(
                    fontFamily: AppFonts.gotham, color: AppColors.mainColor)))
      ],
      iosActions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancelar',
                style: TextStyle(
                    fontFamily: AppFonts.gotham, color: Colors.white))),
        TextButton(
            onPressed: function,
            child: Text('Ok',
                style: TextStyle(
                    fontFamily: AppFonts.gotham, color: AppColors.mainColor)))
      ],
      context: context,
      content: Text(
        message,
        style: TextStyle(
            height: 1.1, fontFamily: AppFonts.gotham, color: Colors.white),
      ));
}
