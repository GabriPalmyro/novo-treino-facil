import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';

class SearchBar extends StatelessWidget {
  final Function onPressed;
  final Function onSubmitted;
  final TextEditingController controller;
  final FocusNode node;

  const SearchBar(
      {@required this.onPressed,
      @required this.onSubmitted,
      @required this.controller,
      @required this.node});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: width * 0.95,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: AppColors.grey340),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: node,
                style: TextStyle(
                    fontFamily: AppFonts.gotham,
                    color: AppColors.mainColor,
                    fontSize: 16.0),
                decoration: InputDecoration(
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  border: InputBorder.none,

                  hintText: 'Insira o nickname aqui',
                  hintStyle: TextStyle(
                      fontFamily: AppFonts.gotham,
                      color: AppColors.mainColor,
                      fontSize: 14.0),
                  // suffixIcon: Icon(
                  //   Icons.close,
                  //   color: AppColors.mainColor,
                  // ),
                ),
                onSubmitted: onSubmitted,
              ),
            ),
            IconButton(
              onPressed: onPressed,
              icon: Icon(
                Icons.search,
                color: AppColors.mainColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
