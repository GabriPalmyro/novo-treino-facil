import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';

class ButtonContinue extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ButtonContinue({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Container(
          width: width,
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
          decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: AppFonts.gotham,
                color: AppColors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
