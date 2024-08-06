import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';

class PlanilhaContainer extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String description;

  const PlanilhaContainer({
    required this.onTap,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        width: width * 0.5,
        padding: const EdgeInsets.only(top: 8, bottom: 15, left: 25, right: 25),
        margin: const EdgeInsets.only(top: 8, bottom: 15, left: 10, right: 10),
        decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: AppColors.black.withOpacity(0.4),
                  blurRadius: 6,
                  offset: Offset(0, 6))
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              title,
              style: TextStyle(fontSize: 20, fontFamily: AppFonts.gothamBold),
              textAlign: TextAlign.center,
            ),
            Divider(
              color: AppColors.black.withOpacity(0.4),
              thickness: 0.5,
            ),
            AutoSizeText(
              description,
              maxLines: 2,
              style: TextStyle(fontFamily: AppFonts.gothamBook),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
