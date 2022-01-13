import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:tabela_treino/app/core/core.dart';

class CustomButton extends StatefulWidget {
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
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _onPressed = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      enableFeedback: true,
      onHighlightChanged: (onHover) {
        setState(() {
          _onPressed = onHover;
        });
      },
      child: AnimatedContainer(
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
            vertical: widget.verticalPad, horizontal: widget.horizontalPad),
        decoration: BoxDecoration(
            color: _onPressed ? widget.color.withOpacity(0.8) : widget.color,
            borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: AutoSizeText(
            widget.text,
            style: TextStyle(
              color: widget.textColor,
              fontFamily: AppFonts.gotham,
            ),
          ),
        ),
      ),
    );
  }
}
