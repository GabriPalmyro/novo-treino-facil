import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/app_colors.dart';
import 'package:tabela_treino/app/core/core.dart';

class AppBarRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      shadowColor: Colors.grey[850],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.elliptical(200, 40),
        ),
      ),
      elevation: 20,
      centerTitle: true,
      title: Text(
        "Registrar\nnova conta",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.grey[850],
            fontFamily: AppFonts.gothamBold,
            fontSize: 30),
      ),
      backgroundColor: AppColors.mainColor,
    );
  }
}
