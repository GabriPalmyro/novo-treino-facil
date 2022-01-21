import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/shared/dialogs/show_custom_alert_dialog.dart';

Future<void> showCustomDialogOpt(
    {@required String title,
    String actionText = 'Ok',
    bool isOnlyOption = false,
    bool isDeleteMessage = false,
    @required Function function,
    @required String message,
    @required BuildContext context}) async {
  await showCustomAlertDialog(
      title: Text(
        title,
        style: TextStyle(
            fontFamily: AppFonts.gothamBold,
            color: isDeleteMessage ? Colors.red : AppColors.mainColor),
      ),
      androidActions: [
        if (!isOnlyOption) ...[
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar',
                  style: TextStyle(
                      fontFamily: AppFonts.gotham, color: Colors.white))),
        ],
        TextButton(
            onPressed: function,
            child: Text(actionText,
                style: TextStyle(
                    fontFamily: AppFonts.gotham,
                    color: isDeleteMessage ? Colors.red : AppColors.mainColor)))
      ],
      iosActions: [
        if (!isOnlyOption) ...[
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar',
                  style: TextStyle(
                      fontFamily: AppFonts.gotham, color: Colors.white)))
        ],
        TextButton(
            onPressed: function,
            child: Text(actionText,
                style: TextStyle(
                    fontFamily: AppFonts.gotham,
                    color: isDeleteMessage ? Colors.red : AppColors.mainColor)))
      ],
      context: context,
      content: Text(
        message,
        style: TextStyle(
            height: 1.1, fontFamily: AppFonts.gotham, color: Colors.white),
      ));
}
