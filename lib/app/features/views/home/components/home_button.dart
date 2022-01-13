import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:tabela_treino/app/core/core.dart';

class HomeButton extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final String iconePath;
  final double width;
  final double fontSize;
  final Function onTap;

  const HomeButton(
      {this.title,
      this.description = '',
      this.icon,
      this.iconePath,
      this.width,
      this.fontSize = 16,
      this.onTap});

  @override
  _HomeButtonState createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> {
  bool _onPressed = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHighlightChanged: (onHover) {
        setState(() {
          _onPressed = onHover;
        });
      },
      child: Container(
        height: 110,
        width: widget.width,
        decoration: BoxDecoration(
            color: _onPressed
                ? AppColors.lightGrey.withOpacity(0.8)
                : AppColors.lightGrey,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: AppColors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: Offset(0, 4))
            ]),
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 70,
              child: Container(
                child: Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      widget.iconePath,
                      fit: BoxFit.fitHeight,
                    )),
              ),
            ),
            Expanded(
              flex: 30,
              child: Container(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: AutoSizeText(
                    widget.title,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: widget.fontSize,
                        color: AppColors.white,
                        fontFamily: AppFonts.gothamBook),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeButtonMin extends StatefulWidget {
  final String title;
  final IconData icon;
  final String iconePath;
  final double width;
  final Function onTap;

  const HomeButtonMin(
      {this.title, this.icon, this.iconePath, this.width, this.onTap});

  @override
  _HomeButtonMinState createState() => _HomeButtonMinState();
}

class _HomeButtonMinState extends State<HomeButtonMin> {
  bool _onPressed = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHighlightChanged: (onHover) {
        setState(() {
          _onPressed = onHover;
        });
      },
      child: Container(
        width: widget.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: 80,
                width: widget.width,
                decoration: BoxDecoration(
                    color: _onPressed
                        ? AppColors.lightGrey.withOpacity(0.8)
                        : AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.black.withOpacity(0.3),
                          blurRadius: 6,
                          offset: Offset(0, 4))
                    ]),
                padding: EdgeInsets.all(8),
                child: Center(
                    child: Image.asset(
                  widget.iconePath,
                  fit: BoxFit.contain,
                ))),
            SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: (widget.width * 0.02)),
              child: AutoSizeText(
                widget.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                    height: 1.1,
                    fontSize: 14,
                    color: AppColors.white,
                    fontFamily: AppFonts.gothamBook),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
