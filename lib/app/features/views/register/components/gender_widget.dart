import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/app_colors.dart';
import 'package:tabela_treino/app/core/app_fonts.dart';

class GenderContainer extends StatelessWidget {
  final int sexo;
  final int type;
  final String label;
  final VoidCallback onTap;

  const GenderContainer({
    required this.sexo,
    required this.type,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
        margin: EdgeInsets.all(10),
        width: 130,
        height: 40,
        decoration: BoxDecoration(
          boxShadow: sexo == type
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(color: Colors.transparent),
                ],
          color: sexo == type ? AppColors.mainColor : AppColors.grey,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: sexo == type ? AppColors.grey : AppColors.mainColor,
              fontSize: 20,
              fontFamily: AppFonts.gothamBold,
            ),
          ),
        ),
      ),
    );
  }
}
