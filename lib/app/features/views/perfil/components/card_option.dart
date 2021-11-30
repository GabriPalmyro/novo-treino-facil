import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/app_colors.dart';

import 'package:tabela_treino/app/core/core.dart';

class CardOption extends StatelessWidget {
  final String title;
  final Function onTap;

  const CardOption({
    this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Container(
          width: width,
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: AppFonts.gotham,
                color: AppColors.black,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
