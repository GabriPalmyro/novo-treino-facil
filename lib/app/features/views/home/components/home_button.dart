import 'package:flutter/material.dart';

import 'package:tabela_treino/app/core/core.dart';

class HomeButton extends StatefulWidget {
  final String title;
  final String description;
  final bool isMainColor;
  final Function onTap;

  const HomeButton(
      {this.title, this.description, this.isMainColor, this.onTap});

  @override
  _HomeButtonState createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
            color: widget.isMainColor ? AppColors.mainColor : AppColors.grey300,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: AppColors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: Offset(0, 5))
            ]),
        padding: const EdgeInsets.fromLTRB(15, 20, 20, 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 28,
                  color: widget.isMainColor ? AppColors.grey : AppColors.white,
                  fontFamily: AppFonts.gothamBold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                widget.description,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        widget.isMainColor ? AppColors.grey : AppColors.white,
                    fontFamily: AppFonts.gothamBook),
              ),
            )
          ],
        ),
      ),
    );
  }
}
