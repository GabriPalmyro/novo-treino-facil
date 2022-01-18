import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';

class ExerciciosPlanilhaVazia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.8,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: width * 0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoSizeText(
            "Você ainda não possui nenhum exercício",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22,
                fontFamily: AppFonts.gothamLight,
                color: Colors.white,
                height: 1.2),
          ),
          SizedBox(
            height: 12,
          ),
          Icon(Icons.sentiment_dissatisfied_rounded,
              size: 36, color: AppColors.mainColor),
          SizedBox(
            height: 32,
          ),
          AutoSizeText(
            "Clique no botão",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22,
                fontFamily: AppFonts.gothamLight,
                color: Colors.white,
                height: 1.2),
          ),
          SizedBox(
            height: 12,
          ),
          Icon(Icons.add_circle_outline, size: 36, color: AppColors.mainColor),
          SizedBox(
            height: 12,
          ),
          AutoSizeText(
            "Para adicionar um novo exercício",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22,
                fontFamily: AppFonts.gothamLight,
                color: Colors.white,
                height: 1.2),
          ),
        ],
      ),
    );
  }
}
