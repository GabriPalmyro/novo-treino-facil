import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';

class SearchBar extends StatefulWidget {
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
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: AppColors.grey340),
        child: TextField(
          controller: widget.controller,
          focusNode: widget.node,
          style: TextStyle(
              fontFamily: AppFonts.gotham,
              color: AppColors.mainColor,
              fontSize: 16.0),
          textAlignVertical: TextAlignVertical.center,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            border: InputBorder.none,
            suffixIcon: hidingIcon(),
            alignLabelWithHint: true,
            hintText: 'Pesquisar',
            hintStyle: TextStyle(
                fontFamily: AppFonts.gotham,
                color: AppColors.mainColor,
                fontSize: 16.0),
            // suffixIcon: Icon(
            //   Icons.close,
            //   color: AppColors.mainColor,
            // ),
          ),
          onSubmitted: widget.onSubmitted,
          onChanged: (text) {
            setState(() {
              searchText = text;
            });
          },
        ),
      ),
    );
  }

  Widget hidingIcon() {
    if (searchText.isNotEmpty) {
      return IconButton(
          icon: Icon(
            Icons.clear,
            color: AppColors.mainColor,
          ),
          splashColor: Colors.redAccent,
          onPressed: () {
            setState(() {
              widget.controller.clear();
              searchText = "";
            });
          });
    } else {
      return null;
    }
  }
}
