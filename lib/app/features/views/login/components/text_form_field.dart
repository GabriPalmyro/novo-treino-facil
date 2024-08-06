import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tabela_treino/app/core/core.dart';

class LoginTextFormField extends StatefulWidget {
  final TextInputType? textInputType;
  final TextEditingController textController;
  final Color textColor;
  final Color labelColor;
  final String labelText;
  final String? Function(String?)? validator;
  final Function(String) onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isObscure;
  final bool enable;
  final double width;
  final FocusNode? focusNode;

  const LoginTextFormField({
    required this.textController,
    required this.textColor,
    required this.labelColor,
    required this.labelText,
    required this.width,
    required this.onFieldSubmitted,
    this.isObscure = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.inputFormatters,
    this.enable = true,
    this.focusNode,
    this.textInputType,
  });

  @override
  _LoginTextFormFieldState createState() => _LoginTextFormFieldState();
}

class _LoginTextFormFieldState extends State<LoginTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(color: AppColors.lightGrey.withOpacity(0.8), borderRadius: BorderRadius.circular(4)),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: TextFormField(
          keyboardType: widget.textInputType,
          controller: widget.textController,
          obscureText: widget.isObscure,
          enabled: widget.enable,
          onFieldSubmitted: widget.onFieldSubmitted,
          focusNode: widget.focusNode,
          style: TextStyle(fontFamily: AppFonts.gotham, color: widget.textColor, fontSize: 16.0),
          showCursor: true,
          enableInteractiveSelection: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorStyle: TextStyle(fontFamily: AppFonts.gotham, color: AppColors.red),
            labelText: widget.labelText,
            labelStyle: TextStyle(fontFamily: AppFonts.gotham, color: widget.labelColor),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
          ),
          inputFormatters: widget.inputFormatters,
          validator: widget.validator),
    );
  }
}
