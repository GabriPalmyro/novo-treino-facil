import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_alert_dialog.dart';

Future<void> showCustomAlertDialog(
    {BuildContext context,
    Widget title,
    Widget content,
    List<Widget> androidActions,
    List<Widget> iosActions,
    bool barrierDismissible = false}) async {
  if (Platform.isAndroid) {
    await showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (_) {
          return CustomAlertDialogs(
            title: title,
            content: content,
            androidActions: androidActions,
          );
        });
  }
  if (Platform.isIOS) {
    await showCupertinoDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (_) {
          return CustomAlertDialogs(
            title: title,
            content: content,
            androidActions: iosActions,
          );
        });
  }
}
