import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tabela_treino/app/core/core.dart';

class CustomTextInputWidget extends StatelessWidget {
  final TextInputType? textInputType;
  final TextEditingController? textController;
  final Color textColor;
  final Color hintColor;
  final String hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isObscure;
  final bool enable;
  final double width;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final String? suffixText;
  final Function(PointerDownEvent)? onTapOutside;

  const CustomTextInputWidget({
    this.textController,
    required this.textColor,
    required this.hintColor,
    required this.hintText,
    required this.width,
    this.isObscure = false,
    this.prefixIcon,
    this.onChanged,
    this.textInputAction,
    this.suffixIcon,
    this.inputFormatters,
    this.enable = true,
    this.focusNode,
    this.textInputType,
    this.suffixText,
    this.onTapOutside,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withOpacity(0.8),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      child: TextField(
        keyboardType: textInputType,
        controller: textController,
        obscureText: isObscure,
        enabled: enable,
        focusNode: focusNode,
        maxLines: null,
        onChanged: onChanged,
        textInputAction: textInputAction,
        onTapOutside: onTapOutside,
        style: TextStyle(color: textColor, fontSize: 16.0, height: 1.2),
        enableInteractiveSelection: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: hintColor),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          suffixText: suffixText,
          suffixStyle: TextStyle(color: textColor),
        ),
        inputFormatters: inputFormatters,
      ),
    );
  }
}
