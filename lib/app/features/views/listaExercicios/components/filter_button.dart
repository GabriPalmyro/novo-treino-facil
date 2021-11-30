import 'package:flutter/material.dart';

import 'package:tabela_treino/app/core/core.dart';

class FilterButton extends StatelessWidget {
  final Function onTap;
  final String selectedType;
  final String filter;
  final String title;

  const FilterButton({
    this.onTap,
    this.selectedType,
    this.filter,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
        decoration: BoxDecoration(
          color: selectedType == filter
              ? AppColors.mainColor
              : AppColors.mainColor.withOpacity(0.6),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.7),
              spreadRadius: 0.5,
              blurRadius: 2,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          "$title",
          style: TextStyle(fontFamily: AppFonts.gothamBook, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
