import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';

class AppBarRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      shadowColor: Colors.grey[850],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.elliptical(50, 20),
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
            fontSize: 26),
      ),
      backgroundColor: AppColors.mainColor,
    );
  }
}
