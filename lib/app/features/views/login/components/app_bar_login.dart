import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';

class AppBarLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 120,
      shadowColor: Colors.grey[850],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.elliptical(300, 50),
        ),
      ),
      elevation: 25,
      centerTitle: true,
      title: Image.asset(
        'images/logo.png',
        height: 120,
      ),
      backgroundColor: AppColors.mainColor,
    );
  }
}
