import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/app_colors.dart';
import 'package:tabela_treino/app/core/app_fonts.dart';

class PersonalContainer extends StatelessWidget {
  final bool isPersonal;
  final bool type;
  final String label;
  final VoidCallback onTap;

  const PersonalContainer({
    required this.isPersonal,
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
            color: isPersonal == type ? AppColors.mainColor : AppColors.grey,
            boxShadow: isPersonal == type
                ? [BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 3, blurRadius: 2, offset: Offset(0, 4))]
                : [BoxShadow(color: Colors.transparent)],
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(color: isPersonal == type ? AppColors.grey : AppColors.mainColor, fontSize: 20, fontFamily: AppFonts.gothamBold),
            ),
          ),
        ));
  }
}
