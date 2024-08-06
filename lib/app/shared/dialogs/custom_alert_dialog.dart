import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/app_colors.dart';

class CustomAlertDialogs extends StatelessWidget {
  const CustomAlertDialogs({
    required this.title,
    required this.content,
    this.androidActions,
    this.iosActions,
  });

  final Widget title;
  final Widget content;
  final List<Widget>? androidActions;
  final List<Widget>? iosActions;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: title,
        content: content,
        actions: iosActions ?? [],
      );
    }

    return AlertDialog(
      title: title,
      content: content,
      backgroundColor: AppColors.grey,
      actions: androidActions ?? [],
    );
  }
}
