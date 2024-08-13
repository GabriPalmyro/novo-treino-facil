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
  final VoidCallback onTap;

  const HomeButton({
    required this.title,
    this.description = '',
    required this.icon,
    required this.iconePath,
    required this.width,
    this.fontSize = 16,
    required this.onTap,
  });

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
            color: _onPressed ? AppColors.lightGrey.withOpacity(0.8) : AppColors.lightGrey,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.3), blurRadius: 6, offset: Offset(0, 4))]),
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 70,
              child: Align(
                alignment: Alignment.topRight,
                child: Image.asset(
                  widget.iconePath,
                  fit: BoxFit.fitHeight,
                ),
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
                    style: TextStyle(fontSize: widget.fontSize, color: AppColors.white, fontFamily: AppFonts.gothamBook),
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

class HomeButtonMin extends StatelessWidget {
  final String title;
  final IconData icon;
  final String iconePath;
  final double width;
  final VoidCallback onTap;
  final String? valueTitle;
  final String? valueLabel;
  final bool isAvailable;

  const HomeButtonMin({
    required this.title,
    required this.icon,
    required this.iconePath,
    required this.width,
    required this.onTap,
    this.isAvailable = true,
    this.valueTitle,
    this.valueLabel,
  });

  @override
  Widget build(BuildContext context) {
    final showValue = valueLabel != null && valueTitle != null;
    return InkWell(
      onTap: onTap,
      child: Opacity(
        opacity: !isAvailable ? 0.3 : 1.0,
        child: SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 80,
                width: width,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.3),
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: showValue ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      iconePath,
                      fit: BoxFit.contain,
                    ),
                    if (showValue) ...[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            valueLabel!,
                            style: TextStyle(
                              fontFamily: AppFonts.gothamBold,
                              color: AppColors.mainColor,
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            valueTitle!,
                            style: TextStyle(
                              fontFamily: AppFonts.gothamLight,
                              color: AppColors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: (width * 0.02)),
                child: AutoSizeText(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(height: 1.1, fontSize: 14, color: AppColors.white, fontFamily: AppFonts.gothamBook),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
