import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:tabela_treino/app/core/core.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final Function onTap;
  final double width;
  final double height;
  final double verticalPad;
  final double horizontalPad;

  const CustomButton(
      {@required this.text,
      @required this.color,
      @required this.textColor,
      @required this.onTap,
      this.verticalPad = 12,
      this.horizontalPad = 10,
      this.height = 40,
      this.width = 130});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: verticalPad, horizontal: horizontalPad),
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: AutoSizeText(
            text,
            style: TextStyle(
              color: textColor,
              fontFamily: AppFonts.gotham,
            ),
          ),
        ),
      ),
    );
  }
}
