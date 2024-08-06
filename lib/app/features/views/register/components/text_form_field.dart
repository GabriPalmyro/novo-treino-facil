import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tabela_treino/app/core/core.dart';

class CustomTextFormField extends StatefulWidget {
  final TextInputType textInputType;
  final TextEditingController textController;
  final Color textColor;
  final Color labelColor;
  final String labelText;
  final String? Function(String?)? validator;
  final Function(String)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final bool isObscure;
  final bool enable;
  final double width;

  const CustomTextFormField({
    required this.textInputType,
    required this.textController,
    required this.textColor,
    required this.labelColor,
    required this.labelText,
    this.isObscure = false,
    this.suffixIcon,
    this.validator,
    this.onSubmitted,
    this.focusNode,
    required this.enable,
    this.inputFormatters,
    required this.width,
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(color: AppColors.lightGrey.withOpacity(0.8), borderRadius: BorderRadius.circular(4)),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        keyboardType: widget.textInputType,
        controller: widget.textController,
        focusNode: widget.focusNode,
        enabled: widget.enable,
        onFieldSubmitted: widget.onSubmitted,
        style: TextStyle(fontFamily: AppFonts.gotham, color: widget.textColor),
        showCursor: true,
        enableInteractiveSelection: true,
        obscureText: widget.isObscure,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(fontFamily: AppFonts.gotham, color: widget.labelColor),
          suffixIcon: widget.suffixIcon,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        inputFormatters: widget.inputFormatters,
        validator: widget.validator,
      ),
    );
  }
}
